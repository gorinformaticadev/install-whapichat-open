#!/bin/bash
# 
# functions for setting up app frontend

#######################################
# installed node packages
# Arguments:
#   None
#######################################
frontend_node_dependencies() {
  print_banner
  printf "${BLUE} 💻 Instalando dependências do frontend...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/frontend
  npm install --force
EOF

  sleep 2
}

#######################################
# compiles frontend code
# Arguments:
#   None
#######################################
frontend_node_quasar() {
  print_banner
  printf "${BLUE} 💻 Instalando Quasar...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/deploy/$instancia/frontend
  npm i @quasar/cli

EOF

  sleep 2
}


#######################################
# compiles frontend code
# Arguments:
#   None
#######################################
frontend_node_build() {
  print_banner
  printf "${BLUE} 💻 Compilando o código do frontend...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/frontend
  npx update-browserslist-db@latest
  export NODE_OPTIONS=--openssl-legacy-provider
  npx quasar build -P -m pwa

EOF

  sleep 2
}


#######################################
# sets frontend environment variables
# Arguments:
#   None
#######################################
frontend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/${instancia}/frontend/.env
  VUE_URL_API=${backend_url}
  VUE_FACEBOOK_APP_ID='23156312477653241'
[-]EOF
EOF

  sleep 2
}


#######################################
# gera arquivo server.js
# 
#   
#######################################
frontend_serverjs() {
  print_banner
  printf "${WHITE} 💻 gerar arquivo server.js (frontend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/${instancia}/frontend/server.js
// simple express server to run frontend production build;
const express = require('express')
const path = require('path')
const app = express()
app.use(express.static(path.join(__dirname, 'dist/pwa')))
app.get('/*', function (req, res) {
  res.sendFile(path.join(__dirname, 'dist/pwa', 'index.html'))
})
app.listen(${frontend_porta})
[-]EOF
EOF

  sleep 2
}

#######################################
# starts frontend using pm2 in
# production mode.
# Arguments:
#   None
#######################################

frontend_start_pm2() {
  print_banner
  printf "${BLUE} 💻 Iniciando pm2 (frontend)...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/frontend
  pm2 start server.js --name $instancia-frontend
  pm2 save
  pm2 startup ubuntu -u root
EOF

  sleep 2
}

#######################################
# sets up nginx for frontend
# Arguments:
#   None
#######################################
frontend_nginx_setup() {
  print_banner
  printf "${BLUE} 💻 Configurando nginx (frontend)...${NC}"
  printf "\n\n"

  sleep 2

  frontend_hostname=$(echo "${frontend_url/https:\/\/}")
  uri=$uri
sudo su - root << EOF

cat > /etc/nginx/sites-available/$instancia-frontend << 'END'
server {
    server_name $frontend_hostname;
    listen 80;
  
    location / {
    proxy_pass http://127.0.0.1:${frontend_porta};
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_cache_bypass \$http_upgrade;
  }
}

END

ln -s /etc/nginx/sites-available/$instancia-frontend /etc/nginx/sites-enabled
EOF

  sleep 2
}


#####################################################################################################################
# Updates
#####################################################################################################################
#######################################
# updates frontend code
# Arguments:
#   None
#######################################
frontend_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando o frontend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia
  cd /home/deploy/$instancia/frontend
  npm install --force
  export NODE_OPTIONS=--openssl-legacy-provider
  npx update-browserslist-db@latest
  npx quasar build -P -m pwa


EOF

  sleep 2
}
