#!/bin/bash
#
# Variables to be used for background styling.

# app variables

jwt_secret=$(openssl rand -base64 32)
jwt_refresh_secret=$(openssl rand -base64 32)

whapichatdown=https://github.com/jvkabum/TikTickets-zing.git
#MODO DEV
rabbitmq_pass=cPnaZ99zM9rcTSgUGekYoROGXvCaLLQIacaiEL13jiQ
arquitetura=$(dpkg --print-architecture)
backend_porta=3000
frontend_porta=3333
redis_pass=XwJHGK6c2nSmGMkh1KXdZkxx2aaaCPRSr3f8nRml

#deploy_password=password

#postgres_root_password=password

#db_pass=password

#deploy_email=seuemail@gmail.com
