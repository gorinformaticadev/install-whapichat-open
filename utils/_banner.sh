#!/bin/bash
#
# Print banner art.
#
#######################################
# Print a board. 
# Globals:
#   BG_BROWN
#   NC
#   WHITE
#   CYAN_LIGHT
#   RED
#   GREEN
#   YELLOW
# Arguments:
#   None
#######################################
print_banner() {
  clear
  printf "\n"
    printf "${WHITE}";
  printf "                          ██████╗  ██████╗ ██████╗     \n";
  printf "                         ██╔════╝ ██╔═══██╗██╔══██╗    \n";
  printf "                         ██║  ███╗██║   ██║██████╔╝    \n";
  printf "                         ██║   ██║██║   ██║██╔══██╗    \n";
  printf "                         ╚██████╔╝╚██████╔╝██║  ██║    \n";
  printf "                           ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ \n";   
  printf "  ██╗███╗   ██╗███████╗ ██████╗ ██████╗ ███╗   ███╗ █████╗ ████████╗██╗ ██████╗ █████╗ \n";
  printf "  ██║████╗  ██║██╔════╝██╔═══██╗██╔══██╗████╗ ████║██╔══██╗╚══██╔══╝██║██╔════╝██╔══██╗\n";
  printf "  ██║██╔██╗ ██║█████╗  ██║   ██║██████╔╝██╔████╔██║███████║   ██║   ██║██║     ███████║\n";
  printf "  ██║██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║██╔══██║   ██║   ██║██║     ██╔══██║\n";
  printf "  ██║██║ ╚████║██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║██║  ██║   ██║   ██║╚██████╗██║  ██║\n";
  printf "  ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝╚═╝  ╚═╝\n";
  printf "             ${NC}${RED} By GOR Informatica 2024${NC}         \n";
  printf "${NC}";
  printf "\n";
  printf "                ${RED} Sua Arquitetura é: ${NC}";  dpkg --print-architecture;
  printf "\n";
# Configuração da barra de progresso
#   total=20  # Número total de passos da barra (ajustar conforme necessário)
#   count=0    # Contador de progresso
#   bar="["    # Começo da barra
#   empty="-"  # Caractere para preencher o progresso
#   filled="=" # Caractere para a parte preenchida da barra
#   while [ $count -le $total ]; do
    # Calcula a quantidade de caracteres "filled" e "empty"
#     progress=$(($count * 100 / $total))
#     filled_bar=$(printf "%${count}s" | tr " " "=")
  #   empty_bar=$(printf "%$((total - count))s" | tr " " "-")
    
    # Exibe a barra de progresso
    # printf "\r${bar}${filled_bar}${empty_bar}${bar} ${progress}%%"
    
    # Atraso de 1 segundo (ajustar conforme necessário)
    # sleep 1
    # count=$((count + 1))
  # done
  
  # printf "\n\n"
}

banner_update() {
  print_banner
  printf "\n"
  printf "Instancia: $instancia\n"
  printf "\n"
  printf "${GREEN} __  __  ______  _____   ______  _______  _______ \n"
  printf "|  ||  ||   __ \|     \ |  .   ||_     _||    ___|\n"
  printf "|  ||  ||    __/|  --  ||      |  |   |  |    ___|\n"
  printf "|______||___|   |_____/ |__||__|  |___|  |_______|\n"
  printf "Seu update foi finalizado, verifique se houve erros!...${NC}"

 printf " ESTE AUTO-INSTALADOR TE AJUDOU? \n"
  printf " Contribua com o meu trabalho: \n"
  printf "        ▄▄▄▄▄▄▄    ▄ ▄ ▄  ▄▄ ▄ ▄    ▄ ▄  ▄  ▄ ▄▄▄▄▄▄▄  \n"
  printf "        █ ▄▄▄ █ ▀▀  ▀▄▀▄ ▄▀▀  ▀ ██▀▀ █▄▄▄█ █  █ ▄▄▄ █  \n"
  printf "        █ ███ █ ▀█▄  ▄▄▄▀▄▀▀███▄█▄▀ ▄▀█ ▄▄▄██ █ ███ █  \n"
  printf "        █▄▄▄▄▄█ █ ▄ ▄▀█ ▄ █ █ ▄ █ ▄ ▄▀▄ ▄▀▄ ▄ █▄▄▄▄▄█  \n"
  printf "        ▄▄▄▄▄ ▄▄▄ ▀█ ▄█▄ ▀█ █▄▄▄█  ▄▀▄█▀▀ █▀ ▄ ▄ ▄ ▄   \n"
  printf "        ▀██▀ ▀▄▄███▀▀  ▄█ ▀▄▄▄ ██▄▄▄ ▄▀ ▄ ▄█▀▄▄█ █▄▀▀  \n"
  printf "        ██ █▀ ▄▀▀▀▄ ▀▀  █▀█  ▀▄▄▄▀█▀ ▄█▀▀▀▀▀█  ▄▀▀█    \n"
  printf "         ██▀▄ ▄██▄ █ ▀▀█▄█ ▄▄▄▄▀▄█▄▄▄▀▀ ▀▄ ██▄▄█  ▀▄   \n"
  printf "        █▀  ▄▀▄▄▀   █▀ ▀ ▄ ▄▄▀▄ ▄  ▄▀▄██▀▄▄    ▄▀▄▀ ▀  \n"
  printf "        ▀     ▄▄▄█▀▀▀█ ▀  ▀▄▄█ ▄▄▄▄▀ ▄▀▀▄█▄▀▀▄▄▀▀▄█▀▀  \n"
  printf "         ▄▀▄█▄▄█▄ █▄ █ ▀  █ ▄█▄██ █ ▀▀▀▀▀▀ ▀▄▄█▄███    \n"
  printf "        █▀ ██ ▄ █▄▄▀▄▄▄▄▄▀▄▄█ ▄ ██▄ ▀███ ▀▄▄█ ▄ █ ██   \n"
  printf "        ▄█▀▄█▄▄▄█ ███▄██ ▀█▄█▄▄▄█  ▄▀▀█▄▀▄█▄█▄▄▄█▄▀██  \n"
  printf "        ▄█▀ █▀▄▄▀  ▄█▄ ▄███▀▄ ▀▄ ▄▄█▀▄▀  ▄▄▀█▄ █▄▀█▀▀  \n"
  printf "          █  ▄▄█▀▄█ ██▀▄▀ ▄ ██▀▄█▄▀ ▀▄▀▀▀▄▄▀█   ▄▀█    \n"
  printf "        ▀▀█▄▀▄▄▄▀████  ▄▄█ ▀ ▄▀▀█▀ █▄██  ▀▄▀▀▀ ▀▄▄█▄   \n"
  printf "        ▀██▄ ▄▄▄█ ▄ ▄▀ ▀ ▄  ██ ▀█▄ ▄▀▄██▀█▄  ▀▀▀▄▄▀▄▀  \n"
  printf "           ▀█ ▄ ▀▄█▀ █▄▀ ▄█▀ ▄▀▄ ▄▄▄▀▄▀▄█▄▄ ▀▄▀▀ ▄▄▀▀  \n"
  printf "        ▄▀▀██ ▄ ██▄▀▄█▀▀▄▀█ ▄▄█▄█▄█▀ ▄█▀▀█▄▀▄█▄█▄▀█ ▄  \n"
  printf "        ▄▄▄▄▄▄▄ █ ▀▀██▄█ ▀▄██ ▄ █▀▄▄▄▀█▄▀▀▄▄█ ▄ █ ▀▄   \n"
  printf "        █ ▄▄▄ █ ▄▄▀▄█▄██ ▀█ █▄▄▄█▀ ▄▀▀▀ ▀▀▄ █▄▄▄█▄▀▄█  \n"
  printf "        █ ███ █ █▀█▄█  ▄█▀▀  ▀▄▄█▄▄▄▄▄▀ ▀▄▄▄█▀ ▄▀▄▀ ▄  \n"
  printf "        █▄▄▄▄▄█ █ ▀ ▀ ▀ █ █▀▀█ ▄█▀█ ▀█▀▀▀█▄ ▄▀▄▀▀▀█▄   \n"
  printf "${NC}";
  sleep 2
}