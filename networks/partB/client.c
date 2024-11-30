#define _POSIX_C_SOURCE 199309L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/epoll.h>
#include <fcntl.h>
#include <errno.h>
#include <time.h>

#define MAX_BUFFER 1024
#define MAX_EVENTS 10
#define SERVER_PORT 8080
#define CHUNK_SIZE 5
#define TIMEOUT_MS 100
#define RETRANSMISSION_TIMEOUT_MS 100

typedef struct {
    int seq_no;
    int total_chunks;
    char data[CHUNK_SIZE];
    struct timespec last_sent;
} chunk;

typedef struct node {
    chunk data;
    struct node* next;
} node;

int sending_data = 1;
node* chunk_list = NULL;
node* received_chunks = NULL;

void add_chunk(node** list, chunk c) {
    node* new_node = malloc(sizeof(node));
    new_node->data = c;
    new_node->next = NULL;

    if (*list == NULL) *list = new_node;
    else {
        node* current = *list;
        while (current->next != NULL) current = current->next;
        current->next = new_node;
    }
}

void remove_chunk(node** list, int seq_no) {
    node* current = *list;
    node* prev = NULL;

    while (current != NULL) {
        if (current->data.seq_no == seq_no) {
            if (prev == NULL) *list = current->next;
            else prev->next = current->next;
            free(current);
            return;
        }
        prev = current;
        current = current->next;
    }
}

void print_received_message() {
    if (received_chunks == NULL) return;

    int total_chunks = received_chunks->data.total_chunks;
    char* message = calloc(total_chunks * CHUNK_SIZE + 1, sizeof(char));
    
    for (int i = 0; i < total_chunks; i++) {
        node* current = received_chunks;
        while (current != NULL && current->data.seq_no != i) current = current->next;
        if (current != NULL) strncat(message, current->data.data, CHUNK_SIZE);
    }

    printf("Received message: %s\n", message);
    free(message);

    while (received_chunks != NULL) {
        node* temp = received_chunks;
        received_chunks = received_chunks->next;
        free(temp);
    }
}

int random_number() {
    int random = rand() % 5;
    if (random == 0) return 2;
    if (random == 1) return 3;
    if (random == 2) return 5;
    if (random == 3) return 7;
    return 11;
}

int map[1000000];

int main() {
    struct sockaddr_in server_addr;
    
    int sockfd;
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        printf("Socket creation failed");
        fflush(stdout);
        exit(EXIT_FAILURE);
    }

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(SERVER_PORT);
    server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");


    int flags = fcntl(sockfd, F_GETFL, 0);
    // remember to check for -1
    if (flags == -1) return -1;
    if (fcntl(sockfd, F_SETFL, flags | O_NONBLOCK) < 0) {
        printf("Failed to set socket to non-blocking");
        fflush(stdout);
        exit(EXIT_FAILURE);
    }

    int epollfd;
    epollfd = epoll_create1(0);
    if (epollfd == -1) {
        printf("Epoll create failed");
        fflush(stdout);
        exit(EXIT_FAILURE);
    }

    struct epoll_event ev, events[MAX_EVENTS];
    ev.events = EPOLLIN;
    ev.data.fd = sockfd;
    if (epoll_ctl(epollfd, EPOLL_CTL_ADD, sockfd, &ev) == -1) {
        printf("Epoll control failed");
        fflush(stdout);
        exit(EXIT_FAILURE);
    }

    char buffer[MAX_BUFFER];
    struct timespec current_time;

    while (1) {
        int nfds = epoll_wait(epollfd, events, MAX_EVENTS, TIMEOUT_MS);
        if (nfds == -1) {
            printf("Epoll wait failed");
            fflush(stdout);
            exit(EXIT_FAILURE);
        }

        clock_gettime(CLOCK_MONOTONIC, &current_time);

        for (int n = 0; n < nfds; ++n) {
            if (events[n].data.fd == sockfd) {
                int len = recvfrom(sockfd, buffer, MAX_BUFFER, 0, NULL, NULL);
                if (len > 0) {
                    chunk received_chunk;
                    memcpy(&received_chunk, buffer, sizeof(chunk));
                    if (sending_data) {
                        printf("ACK received for chunk: seq_no=%d\n", received_chunk.seq_no);
                        remove_chunk(&chunk_list, received_chunk.seq_no);
                        if (chunk_list == NULL) {
                            sending_data = 0;
                            printf("All chunks sent and acknowledged.\n");
                        }
                    } 
                    else {
                        add_chunk(&received_chunks, received_chunk);
                        
                        sendto(sockfd, &received_chunk, sizeof(chunk), 0, (struct sockaddr*)&server_addr, sizeof(server_addr));
                        printf("ACK sent for chunk: seq_no=%d\n", received_chunk.seq_no);

                        if (received_chunks->data.total_chunks == received_chunk.seq_no + 1) {
                            print_received_message();
                            sending_data = 1;
                        }

                        // // Send ACK with random probability
                        // if (random_number() == 2 || random_number() == 5 || random_number() == 11) {
                        //     sendto(sockfd, &received_chunk, sizeof(chunk), 0, (struct sockaddr*)&server_addr, sizeof(server_addr));
                        //     printf("ACK sent for chunk: seq_no=%d\n", received_chunk.seq_no);
                        //     map[received_chunk.seq_no] = 1;
                        // }
                        // else {
                        //     printf("ACK not sent for chunk: seq_no=%d\n", received_chunk.seq_no);
                        //     map[received_chunk.seq_no] = 0;
                        // }

                        // int total_chunks = received_chunk.total_chunks, count_chunks = 0;
                        // for (int i = 0; i < total_chunks; i++) {
                        //     if (map[i] == 1) {
                        //         count_chunks++;
                        //     }
                        // }
                        // if (count_chunks == total_chunks) {
                        //     print_received_message();
                        //     sending_data = 1;
                        //     memset(map, 0, sizeof(map));
                        // }

                        
                    }
                }
            }
        }

        if (sending_data && chunk_list != NULL) {
            node* current = chunk_list;
            while (current != NULL) {
                struct timespec diff;
                diff.tv_sec = current_time.tv_sec - current->data.last_sent.tv_sec;
                diff.tv_nsec = current_time.tv_nsec - current->data.last_sent.tv_nsec;
                long diff_ms = diff.tv_sec * 1000 + diff.tv_nsec / 1000000;

                if (diff_ms >= RETRANSMISSION_TIMEOUT_MS) {
                    sendto(sockfd, &(current->data), sizeof(chunk), 0, (struct sockaddr*)&server_addr, sizeof(server_addr));
                    printf("Chunk retransmitted: seq_no=%d\n", current->data.seq_no);
                    current->data.last_sent = current_time;
                }
                current = current->next;
            }
        } 
        else if (sending_data && chunk_list == NULL) {
            char input[MAX_BUFFER];
            printf("Enter message to send: ");
            fgets(input, MAX_BUFFER, stdin);
            input[strcspn(input, "\n")] = 0;  
            int total_chunks = (strlen(input) + CHUNK_SIZE - 1) / CHUNK_SIZE;
            for (int i = 0; i < total_chunks; i++) {
                chunk new_chunk;
                new_chunk.seq_no = i;
                new_chunk.total_chunks = total_chunks;
                strncpy(new_chunk.data, input + i * CHUNK_SIZE, CHUNK_SIZE);
                clock_gettime(CLOCK_MONOTONIC, &new_chunk.last_sent);
                add_chunk(&chunk_list, new_chunk);
            }
        }
    }
    close(sockfd);
    close(epollfd);
    return 0;
}