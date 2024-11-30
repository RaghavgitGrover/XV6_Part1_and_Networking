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

void game(int client1_sock, int client2_sock) {
    reset_board();
    int row, col, winner = 0;
    char buffer[BUFFER_SIZE];
    memset(buffer, 0, sizeof(buffer));
    fflush(stdout);
    sprintf(buffer, "\n %c | %c | %c \n---|---|---\n %c | %c | %c \n---|---|---\n %c | %c | %c \n\n",
            board[0][0], board[0][1], board[0][2], board[1][0], board[1][1], board[1][2], board[2][0], board[2][1], board[2][2]);
    send(client1_sock, buffer, strlen(buffer), 0);
    send(client2_sock, buffer, strlen(buffer), 0);

    while (1) {        
        int current_client, waiting_client;
        if (current_player == 1) {
            current_client = client1_sock;
            waiting_client = client2_sock;
        } 
        else {
            current_client = client2_sock;
            waiting_client = client1_sock;
        }

        int valid_move = 0;
        while (!valid_move) {
            memset(buffer, 0, sizeof(buffer));
            fflush(stdout);
            sprintf(buffer, "\nYour turn, Player %d (enter row and column from 1 to 3):\n", current_player);
            send(current_client, buffer, strlen(buffer), 0);
            memset(buffer, 0, sizeof(buffer));
            sprintf(buffer, "\nWaiting for Player %d to make a move...\n\n", current_player);
            send(waiting_client, buffer, strlen(buffer), 0);

            memset(buffer, 0, sizeof(buffer));
            fflush(stdout);
            recv(current_client, buffer, BUFFER_SIZE, 0);
            sscanf(buffer, "%d %d", &row, &col);

            row--;
            col--;

            if (row < 0 || row > 2 || col < 0 || col > 2 || board[row][col] != ' ') {
                memset(buffer, 0, sizeof(buffer));
                fflush(stdout);
                sprintf(buffer, "Invalid move, try again!\n");
                send(current_client, buffer, strlen(buffer), 0);
            } 
            else {
                valid_move = 1;  
                board[row][col] = (current_player == 1) ? 'X' : 'O';
                memset(buffer, 0, sizeof(buffer));
                fflush(stdout);
                sprintf(buffer, "\n %c | %c | %c \n---|---|---\n %c | %c | %c \n---|---|---\n %c | %c | %c \n",
                        board[0][0], board[0][1], board[0][2], board[1][0], board[1][1], board[1][2], board[2][0], board[2][1], board[2][2]);
                send(client1_sock, buffer, strlen(buffer), 0);
                send(client2_sock, buffer, strlen(buffer), 0);

                winner = decide_win();
                if (winner || decide_draw()) break;
                current_player = 3 - current_player;  
            }
        }
        if (winner || decide_draw()) break;
    }

    if (winner) {
        memset(buffer, 0, sizeof(buffer));
        fflush(stdout);
        fflush(stdout);
        sprintf(buffer, "Player %d wins!\n", winner);
    }
    else {
        memset(buffer, 0, sizeof(buffer));
        fflush(stdout);
        fflush(stdout);
        sprintf(buffer, "It's a draw!\n");
    }
    send(client1_sock, buffer, strlen(buffer), 0);
    send(client2_sock, buffer, strlen(buffer), 0);
}

int main(int argc, char *argv[]) {
    // struct sockaddr_in address;
    // int addrlen = sizeof(address);
    // int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    // int opt = 1;
    // setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
    // address.sin_family = AF_INET;
    // address.sin_addr.s_addr = INADDR_ANY;
    // address.sin_port = htons(8080);
    // bind(server_fd, (struct sockaddr *)&address, sizeof(address));
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <server_ip>\n", argv[0]);
        exit(1);
    }

    const char *server_ip = argv[1];
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    int opt = 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
    
    address.sin_family = AF_INET;
    address.sin_port = htons(8080);
    
    if (inet_pton(AF_INET, server_ip, &address.sin_addr) <= 0) {
        printf("Invalid address/ Address not supported \n");
        return -1;
    }

    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    if (listen(server_fd, 3) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    
    printf("Server listening on %s...\n", server_ip);
    fflush(stdout);

    listen(server_fd, 3);
    printf("Waiting for players...\n");
    fflush(stdout);

    int client1_sock, client2_sock;
    if ((client1_sock = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
        printf("Player 1 failed to connect\n");
        exit(EXIT_FAILURE);
    }
    printf("Player 1 connected!\n");

    if ((client2_sock = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
        printf("Player 2 failed to connect\n");
        exit(EXIT_FAILURE);
    }
    printf("Player 2 connected!\n");

    char buffer[BUFFER_SIZE];

restart:
    game(client1_sock, client2_sock);
    memset(buffer, 0, sizeof(buffer));
    fflush(stdout);
    snprintf(buffer, sizeof(buffer), "Do you want to play again? (yes/no)\n");
    send(client1_sock, buffer, strlen(buffer), 0);
    send(client2_sock, buffer, strlen(buffer), 0);

    int player1_response = 0, player2_response = 0;
    memset(buffer, 0, sizeof(buffer));
    fflush(stdout);
    recv(client1_sock, buffer, BUFFER_SIZE, 0);
    if (strstr(buffer, "yes") != NULL) player1_response = 1;
    memset(buffer, 0, sizeof(buffer));
    fflush(stdout);
    recv(client2_sock, buffer, BUFFER_SIZE, 0);
    if (strstr(buffer, "yes") != NULL) player2_response = 1;

    printf("Player 1 response: %d\n", player1_response);
    printf("Player 2 response: %d\n", player2_response);

    if (player1_response == 0 || player2_response == 0) {
        char response1[BUFFER_SIZE], response2[BUFFER_SIZE];
        memset(response1, 0, sizeof(response1));
        memset(response2, 0, sizeof(response2));
        fflush(stdout);
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
        send(client1_sock, response1, strlen(response1), 0);
        send(client2_sock, response2, strlen(response2), 0);
        close(client1_sock); 
        close(client2_sock); 
        close(server_fd);
        return 0;
    } 
    else {
        goto restart;  
    }
}
