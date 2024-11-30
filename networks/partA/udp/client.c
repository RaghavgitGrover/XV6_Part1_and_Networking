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
    // struct sockaddr_in server_addr;
    // socklen_t addr_len = sizeof(server_addr);
    // int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    // server_addr.sin_family = AF_INET;
    // server_addr.sin_port = htons(8080);
    // inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr);
    // sendto(sockfd, "", 1, 0, (struct sockaddr *)&server_addr, addr_len);

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <server_ip>\n", argv[0]);
        exit(1);
    }

    struct sockaddr_in server_addr;
    socklen_t addr_len = sizeof(server_addr);
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(8080);
    inet_pton(AF_INET, argv[1], &server_addr.sin_addr);

    sendto(sockfd, "", 1, 0, (struct sockaddr *)&server_addr, addr_len);

    char buffer[BUFFER_SIZE];
    while (1) {
        memset(buffer, 0, sizeof(buffer));
        recvfrom(sockfd, buffer, BUFFER_SIZE, 0, (struct sockaddr *)&server_addr, &addr_len);
        buffer[BUFFER_SIZE - 1] = '\0'; 
        printf("%s", buffer);
        fflush(stdout);  

        if (strstr(buffer, "Do you want to play again?")) {
            memset(buffer, 0, sizeof(buffer));
            fgets(buffer, BUFFER_SIZE, stdin);  
            while (strncmp(buffer, "yes\n", 4) != 0 && strncmp(buffer, "no\n", 3) != 0) {
                printf("Please answer 'yes' or 'no':\n");
                fflush(stdout);
                fgets(buffer, BUFFER_SIZE, stdin);
                buffer[strcspn(buffer, "\n")] = '\0';  
            }
            sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)&server_addr, addr_len);  // Send response to server
            recvfrom(sockfd, buffer, BUFFER_SIZE, 0, (struct sockaddr *)&server_addr, &addr_len);  // Receive response from server
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
            int row, col, flag = 0;
            while (!flag) {
                printf("Enter your move (row and column): \n");
                char input[BUFFER_SIZE];
                fgets(input, BUFFER_SIZE, stdin);  
                if (sscanf(input, "%d %d", &row, &col) == 2) {
                    if (row >= 1 && row <= 3 && col >= 1 && col <= 3) flag = 1;
                    else printf("Invalid value of row or column. Try again.\n");
                } 
                else printf("Invalid input! Format : row_num {space} col_num. Try again.\n");
            }
            row--;
            col--;
            memset(buffer, 0, BUFFER_SIZE);
            snprintf(buffer, BUFFER_SIZE, "%d %d", row, col);
            sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)&server_addr, addr_len);  // Send move to server
        }
    }
    close(sockfd);
    return 0;
}
