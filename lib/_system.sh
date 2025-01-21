#!/bin/bash
# 
# system management

#######################################
# creates user
# Arguments:
#   None
#######################################
system_create_user() {
  print_banner
  printf "${CYAN_LIGHT} 💻 Verificando se o usuário deploy existe...${NC}"
  printf "\n\n"

  if id "deploy" &>/dev/null; then
    printf "${CYAN_LIGHT} 🔄 Usuário deploy já existe, alterando a senha...${NC}"
    printf "\n\n"
    echo "deploy:${deploy_password}" | sudo chpasswd
    sleep 2
  else
    printf "${CYAN_LIGHT} 💻 Criando o usuário deploy...${NC}"
    printf "\n\n"
    sudo useradd -m -p $(openssl passwd -1 ${deploy_password}) -s /bin/bash -G sudo deploy
  fi

  sleep 2
}

#######################################
# clones repostories using git
# Arguments:
#   None
  #git clone $repourl_url $instancia
#######################################
system_git_clone() {
  print_banner
  printf "${CYAN_LIGHT} 💻 Buscando repositório ...${NC}"
  printf "\n\n"

  sleep 2
  sudo su - deploy <<EOF
  cd /home/deploy/
  git clone --depth 1 $whapichatdown $instancia


EOF

  sleep 2
}


#######################################
# updates system
# Arguments:
#   None
#######################################
system_update() {
  print_banner
  printf "${CYAN_LIGHT} 💻 Atualizando o sistema...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt -y update && apt -y upgrade
EOF

  sleep 2
}

#######################################
# installs node
# Arguments:
#   None
# Essa kinha de ocdigo foi alterada para não mostarra erro da versão antiga do node  que aguarda 60 spara continuar instalação
# curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - >
#######################################
system_node_install() {
  print_banner
  printf "${CYAN_LIGHT} 💻 Instalando nodejs...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - > /dev/null 2>&1
  apt-get install -y nodejs
EOF

  sleep 2
}


#######################################
# installs docker
# Arguments:
#   None
#######################################
system_docker_install() {
  print_banner
  printf "${CYAN_LIGHT} 💻 Instalando docker...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG sudo deploy
  apt install -y ca-certificates curl gnupg 
  install -m 0755 -d /etc/apt/keyrings

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg
  
  sh -c 'echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
  
  sudo apt-get update
  
  apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  usermod -aG docker ${USER}

EOF

  sleep 2
}

#######################################
# installs docker
# Arguments:
#   None
#######################################
system_docker_install_arm64() {
  print_banner
  printf "${WHITE} 💻 Instalando docker...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG sudo deploy
  apt install -y apt-transport-https \
                 ca-certificates curl \
                 software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

  add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu bionic stable"

  apt install -y docker-ce
  usermod -aG docker ${USER}

EOF

  sleep 2
}

#######################################
# Ask for file location containing
# multiple URL for streaming.
# Globals:
#   WHITE
#   GRAY_LIGHT
#   BATCH_DIR
#   PROJECT_ROOT
# Arguments:
#   None
#######################################
system_puppeteer_dependencies() {
  print_banner
  printf "${CYAN_LIGHT} 💻 Instalando puppeteer dependencies...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt-get install -y libxshmfence-dev \
                      libgbm-dev \
                      wget \
                      unzip \
                      fontconfig \
                      locales \
                      gconf-service \
                      libasound2 \
                      libatk1.0-0 \
                      libc6 \
                      libcairo2 \
                      libcups2 \
                      libdbus-1-3 \
                      libexpat1 \
                      libfontconfig1 \
                      libgcc1 \
                      libgconf-2-4 \
                      libgdk-pixbuf2.0-0 \
                      libglib2.0-0 \
                      libgtk-3-0 \
                      libnspr4 \
                      libpango-1.0-0 \
                      libpangocairo-1.0-0 \
                      libstdc++6 \
                      libx11-6 \
                      libx11-xcb1 \
                      libxcb1 \
                      libxcomposite1 \
                      libxcursor1 \
                      libxdamage1 \
                      libxext6 \
                      libxfixes3 \
                      libxi6 \
                      libxrandr2 \
                      libxrender1 \
                      libxss1 \
                      libxtst6 \
                      ca-certificates \
                      fonts-liberation \
                      libappindicator1 \
                      libnss3 \
                      lsb-release \
                      xdg-utils
                      git\
                      apt-add-repository universe
                      apt install -y python2-minimal
                      apt-get install -y build-essential
                      apt -y update && apt -y upgrade

EOF

  sleep 2
}

#######################################
# installs pm2
# Arguments:
#   None
#######################################
system_pm2_install() {
  print_banner
  printf "${CYAN_LIGHT} 💻 Instalando pm2...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  npm install -g pm2
  pm2 startup ubuntu -u deploy
  env PATH=\$PATH:/usr/bin pm2 startup ubuntu -u deploy --hp /home/deploy
EOF

  sleep 2
}

#######################################
# installs snapd
# Arguments:
#   None
#######################################
system_snapd_install() {
  print_banner
  printf "${CYAN_LIGHT} 💻 Instalando snapd...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt install -y snapd
  snap install core
  snap refresh core
EOF

  sleep 2
}

#######################################
# installs certbot
# Arguments:
#   None
#######################################
system_certbot_install() {
  print_banner
  printf "${CYAN_LIGHT} 💻 Instalando certbot e configurando firewall...${NC}\n\n"

  sleep 2

  sudo su - root <<EOF
  # Definir políticas padrão
  echo "🔒 Configurando regras padrão do UFW..."
  sudo ufw default deny incoming
  sudo ufw default allow outgoing

  # Abrir portas específicas
  echo "📡 Permitindo conexões necessárias..."
  sudo ufw allow ssh
  sudo ufw allow 5432
  sudo ufw allow 80
  sudo ufw allow 443
  sudo ufw allow 6379
  sudo ufw allow 5672
  sudo ufw allow 9000
  sudo ufw allow 3100
  sudo ufw allow 3000
  sudo ufw allow 3333

  # Ativar o UFW
  echo "🚀 Ativando o UFW..."
  sudo ufw --force enable

  # Instalação do Certbot
  echo "⚙️ Instalando o Certbot..."
  sudo apt-get remove -y certbot
  sudo snap install --classic certbot
  sudo ln -s /snap/bin/certbot /usr/bin/certbot

  echo "✅ Configuração concluída!"
EOF

  sleep 2
}

system_certbot_install_arm() {
    echo "Iniciando configuração do sistema para ARM..."

    # Garantir que o script está sendo executado como root
    if [ "$(id -u)" -ne 0 ]; then
        echo "Este script precisa ser executado como root. Use 'sudo su - root' antes de executar."
        exit 1
    fi

    echo "Liberando as portas necessárias no firewall..."

    # Liberar portas no iptables
    ports=(80 443 5432 6379 5672 9000 3000 3333)
    for port in "${ports[@]}"; do
        iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
        echo "Porta $port liberada."
    done

    # Permitir conexões estabelecidas
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    # Bloquear todo o tráfego não permitido
    iptables -A INPUT -j REJECT

    echo "Salvando regras do iptables..."
    apt install -y iptables-persistent
    netfilter-persistent save
    netfilter-persistent reload

    echo "Instalando Fail2Ban..."

    # Instalar Fail2Ban
    apt install -y fail2ban

    # Configuração básica do Fail2Ban
    cat <<EOF > /etc/fail2ban/jail.local
[DEFAULT]
bantime  = 10m
findtime = 10m
maxretry = 5

[sshd]
enabled = true

[nginx-http-auth]
enabled = true
EOF

    systemctl enable fail2ban
    systemctl start fail2ban

    echo "Fail2Ban instalado e configurado."

    echo "Removendo Certbot antigo, se existir..."

    # Remover Certbot antigo
    apt remove -y certbot python3-certbot-nginx
    apt autoremove -y

    echo "Instalando Certbot..."

    # Instalar Certbot
    apt install -y software-properties-common
    add-apt-repository -y universe
    apt update -y
    apt install -y certbot python3-certbot-nginx

    echo "Certbot instalado com sucesso."

    echo "Configurando SSL com Certbot..."
    
    # Configuração básica para usar Certbot (requer domínio configurado)
    certbot --nginx -n --agree-tos --email ${deploy_email}

    echo "Instalação concluída. Firewall configurado, Fail2Ban ativado e Certbot pronto para uso."
}

#######################################
# renovar certbot
# Arguments:
#   None
#######################################
renovar_certificado() {
  print_banner
  printf "${CYAN_LIGHT} 💻 Renovando certbot...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  certbot renew
EOF

  sleep 2
}


#######################################
# installs nginx
# Arguments:
#   None
#######################################
system_nginx_install() {
  print_banner
  printf "${CYAN_LIGHT} 💻 Instalando nginx...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt install -y nginx
  rm /etc/nginx/sites-enabled/default
EOF

  sleep 2
}

#######################################
# restarts nginx
# Arguments:
#   None
#######################################
system_nginx_restart() {
  print_banner
  printf "${CYAN_LIGHT} 💻 reiniciando nginx...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  service nginx restart
  sudo systemctl restart nginx
EOF

  sleep 2
}

#######################################
# setup for nginx.conf
# Arguments:
#   None
#######################################
system_nginx_conf() {
  print_banner
  printf "${CYAN_LIGHT} 💻 configurando nginx...${NC}"
  printf "\n\n"

  sleep 2

sudo su - root << EOF

cat > /etc/nginx/conf.d/nginx.conf << 'END'
client_max_body_size 100M;
END

EOF

  sleep 2
}


#######################################
# installs nginx
# Arguments:
#   None
#######################################
system_certbot_setup() {
  print_banner
  printf "${CYAN_LIGHT} 💻 Configurando certbot...${NC}"
  printf "\n\n"

  sleep 2

  backend_domain=$(echo "${backend_url/https:\/\/}")
  frontend_domain=$(echo "${frontend_url/https:\/\/}")

  sudo su - root <<EOF
  certbot -m $deploy_email \
          --nginx \
          --agree-tos \
          --non-interactive \
          --domains $backend_domain,$frontend_domain
EOF

  sleep 2
}

system_success() {
  print_banner
  printf "${GREEN} 💻 Instalação concluída com Sucesso...${NC}"
  printf "${CYAN_LIGHT}";
  printf "\n"
  printf "Instancia: $instancia"
  printf "\n\n"
  printf "DADOS DE ACESSO"
  printf "\n"
  printf "Usuário: whapichat@whapichat.com.br"
  printf "\n"
  printf "Senha: 123456"
  printf "\n\n"
  printf "front-end: https://$frontend_domain\n"
  printf "back-end: https://$backend_domain\n"
  printf "Acesso ao Portainer: https://seu ip:9443\n"
  printf "\n"
  printf "SENHAS E BD"
  printf "\n"
  printf "Senha Usuario Deploy: $deploy_password\n"
  printf "Usuario do Banco de Dados: $db_user\n"
  printf "Nome do Banco de Dados: $db_name\n"
  printf "Senha do Banco de Dados: $db_pass\n"
  printf "Senha do Redis: $redis_pass\n"
  printf "Senha do rabbitmq: $rabbitmq_pass\n"
  printf "\n"
  printf "${NC}";
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
