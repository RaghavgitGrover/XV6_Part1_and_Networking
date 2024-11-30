#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#define BUFFER_SIZE 1024

char board[3][3];
int current_player = 1;

int decide_win() {
    if (board[0][0] == board[0][1] && board[0][1] == board[0][2] && board[0][0] != ' ') return (board[0][0] == 'X') ? 1 : 2;
    else if (board[1][0] == board[1][1] && board[1][1] == board[1][2] && board[1][0] != ' ') return (board[1][0] == 'X') ? 1 : 2;
    else if (board[2][0] == board[2][1] && board[2][1] == board[2][2] && board[2][0] != ' ') return (board[2][0] == 'X') ? 1 : 2;
    else if (board[0][0] == board[1][0] && board[1][0] == board[2][0] && board[0][0] != ' ') return (board[0][0] == 'X') ? 1 : 2;
    else if (board[0][1] == board[1][1] && board[1][1] == board[2][1] && board[0][1] != ' ') return (board[0][1] == 'X') ? 1 : 2;
    else if (board[0][2] == board[1][2] && board[1][2] == board[2][2] && board[0][2] != ' ') return (board[0][2] == 'X') ? 1 : 2;

    else if (board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[0][0] != ' ') return (board[0][0] == 'X') ? 1 : 2;
    else if (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[0][2] != ' ') return (board[0][2] == 'X') ? 1 : 2;
    return 0;
}

int decide_draw() {
    for (int i = 0; i < 3; i++) for (int j = 0; j < 3; j++) if (board[i][j] == ' ') return 0;
    return 1;
}

void reset_board() {
    for (int i = 0; i < 3; i++) for (int j = 0; j < 3; j++) board[i][j] = ' ';
    return;
}

void send_board(int sockfd, struct sockaddr_in* client, socklen_t addr_len) {
    char buffer[BUFFER_SIZE];
    snprintf(buffer, BUFFER_SIZE,
             "\n %c | %c | %c \n---|---|---\n %c | %c | %c \n---|---|---\n %c | %c | %c \n\n",
             board[0][0], board[0][1], board[0][2],
             board[1][0], board[1][1], board[1][2],
             board[2][0], board[2][1], board[2][2]);
    sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)client, addr_len);
}

void game(int sockfd, struct sockaddr_in* client1, struct sockaddr_in* client2) {
    reset_board();
    int row, col, winner = 0;
    socklen_t addr_len = sizeof(*client1);
    char buffer[BUFFER_SIZE];
    fflush(stdout);
    sprintf(buffer, "\n %c | %c | %c \n---|---|---\n %c | %c | %c \n---|---|---\n %c | %c | %c \n\n", board[0][0], board[0][1], board[0][2], board[1][0], board[1][1], board[1][2], board[2][0], board[2][1], board[2][2]);
    send_board(sockfd, client1, addr_len);
    send_board(sockfd, client2, addr_len);

    while (1) {      
        struct sockaddr_in *current_client, *waiting_client;
        if (current_player == 1) {
            current_client = client1;
            waiting_client = client2;
        }
        else 
        {
            current_client = client2;
            waiting_client = client1;
        }
        memset(buffer, 0, sizeof(buffer));
        fflush(stdout);
        snprintf(buffer, BUFFER_SIZE, "\nYour turn, Player %d (enter row and column):\n", current_player);
        sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)current_client, addr_len);
        memset(buffer, 0, sizeof(buffer));
        fflush(stdout);
        sprintf(buffer, "\nWaiting for Player %d to make a move...\n\n", current_player);
        sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)waiting_client, addr_len);

        memset(buffer, 0, sizeof(buffer));
        recvfrom(sockfd, buffer, BUFFER_SIZE, 0, (struct sockaddr *)current_client, &addr_len);
        sscanf(buffer, "%d %d", &row, &col);

        if (board[row][col] != ' ' || row < 0 || row > 2 || col < 0 || col > 2) {
            memset(buffer, 0, sizeof(buffer));
            fflush(stdout);
            sprintf(buffer, "Invalid move, try again!\n");
            sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)current_client, addr_len);
        } 
        else {
            if (current_player == 1) board[row][col] = 'X';
            else board[row][col] = 'O';
            memset(buffer, 0, sizeof(buffer));
            fflush(stdout);
            sprintf(buffer, "\n %c | %c | %c \n---|---|---\n %c | %c | %c \n---|---|---\n %c | %c | %c \n", board[0][0], board[0][1], board[0][2], board[1][0], board[1][1], board[1][2], board[2][0], board[2][1], board[2][2]);
            sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)client1, addr_len);
            sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)client2, addr_len);

            winner = decide_win();
            if (winner || decide_draw()) break;
            current_player = 3 - current_player;
        }
    }

    if (winner) {
        memset(buffer, 0, sizeof(buffer));
        fflush(stdout);
        sprintf(buffer, "Player %d wins!\n", winner);
    }
    else {
        memset(buffer, 0, sizeof(buffer));
        fflush(stdout);
        sprintf(buffer, "It's a draw!\n");
    }

    sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)client1, addr_len);
    sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)client2, addr_len);
}

int main(int argc, char *argv[]) {
    // struct sockaddr_in server_addr, client1, client2;
    // socklen_t addr_len = sizeof(client1);
    // int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    //     if (sockfd < 0) {
    //     perror("socket creation failed");
    //     exit(EXIT_FAILURE);
    // }
    // memset(&server_addr, 0, sizeof(server_addr));
    // fflush(stdout);
    // server_addr.sin_family = AF_INET;
    // server_addr.sin_addr.s_addr = INADDR_ANY;
    // server_addr.sin_port = htons(8080);
    // if (bind(sockfd, (struct sockaddr *) &server_addr, sizeof(server_addr)) < 0) {
    //     perror("bind failed");
    //     exit(EXIT_FAILURE);
    // }
    // printf("waiting for players to connect\n");
    // fflush(stdout);

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <server_ip>\n", argv[0]);
        exit(1);
    }

    struct sockaddr_in server_addr, client1, client2;
    socklen_t addr_len = sizeof(client1);
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    memset(&server_addr, 0, sizeof(server_addr));
    fflush(stdout);
    server_addr.sin_family = AF_INET;
    if (inet_pton(AF_INET, argv[1], &server_addr.sin_addr) <= 0) {
        perror("Invalid address/ Address not supported");
        exit(EXIT_FAILURE);
    }
    server_addr.sin_port = htons(8080);
    if (bind(sockfd, (struct sockaddr *) &server_addr, sizeof(server_addr)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    printf("Server is running on IP: %s, Port: 8080\n", argv[1]);
    printf("Waiting for players to connect\n");
    fflush(stdout);
    recvfrom(sockfd, NULL, 0, 0, (struct sockaddr*) &client1, &addr_len);
    printf("Player 1 connected\n");
    fflush(stdout);
    recvfrom(sockfd, NULL, 0, 0, (struct sockaddr *) &client2, &addr_len);
    printf("Player 2 connected\n");
    fflush(stdout);

    char buffer[BUFFER_SIZE];

restart:
    game(sockfd, &client1, &client2);
    memset(buffer, 0, sizeof(buffer));
    snprintf(buffer, sizeof(buffer), "Do you want to play again? (yes/no)\n");
    sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)&client1, addr_len);
    sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)&client2, addr_len);

    int player1_response = 0, player2_response = 0;
    memset(buffer, 0, sizeof(buffer));
    recvfrom(sockfd, buffer, BUFFER_SIZE, 0, (struct sockaddr *) &client1, &addr_len);
    if (strcmp(buffer, "yes\n") == 0) player1_response = 1;
    memset(buffer, 0, sizeof(buffer));
    recvfrom(sockfd, buffer, BUFFER_SIZE, 0, (struct sockaddr *) &client2, &addr_len);
    if (strcmp(buffer, "yes\n") == 0) player2_response = 1;

    printf("Player 1 response: %d\n", player1_response);
    printf("Player 2 response: %d\n", player2_response);

    if (player1_response == 0 || player2_response == 0) {
        char response1[BUFFER_SIZE], response2[BUFFER_SIZE];
        memset(response1, 0, sizeof(response1));
        memset(response2, 0, sizeof(response2));
        if (player1_response == 0 && player2_response == 1) {
            snprintf(response2, sizeof(response2), "Game over, Player 1 exited.\n");
            snprintf(response1, sizeof(response1), "Game over\n");
        }
        else if (player2_response == 0 && player1_response == 1) {
            snprintf(response1, sizeof(response1), "Game over, Player 2 exited.\n");
            snprintf(response2, sizeof(response2), "Game over\n");
        }
        else {
            snprintf(response1, sizeof(response1), "Game over, both the players exited.\n");
            snprintf(response2, sizeof(response2), "Game over, both the players exited.\n");
        }
        sendto(sockfd, response1, strlen(response1), 0, (struct sockaddr *)&client1, addr_len);
        sendto(sockfd, response2, strlen(response2), 0, (struct sockaddr *)&client2, addr_len);
        close(sockfd);
        return 0;
    } 
    else {
        goto restart;  
    }
}
