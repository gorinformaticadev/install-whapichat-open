#!/bin/bash
#
# Variables to be used for background styling.

# app variables

jwt_secret=$(openssl rand -base64 32)
jwt_refresh_secret=$(openssl rand -base64 32)

whapichatdown=https://github.com/gorinformaticadev1/TikTickets-whapichat.git
#PRODUÇÃO
branchs=main

#MODO DEV
#branchs=dev

arquitetura=$(dpkg --print-architecture)
backend_porta=3000
frontend_porta=3333
#deploy_password=password

#redis_pass=password

#postgres_root_password=password

#db_pass=password

#deploy_email=atendimentogor@gmail.com
