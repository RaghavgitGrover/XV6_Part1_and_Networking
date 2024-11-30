#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#define BUFFER_SIZE 1024

void print_empty_board() {
    printf("\n   |   |   \n---|---|---\n   |   |   \n---|---|---\n   |   |   \n");
    fflush(stdout); 
}

int main(int argc, char *argv[]) {
    // struct sockaddr_in serv_addr;
    // int sockfd;
    // if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
    //     printf("Socket creation error \n");
    //     fflush(stdout);
    //     return -1;
    // }
    // serv_addr.sin_family = AF_INET;
    // serv_addr.sin_port = htons(8080);
    // if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0) {
    //     printf("Invalid address/ Address not supported \n");
    //     fflush(stdout);
    //     return -1;
    // }
    // if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
    //     printf("Connection Failed \n");
    //     fflush(stdout);
    //     return -1;
    // }
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <server_ip>\n", argv[0]);
        exit(1);
    }

    const char *server_ip = argv[1];

    struct sockaddr_in serv_addr;
    int sockfd;

    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("Socket creation error \n");
        fflush(stdout);
        return -1;
    }

    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(8080);

    if (inet_pton(AF_INET, server_ip, &serv_addr.sin_addr) <= 0) {
        printf("Invalid address/ Address not supported \n");
        fflush(stdout);
        return -1;
    }

    if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        printf("Connection Failed \n");
        fflush(stdout);
        return -1;
    }

    printf("Connected to server at %s\n", server_ip);
    fflush(stdout);

    char buffer[1024];

    while (1) {
        memset(buffer, 0, sizeof(buffer));
        recv(sockfd, buffer, 1024, 0);
        buffer[BUFFER_SIZE - 1] = '\0';
        printf("%s", buffer);
        fflush(stdout);

        if (strstr(buffer, "Do you want to play again?")) {
            memset(buffer, 0, sizeof(buffer));
            fgets(buffer, 1024, stdin); 
            while (strncmp(buffer, "yes", 3) != 0 && strncmp(buffer, "no", 2) != 0) {
                printf("Please enter 'yes' or 'no'\n");
                fflush(stdout);
                memset(buffer, 0, sizeof(buffer));
                fgets(buffer, 1024, stdin);
                buffer[BUFFER_SIZE - 1] = '\0';
            }
            // printf("%s\n", buffer);
            send(sockfd, buffer, strlen(buffer), 0);  
            recv(sockfd, buffer, 1024, 0); 
            buffer[BUFFER_SIZE - 1] = '\0';  
            if (strstr(buffer, "Game over, both")) break;
            else if (strstr(buffer, "Game over")) {
                printf("%s", buffer);
                fflush(stdout);
                break;
            }
            else print_empty_board();
        }
        if (strstr(buffer, "Your turn")) {
            fgets(buffer, 1024, stdin);  
            send(sockfd, buffer, strlen(buffer), 0);  
        }
    }
    close(sockfd);
    return 0;
}
