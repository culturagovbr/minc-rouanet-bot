# Rouanet Bot

O Rouanet Bot é um projeto desenvolvido pelo LAPPIS (Laboratório Avançado de Produção, Pesquisa e Inovação em Software), da Universidade
de Brasília, em parceria com o Ministério da Cultura, para responder dúvidas dos usuários relacionadas à Lei Rouanet.
O projeto é desenvolvido com base no Rocket Chat e no Hubot-Natural.

## Ambiente

Uma vez que você tenha instalada o docker-compose, é possível executar o Rouanet Bot através dos seguintes comandos,
executados dentro da pasta do projeto:

```sh
docker-compose up -d mongo
```
```sh
docker-compose up -d mongo-init-replica
```
```sh
docker-compose up -d rocketchat
```
```sh
docker-compose up hubot-natural
```
  
    
O Rocket Chat é executado na porta 3000 e o Hubot-Natural na porta 3001, conforme definido no arquivo docker-compose.yml. 
Acessando http://localhost:3000/ você terá acesso ao Rocket Chat.

## Adicionando o bot

Para adicionar o bot ao seu Rocket Chat, você deve criar uma conta de administrador. Logo, na tela inicial do Rocket Chat clique em 
Register a new account, e preencha as informações, não precisa ser utilizado um e-mail real.

![New account example](https://gitlab.com/lappis-unb/minc/rouanet-bot/wikis/new_account.png)

Após preencher as informações, clique em REGISTER A NEW ACCOUNT, e em seguida, volte ao login e entre utilizando as 
informações preenchidas anteriormente.

No menu lateral esquerdo, ao lado do nome da sua conta, clique na seta para baixo, e clique na opção Administration.

![Adm option](https://gitlab.com/lappis-unb/minc/rouanet-bot/wikis/adm_sidebar.png)

Logo em seguida, clique na opção Users. Aparecerá uma barra lateral direita com uma opção com um +. Clique nesta opção e preencha as informações 
conforme a imagem a seguir. O nome do bot pode ser alterado, mas devem ser usados o usuário e senha que estão definidos nas variáveis
ROCKETCHAT_USER e ROCKETCHAT_PASSWORD no arquivo docker-compose.yml. Por padrão, o usuário e senha são, botnat e botnatpass, respectivamente.

Para adicionar a role ao bot, clique na opção Select a Role, selecione bot e clique na opção ADD ROLE. Por fim, clique em Save.

![Adm option](https://gitlab.com/lappis-unb/minc/rouanet-bot/wikis/adding_bot.png)

Agora você já está apto a conversar com o bot diretamente, ou pelos canais usando @botnat antes da mensagem.

### Livechat