# Triangulo

Este é um projeto simples utilizando **Node.js** e **Express**, desenvolvido com o propósito de praticar a criação e configuração de **pipelines de CI/CD com o GitHub Actions**.

## Descrição

O projeto consiste em um servidor Express que expõe um único endpoint:

- **GET** `/ready`: Retorna a **data e hora atual no formato GMT/UTC**

## Para executar o projeto

1. Instalar no Node na sua maquina
2. Clonar o repositorio
3. instalar as dependencias do projeto com o comando **npm install**
4. iniciar o servidor utilizando o comando **npm start**

## Para testar

- Utilize o postman para realizar uma requisição para o seguinte endereço: http://localhost:3031/ready
- Ele deve retornar uma mensagem sinalizando que o servidor está respondendo, junto com a data/hora atual.
