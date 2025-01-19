#!/bin/bash
# 
# functions for setting up app backend

#######################################
# Install Chrome
# Arguments:
#   None
#######################################
backend_chrome() {
  print_banner
  printf "${WRITE} 💻 Instalando Chrome...${NC}}"
  printf "\n\n"

  sleep 2
  sudo su - root <<EOF
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
  wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  apt-get update
  apt-get install -y google-chrome-stable

EOF

  sleep 2
}



#######################################
# creates postgresql db, redis and rabbitmq  using docker
# Arguments:
#   None
#######################################
backend_postgres_create() {
  print_banner
  printf "${RED} 💻 Criando banco de dados...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  timedatectl set-timezone America/Sao_Paulo
  usermod -aG docker deploy
  docker run --name postgresql-${instancia} \
                -e POSTGRES_DB=${db_name} \
                -e POSTGRES_USER=${db_user} \
                -e POSTGRES_PASSWORD=${db_pass} \
                -p 5432:5432 --restart=always \
                -v /data:/var/lib/postgresql/data \
                -d postgres \

EOF
}

backend_redis_create() {
  print_banner
  printf "${RED} 💻 Criando Redis...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG docker deploy
  docker run -e TZ="America/Sao_Paulo" \
                --name redis-$instancia \
                -p 6379:6379 \
                -d --restart=always redis:latest redis-server \
                --appendonly yes \
                --requirepass ${redis_pass} \


EOF

  sleep 2
}

backend_rabbitmq_create() {
  print_banner
  printf "${RED} 💻 Criando rabbitmq...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG docker deploy
  docker run -d --name rabbitmq-${instancia} \
            -p 5672:5672 -p 15672:15672 \
            --restart=always --hostname rabbitmq \
            -v /data:/var/lib/rabbitmq rabbitmq:3.11.5-management          
EOF

  sleep 2
}


backend_portainer_create() {
  print_banner
  printf "${RED} 💻 Criando Portainer...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG docker deploy
  docker run -d --name portainer \
                -p 9000:9000 -p 9443:9443 \
                --restart=always \
                -v /var/run/docker.sock:/var/run/docker.sock \
                -v portainer_data:/data portainer/portainer-ce


EOF

  sleep 2
}



#######################################
# sets environment variable for backend.
# Arguments:
#   None
#######################################
backend_set_env() {
  print_banner
  printf "${RED} 💻 Configurando variáveis de ambiente (backend)...${NC}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

  # ensure idempotency
  frontend_url=$(echo "${frontend_url/https:\/\/}")
  frontend_url=${frontend_url%%/*}
  frontend_url=https://$frontend_url
  urlprincipal_url=$(echo "${urlprincipal_url/https:\/\/}")

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/$instancia/backend/.env
#NODE_ENV=prod

# ambiente
NODE_ENV=dev

# URL do backend para construção dos hooks
BACKEND_URL=${backend_url}


# URL do front para liberação do cors
FRONTEND_URL=${frontend_url}

# Porta utilizada para proxy com o serviço do backend
PROXY_PORT=443

# Porta que o serviço do backend deverá ouvir
PORT=3000

# conexão com o banco de dados
DB_DIALECT=postgres
DB_PORT=5432
POSTGRES_HOST=localhost
POSTGRES_USER=${db_user}
POSTGRES_PASSWORD=${db_pass}
POSTGRES_DB=${db_name}

# Chaves para criptografia do token jwt
JWT_SECRET=${jwt_secret}
JWT_REFRESH_SECRET=${jwt_refresh_secret}

# Dados de conexão com o REDIS
IO_REDIS_SERVER=localhost
IO_REDIS_PASSWORD='${redis_pass}'
IO_REDIS_PORT='6379'
IO_REDIS_DB_SESSION='2'
REDIS_URI=redis://:${redis_pass}@127.0.0.1:6379

#CHROME_BIN=/usr/bin/google-chrome
CHROME_BIN=/usr/bin/google-chrome-stable
#CHROME_BIN=/usr/bin/chromium-browser
#CHROME_BIN=/usr/bin/vivaldi
#CHROME_BIN=null

# tempo para randomização da mensagem de horário de funcionamento
MIN_SLEEP_BUSINESS_HOURS=10000
MAX_SLEEP_BUSINESS_HOURS=20000

# tempo para randomização das mensagens do bot
MIN_SLEEP_AUTO_REPLY=4000
MAX_SLEEP_AUTO_REPLY=6000

# tempo para randomização das mensagens gerais
MIN_SLEEP_INTERVAL=2000
MAX_SLEEP_INTERVAL=5000

# dados do RabbitMQ / Para não utilizar, basta comentar a var AMQP_URL
# RABBITMQ_DEFAULT_PASS=${rabbitmq_pass}
AMQP_URL='amqp://guest:guest@127.0.0.1:5672?connection_attempts=5&retry_delay=5'

# api oficial (integração em desenvolvimento)
API_URL_360=https://waba-sandbox.360dialog.io

# usado para mosrar opções não disponíveis normalmente.
ADMIN_DOMAIN=${urlprincipal_url}
#DB_TIMEZONE=-03:00

# Dados para utilização do canal do facebook
FACEBOOK_APP_ID=3237415623048660
FACEBOOK_APP_SECRET_KEY=3266214132b8c98ac59f3e957a5efeaaa13500


# Limitar Uso do whapichat Usuario e Conexões
USER_LIMIT=999
CONNECTIONS_LIMIT=999


[-]EOF
EOF

  sleep 2
}


#######################################
# installs node.js dependencies
# Arguments:
#   None
#######################################
backend_node_dependencies() {
  print_banner
  printf "${RED} 💻 Instalando dependências do backend...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/backend
  npm install --force
EOF

  sleep 2
}

#######################################
# compiles backend code
# Arguments:
#   None
#######################################
backend_node_build() {
  print_banner
  printf "${RED} 💻 Compilando o código do backend...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/backend
  npm run build
EOF

  sleep 2
}

#######################################
# runs db migrate
# Arguments:
#   None
#######################################
backend_db_migrate() {
  print_banner
  printf "${RED} 💻 Executando db:migrate...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/backend
  npx sequelize db:migrate
EOF

  sleep 2
}

#######################################
# runs db seed
# Arguments:
#   None
#######################################
backend_db_seed() {
  print_banner
  printf "${RED} 💻 Executando db:seed...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/backend
  npx sequelize db:seed:all
EOF

  sleep 2
}

#######################################
# starts backend using pm2 in 
# production mode.
# Arguments:
#   None
#######################################
backend_start_pm2() {
  print_banner
  printf "${RED} 💻 Iniciando pm2 (backend)...${NC}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia/backend
  pm2 start dist/server.js --name $instancia-backend
EOF

  sleep 2
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_nginx_setup() {
  print_banner
  printf "${RED} 💻 Configurando nginx (backend)...${NC}"
  printf "\n\n"

  sleep 2

  backend_hostname=$(echo "${backend_url/https:\/\/}")
  frontend_hostname=$(echo "${frontend_url/https:\/\/}")

sudo su - root << EOF

cat > /etc/nginx/sites-available/$instancia-backend << 'END'
#PROXY-START/

server {
  server_name $backend_hostname;

  location / {
    proxy_pass http://127.0.0.1:${backend_porta};
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

ln -s /etc/nginx/sites-available/$instancia-backend /etc/nginx/sites-enabled
EOF

  sleep 2
}

#######################################
# Usado para permitir login de administrador
# Arguments:
#   None
#######################################

backend_fix_login() {
  print_banner
  printf "${RED} 💻 Configurando permissão de login frontend...${NC}"
  printf "\n\n"

  sleep 2
  admin_backend_url=$backend_url
  sudo su - deploy << EOF

cat <<-MIDDLEWARE > /home/deploy/$instancia/backend/src/middleware/isAuthAdmin.ts
import { verify } from "jsonwebtoken"; // Importa a função verify do jsonwebtoken para validar tokens.
import { Request, Response, NextFunction } from "express"; // Importa tipos para requisição, resposta e função next do Express.

import AppError from "../errors/AppError"; // Importa a classe de tratamento de erros personalizada.
import authConfig from "../config/auth"; // Importa a configuração de autenticação.
import User from "../models/User"; // Importa o modelo de Usuário para operações no banco de dados.

interface TokenPayload { // Define a estrutura do payload do token.
  id: string; // ID do usuário.
  username: string; // Nome de usuário.
  profile: string; // Tipo de perfil do usuário.
  tenantId: number; // ID do inquilino associado ao usuário.
  iat: number; // Timestamp de emissão.
  exp: number; // Timestamp de expiração.
}

// Função middleware para verificar se o usuário é um administrador.
const isAuthAdmin = async (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization; // Obtém o cabeçalho de autorização da requisição.
  const adminDomain = process.env.ADMIN_DOMAIN; // Obtém o domínio do administrador das variáveis de ambiente.

  // Verifica se o cabeçalho de autorização foi fornecido.
  if (!authHeader) {
    throw new AppError("Token não foi fornecido.", 403); // Lança um erro se nenhum token for fornecido.
  }
  // Verifica se o domínio do administrador está definido.
  if (!adminDomain) {
    throw new AppError("Não existem domínios de administrador definidos.", 403); // Lança um erro se nenhum domínio de administrador estiver definido.
  }

  const [, token] = authHeader.split(" "); // Extrai o token do cabeçalho de autorização.

  try {
    // Verifica o token usando o segredo da authConfig.
    const decoded = verify(token, authConfig.secret);
    const { id, profile, tenantId } = decoded as TokenPayload; // Desestrutura o payload do token decodificado.
    const user = await User.findByPk(id); // Encontra o usuário no banco de dados pelo ID.
    
    // Verifica se o usuário existe e se seu e-mail corresponde ao domínio do administrador.
    if (!user || user.email.indexOf(adminDomain) === 1) {
      throw new AppError("Sem permissão de administrador", 403); // Lança um erro se o usuário não for um administrador.
    }

    // Anexa informações do usuário ao objeto de requisição para uso posterior.
    req.user = {
      id,
      profile,
      tenantId
    };
  } catch (err) {
    throw new AppError("Token inválido ou não é Administrador", 403); // Lança um erro se o token for inválido ou o usuário não for um administrador.
  }

  return next(); // Chama a próxima função middleware se o usuário estiver autenticado como administrador.
};

export default isAuthAdmin; // Exporta a função middleware isAuthAdmin.

MIDDLEWARE

EOF

  sleep 2
}


#######################################
# create-default-users.ts com o dominio principal
# Arguments:
#   None
#######################################

backend_create_default_users() {
  print_banner
  printf "${RED} 💻 Configurando email de administrador...${NC}"
  printf "\n\n"

  sleep 2
    # Caminho do arquivo
   adminuser="/home/deploy/${instancia}/bcakend/src/database/seeds/20200904070005-create-default-users.ts"
  
  sed -i "s/admin@whapichat\.com\.br/admin@${urlprincipal_url}/g" "$adminuser"

  sleep 2
}



#######################################
# Create-default-super com o dominio principal
# Arguments:
#   None
#######################################

backend_fix_create_default_super() {
  print_banner
  printf "${RED} 💻 Configurando permissão de login superuser...${NC}"
  printf "\n\n"

  superuser="/home/deploy/${instancia}/bcakend/src/database/seeds/20240517000001-create-default-super.ts"
  
  sed -i "s/super@whapichat\.com\.br/super@${urlprincipal_url}/g" "$superuser"

  sleep 2
}

#####################################################################################################################
# Instalação em ARM codigos que mudam
# Arguments:
#   None
#####################################################################################################################
#######################################
# Install Chromium Arm64
# Arguments:
#   None
#######################################

backend_chromium_arm64() {
  print_banner
  printf "${WRITE} 💻 Instalando Chromium ARM64...${NC}}"
  printf "\n\n"

  sleep 2
  sudo su - root <<EOF
  apt install -y chromium-browser

EOF

  sleep 2
}

#######################################
# sets environment variable for backend AMR64
# Arguments:
#   None
#######################################


backend_set_env_arm64() {
  print_banner
  printf "${RED} 💻 Configurando variáveis de ambiente (backend)...${NC}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

  # ensure idempotency
  frontend_url=$(echo "${frontend_url/https:\/\/}")
  frontend_url=${frontend_url%%/*}
  frontend_url=https://$frontend_url
  urlprincipal_url=$(echo "${urlprincipal_url/https:\/\/}")

sudo su - deploy << EOF
  cat <<[-]EOF > /home/deploy/$instancia/backend/.env

#NODE_ENV=prod

# ambiente
NODE_ENV=dev

# URL do backend para construção dos hooks
BACKEND_URL=${backend_url}


# URL do front para liberação do cors
FRONTEND_URL=${frontend_url}

# Porta utilizada para proxy com o serviço do backend
PROXY_PORT=443

# Porta que o serviço do backend deverá ouvir
PORT=3000

# conexão com o banco de dados
DB_DIALECT=postgres
DB_PORT=5432
POSTGRES_HOST=localhost
POSTGRES_USER=${db_user}
POSTGRES_PASSWORD=${db_pass}
POSTGRES_DB=${db_name}

# Chaves para criptografia do token jwt
JWT_SECRET=${jwt_secret}
JWT_REFRESH_SECRET=${jwt_refresh_secret}

# Dados de conexão com o REDIS
IO_REDIS_SERVER=localhost
IO_REDIS_PASSWORD='${redis_pass}'
IO_REDIS_PORT='6379'
IO_REDIS_DB_SESSION='2'
REDIS_URI=redis://:${redis_pass}@127.0.0.1:6379

#CHROME_BIN=/usr/bin/google-chrome
CHROME_BIN=/usr/bin/chromium-browser
C#HROME_BIN=/usr/bin/google-chrome-stable
#CHROME_BIN=/usr/bin/vivaldi
#CHROME_BIN=null

# tempo para randomização da mensagem de horário de funcionamento
MIN_SLEEP_BUSINESS_HOURS=10000
MAX_SLEEP_BUSINESS_HOURS=20000

# tempo para randomização das mensagens do bot
MIN_SLEEP_AUTO_REPLY=4000
MAX_SLEEP_AUTO_REPLY=6000

# tempo para randomização das mensagens gerais
MIN_SLEEP_INTERVAL=2000
MAX_SLEEP_INTERVAL=5000

# dados do RabbitMQ / Para não utilizar, basta comentar a var AMQP_URL
# ABBITMQ_DEFAULT_PASS=${rabbitmq_pass}
AMQP_URL='amqp://guest:guest@127.0.0.1:5672?connection_attempts=5&retry_delay=5'

# api oficial (integração em desenvolvimento)
API_URL_360=https://waba-sandbox.360dialog.io

# usado para mosrar opções não disponíveis normalmente.
ADMIN_DOMAIN=${urlprincipal_url}
#DB_TIMEZONE=-03:00

# Dados para utilização do canal do facebook
FACEBOOK_APP_ID=3237415623048660
FACEBOOK_APP_SECRET_KEY=3266214132b8c98ac59f3e957a5efeaaa13500


# Limitar Uso do whapichat Usuario e Conexões
USER_LIMIT=999
CONNECTIONS_LIMIT=999


[-]EOF
EOF

  sleep 2
}


#####################################################################################################################
# updates backend code
# Arguments:
#   None
#####################################################################################################################
backend_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando o backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/$instancia
  git pull 
  cd /home/deploy/$instancia/backend
  npm install
  rm -rf dist 
  npm run build
  npx sequelize db:migrate
  pm2 restart all
EOF

  sleep 2
}

#####################################################################################################################
# updates Whastapp.js
# Arguments:
#   None
#####################################################################################################################
whatsappweb_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando o whatsapp.js...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  cd /home/deploy/${instancia}/backend
  pm2 stop all
  rm .wwebjs_auth -Rf
  rm .wwebjs_cache -Rf
  npm r whatsapp-web.js
  npm install github:pedroslopez/whatsapp-web.js#webpack-exodus
  pm2 restart all
EOF

  sleep 2
}