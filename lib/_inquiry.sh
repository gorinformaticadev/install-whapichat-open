#!/bin/bash
# Função para obter o nome da instância
get_instancia_nome() {
  print_banner
  printf "${BLUE} 💻 Digite o nome da Instância (exemplo: whapichat, minhainstancia...)${NC}\n\n"

  while true; do
    read -p "> " instancia

    # Valida se a entrada está vazia
    if [ -z "$instancia" ]; then
      printf "${RED}⚠️ Nome da instância não pode ser vazio. Tente novamente.${NC}\n"
    else
      break
    fi
  done

  export instancia
  printf "${GREEN}✔️ Instância definida como:${NC} ${BLUE}${instancia}${NC}\n\n"

  # Aguarda 2 segundos antes de continuar
  sleep 1
}


# Função para obter o domínio principal
get_urlprincipal_url() {
  print_banner
  urlprincipal_url="${instancia}.com.br"
  printf "${BLUE} 💻 O domínio principal gerado será: ${GREEN}${urlprincipal_url}${NC}\n\n"
  printf "${RED} 💻 Deseja alterar? Digite o domínio principal ou pressione ENTER para manter.${NC}\n"
  read -t 20 -p "> " new_urlprincipal_url

  if [ -n "$new_urlprincipal_url" ]; then
    urlprincipal_url="$new_urlprincipal_url"
    printf "${GREEN}✔️ Nova URL principal definida:${NC} ${BLUE}${urlprincipal_url}${NC}\n"
  else
    printf "${GREEN}✔️ Mantendo URL principal:${NC} ${BLUE}${urlprincipal_url}${NC}\n"
  fi
    # Aguarda 2 segundos antes de continuar
  sleep 1

  export urlprincipal_url
}


get_frontend_url() {
  print_banner
  printf "${BLUE} 💻 Digite o prefixo para o domínio da interface web (ex. app):${NC}\n\n"

  while true; do
    read -p "> " user_input

    # Valida se a entrada está vazia
    if [ -z "$user_input" ]; then
      printf "${RED}⚠️ O domínio do FrontEnd não pode ser vazio. Tente novamente.${NC}\n"
    else
      # Concatena o valor digitado com urlprincipal_url
      frontend_url="${user_input}.${urlprincipal_url}"
      break
    fi
  done

  export frontend_url
  printf "${GREEN}✔️ Domínio do FrontEnd definido como:${NC} ${BLUE}${frontend_url}${NC}\n\n"

  # Aguarda 2 segundos antes de continuar
  sleep 1
}



get_frontend_porta() {
  print_banner
  printf "${BLUE} 💻 Digite a porta para a interface web (FrontEnd) (exemplo: 3333):${NC}\n\n"

  while true; do
    read -p "> " frontend_porta

    # Valida se a entrada está vazia
    if [ -z "$frontend_porta" ]; then
      printf "${RED}⚠️ A porta não pode ser vazia. Tente novamente.${NC}\n"
    elif ! [[ "$frontend_porta" =~ ^[0-9]+$ ]]; then
      printf "${RED}⚠️ A porta deve ser um número válido. Tente novamente.${NC}\n"
    else
      break
    fi
  done

  export frontend_porta
  printf "${GREEN}✔️ Porta do FrontEnd definida como:${NC} ${BLUE}${frontend_porta}${NC}\n\n"

  # Aguarda 2 segundos antes de continuar
  sleep 1
}
get_backend_url() {
  print_banner
  printf "${BLUE} 💻 Digite o prefixo para o domínio da sua API (Backend):${NC}\n\n"

  while true; do
    read -p "> " user_input

    # Valida se a entrada está vazia
    if [ -z "$user_input" ]; then
      printf "${RED}⚠️ O domínio do Backend não pode ser vazio. Tente novamente.${NC}\n"
    else
      # Concatena o valor digitado com urlprincipal_url
      backend_url="${user_input}.${urlprincipal_url}"
      break
    fi
  done

  export backend_url
  printf "${GREEN}✔️ Domínio do Backend definido como:${NC} ${BLUE}${backend_url}${NC}\n\n"

  # Aguarda 2 segundos antes de continuar
  sleep 1
}

get_backend_porta() {
  print_banner
  printf "${BLUE} 💻 Digite a porta para o domínio da sua API (Backend) (exemplo: 3000):${NC}\n\n"

  while true; do
    read -p "> " user_port

    # Valida se a entrada está vazia ou não é um número
    if [[ -z "$user_port" || ! "$user_port" =~ ^[0-9]+$ ]]; then
      printf "${RED}⚠️ A porta do Backend deve ser um número válido. Tente novamente.${NC}\n"
    else
      backend_porta="$user_port"
      break
    fi
  done

  export backend_porta
  printf "${GREEN}✔️ Porta do Backend definida como:${NC} ${BLUE}${backend_porta}${NC}\n\n"

  # Aguarda 2 segundos antes de continuar
  # sleep 2
}

get_redis_pass() {
  print_banner
  printf "${BLUE} 💻 Gerando uma senha para o Redis:${NC}\n\n"
  printf "Sua senha gerada para o Redis é: "
  redis_pass=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | tr -d '.,/' | head -c 10)
  echo -e "> ${GREEN}$redis_pass${NC}"
  printf "\n"
  
  # Texto temporário
  temp_text=" ${RED}Pressione Enter para manter ou digite uma nova senha (o sistema seguirá em 10s):${NC} "
  echo -ne "$temp_text"

  # Esperar pela entrada do usuário
  read -t 10 -p "" new_passredis

  # Se o usuário digitar algo, considerar como a nova senha
  if [ -n "$new_passredis" ]; then
    printf "\r${BLUE} 💻 Nova senha definida para o Redis:${NC}\n"
    redis_pass="$new_passredis"
  else
    printf "\n"
  fi

  # Aguarda 2 segundos antes de continuar
  # sleep 2
}

get_deploy_pass() {
  print_banner
  printf "${BLUE} 💻 Gerando uma senha para o deploy:${NC}\n\n"
  printf "Sua senha gerada para o deploy é: "
  deploy_password=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | tr -d '.,/' | head -c 10)
  echo -e "> ${GREEN}$deploy_password${NC}"
  printf "\n"
  
  # Texto temporário
  temp_text=" ${RED}Pressione Enter para manter ou digite uma nova senha (o sistema seguirá em 20s):${NC} "
  echo -ne "$temp_text"

  # Esperar pela entrada do usuário
  read -t 20 -p "" new_passdeploy

  # Se o usuário digitar algo, considerar como a nova senha
  if [ -n "$new_passdeploy" ]; then
    printf "\r${BLUE} 💻 Nova senha definida para o deploy:${NC}\n"
    deploy_password="$new_passdeploy"
  else
    printf "\n"
  fi

  # Aguarda 2 segundos antes de continuar
  # sleep 2
}

get_rabbitmq_pass() {
  print_banner
  printf "${BLUE} 🔐 Gerando automaticamente uma senha para o RabbitMQ...${NC}\n\n"

  # Gera uma senha aleatória de 12 caracteres alfanuméricos
  rabbitmq_pass=$(openssl rand -base64 12 | tr -d '/+=' | cut -c1-12)

  # Exibe a senha gerada
  printf "${GREEN}✔️ Senha do RabbitMQ gerada automaticamente:${NC} ${BLUE}${rabbitmq_pass}${NC}\n\n"

  export rabbitmq_pass

  # Aguarda 2 segundos antes de continuar
  #sleep 2
}

get_db_name() {
  print_banner

  # Verifica se a variável "instancia" está definida
  if [ -z "$instancia" ]; then
    printf "${RED}⚠️ A variável 'instancia' não está definida. Defina-a antes de continuar.${NC}\n\n"
    exit 1
  fi

  # Gera automaticamente o nome do banco de dados
  db_name="${instancia}db"

  # Exibe o nome gerado
  printf "${GREEN}✔️ Nome do Banco de Dados gerado automaticamente:${NC} ${BLUE}${db_name}${NC}\n\n"

  export db_name

  # Aguarda 2 segundos antes de continuar
  # sleep 1
}



get_db_user() {
  print_banner
  printf "${BLUE} 💻 Digite um usuário para o Banco de Dados:${NC}\n\n"
  read -p "> " db_user
  
  # Aguarda 2 segundos antes de continuar
   # sleep 2
}

get_db_pass() {
  print_banner
  printf "${BLUE} 💻 Gerando uma senha para o banco de dados:${NC}\n\n"
  printf "Sua senha gerada para o banco de dados é: "
  db_pass=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | tr -d '.,/' | head -c 10)
  echo -e "> ${GREEN}$db_pass${NC}"
  printf "\n"
  
  # Texto temporário
  temp_text=" ${RED}Pressione Enter para manter ou digite uma nova senha (o sistema seguirá em 20s):${NC} "
  echo -ne "$temp_text"

  # Esperar pela entrada do usuário
  read -t 20 -p "" new_passdb

  # Se o usuário digitar algo, considerar como a nova senha
  if [ -n "$new_passdb" ]; then
    printf "\r${BLUE} 💻 Nova senha definida para o Banco de Dados:${NC}\n"
    db_pass="$new_passdb"
  else
    printf "\n"
  fi

  # Aguarda 2 segundos antes de continuar
   # sleep 2
}

get_mail_cert() {
  print_banner
  printf "${BLUE} 💻 Digite um E-mail para o certificado (SSH):${NC}\n\n"
  deploy_email="whapichat@whapichat.com.br"
  echo -e "> ${GREEN}$deploy_email${NC}"
  printf "\n"
  
  # Texto temporário
  temp_text=" ${RED}Pressione Enter para manter ou digite um novo (o sistema seguirá em 20s):${NC} "
  echo -ne "$temp_text"

  # Esperar pela entrada do usuário
  read -t 20 -p "" new_mail

  # Se o usuário digitar algo, considerar como o novo email
  if [ -n "$new_mail" ]; then
    printf "\r${BLUE} 💻 Novo email definido:${NC}\n"
    deploy_email="$new_mail"
  else
    printf "\n"
  fi

  # Aguarda 2 segundos antes de continuar
   sleep 1
}

get_redis_porta() {
  print_banner
  printf "${WHITE} 💻 Digite uma porta para o Redis: (Digite 6379 se é primeira Instalação ou use um diferente se tiver adicionando uma Instância) ${GRAY_LIGHT}\n\n"
  read -p "> " portaredis
  
  # Aguarda 2 segundos antes de continuar
   # sleep 2
}

get_db_user1() {
  print_banner
  printf "${WHITE} 💻 Digite o usuário usado na instalação principal do Banco de Dados:${GRAY_LIGHT}\n\n"
  read -p "> " db_user
  
  # Aguarda 2 segundos antes de continuar
   # sleep 2
}

get_db_pass1() {
  print_banner
  printf "${WHITE} 💻 Digite a senha usada no seu Banco de Dados da instalação principal: ${GRAY_LIGHT}\n\n"
  read -p "> " db_pass
  
  # Aguarda 2 segundos antes de continuar
  #  sleep 2
}

# fim da configuração para instancias

get_urls() {
  get_instancia_nome
  #get_repo
  get_urlprincipal_url
  get_frontend_url
  get_backend_url
  get_deploy_pass
  get_redis_pass
  #get_rabbitmq_pass
  get_db_name
  get_db_user
  get_db_pass
  get_mail_cert
  system_create_user
  system_update
  system_node_install
  system_pm2_install
  system_docker_install
  system_puppeteer_dependencies
  system_snapd_install
  system_nginx_install
  system_certbot_install
  backend_chrome
  system_git_clone
  backend_set_env
  backend_fix_login
  # backend_create_default_users
  # backend_fix_create_default_super
  backend_postgres_create
  backend_redis_create
  backend_rabbitmq_create
  backend_portainer_create
  backend_node_dependencies
  backend_node_build
  backend_db_migrate
  backend_db_seed
  backend_start_pm2
  backend_nginx_setup
  #system_nginx_start
  frontend_set_env
  frontend_serverjs
  frontend_node_dependencies
  frontend_node_quasar
  frontend_node_build
  frontend_start_pm2
  frontend_nginx_setup
  system_nginx_conf
  #system_nginx_restart
  system_certbot_setup
  #system_install_rm
  system_success
}

get_urls_arm64() {
  
  get_instancia_nome
  get_urlprincipal_url
  get_frontend_url
  get_backend_url
  get_deploy_pass
  get_redis_pass
  get_db_name
  get_db_user
  get_db_pass
  get_mail_cert
  system_create_user
  system_update
  system_node_install
  system_pm2_install
  system_docker_install_arm64
  system_puppeteer_dependencies
  system_snapd_install
  system_nginx_install
  system_certbot_install
  backend_chromium_arm64
  system_git_clone
  backend_set_env_arm64
  backend_fix_login
  # backend_create_default_users
  # backend_fix_create_default_super
  backend_postgres_create
  backend_redis_create
  backend_rabbitmq_create
  backend_portainer_create
  backend_node_dependencies
  backend_node_build
  backend_db_migrate
  backend_db_seed
  backend_start_pm2
  backend_nginx_setup
  frontend_set_env
  frontend_serverjs
  frontend_node_dependencies
  frontend_node_quasar
  frontend_node_build
  frontend_start_pm2
  frontend_nginx_setup
  system_nginx_conf
  system_nginx_restart
  system_certbot_setup
  system_install_rm
  system_success
}

software_updates() {
  
  get_instancia_nome
  backend_update
  frontend_update
  #system_nginx_start
  #system_install_rm
  banner_update
}

certificado_urls() {
  renovar_certificado
}

whatsappweb_update() {
  whatsappweb_update
}

#################################
#Opções do menu de instalação

inquiry_options() {
  print_banner
  printf "\n"
  printf "${WHITE} 💻 O que você precisa fazer?${GRAY_LIGHT}\n"
  printf "\n"

  # Seção de Sistemas X86
  printf "${NC}${GRAY_LIGHT}    💢➜ ${RED}SISTEMAS AMD/X86${NC}\n"
  printf "\n"
  printf "   ${NC}${BGREEN}[${NC}${RED}1${NC}${BGREEN}] ${NC}${BLUE}Instalar X86          ${GRAY_LIGHT}|         ${NC}${BGREEN}[${NC}${RED}2${NC}${BGREEN}] ${NC}${GRAY_LIGHT}Atualizar${NC}\n"
  printf "   ${NC}${BGREEN}[${NC}${RED}3${NC}${BGREEN}] ${NC}${BLUE}Instalar instância${NC}\n"
  printf "\n"

  # Seção de Sistemas ARM
  printf "${NC}${GRAY_LIGHT}    💢➜ ${GRAY_LIGHT}SISTEMAS ARM ${NC}\n"
  printf "\n"
  printf "   ${NC}${BGREEN}[${NC}${RED}4${NC}${BGREEN}] ${NC}${GRAY_LIGHT}Instalar ARM64*       ${GRAY_LIGHT}|         ${NC}${BGREEN}[${NC}${RED}5${NC}${BGREEN}] ${NC}${GRAY_LIGHT}Atualizar* ${NC}\n"
  printf "\n"

  # Seção de Outras Opções
  printf "${NC}${GRAY_LIGHT}    💢➜ ${GRAY_LIGHT}OUTROS  * EM DESENVOLVIMENTO*${NC}\n"
  printf "\n"
  printf "   ${NC}${BGREEN}[${NC}${GRAY_LIGHT}6${NC}${BGREEN}] ${NC}${GRAY_LIGHT}Renovar Certificados* ${NC}  |  ${NC}${BGREEN}[${NC}${RED}7${NC}${BGREEN}] ${NC}${GRAY_LIGHT}Alterar domínios* ${NC}\n"
  printf "   ${NC}${BGREEN}[${NC}${GRAY_LIGHT}8${NC}${BGREEN}] ${NC}${GRAY_LIGHT}Bloquear instalação* ${NC}  |  ${NC}${BGREEN}[${NC}${RED}9${NC}${BGREEN}] ${NC}${GRAY_LIGHT}Desbloquear instalação* ${NC}\n"
  printf "   ${NC}${BGREEN}[${NC}${RED}10${NC}${BGREEN}] ${NC}${GRAY_LIGHT}Excluir instalação* ${NC}  |  ${NC}${BGREEN}[${NC}${RED}11${NC}${BGREEN}] ${NC}${GRAY_LIGHT}Atualizar API WhatsAppWeb ${NC}\n"
  printf "\n"
  
  # Opção de Sair
  printf "   ${NC}${BGREEN}[${NC}${RED}*${NC}${BGREEN}] ${CYAN_LIGHT}SAIR\n"
  printf "\n"

  # Receber a entrada do usuário
  read -p "> " option

  # Processar a opção escolhida
  case "${option}" in
    1) get_urls
       exit
       ;;
    2) software_updates
       exit
       ;;
    3) instancias_urls
       exit
       ;;
    4) get_urls_arm64
       exit
       ;;  
    5) renovar_certificado
       exit
       ;; 
    6) renovar_certificado
       exit
       ;; 
    7) alterar_dominios
       exit
       ;;
    8) bloquear_instalacao
       exit
       ;;
    9) desbloquear_instalacao
       exit
       ;;
    10) excluir_instalacao
        exit
        ;;
    11) atualizar_api_whatsappweb
        exit
        ;;
    *) exit
       ;;
  esac
}
