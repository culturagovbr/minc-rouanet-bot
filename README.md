# Rouanet Bot

O Rouanet Bot é um projeto desenvolvido pelo LAPPIS (Laboratório Avançado de Produção, Pesquisa e Inovação em Software), da Universidade
de Brasília, em parceria com o Ministério da Cultura, para responder dúvidas dos usuários relacionadas à Lei Rouanet.
O projeto é desenvolvido com base no Rocket Chat e no Hubot-Natural.

## Ambiente

Uma vez que você tenha instalado o [docker-compose](https://docs.docker.com/compose/install/), é possível executar o Rouanet Bot através dos seguintes comandos,
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
  
    
O Rocket Chat é executado na porta 3000 e o Hubot-Natural na porta 3001, conforme definido no arquivo docker-compose.yml. Caso alguma dessas portas 
já estejam sendo utilizadas na sua máquina, altere a configuração neste arquivo.
Com as configurações padrões, acessando http://localhost:3000/ você terá acesso ao Rocket Chat.

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

![Adding bot tutorial](https://gitlab.com/lappis-unb/minc/rouanet-bot/wikis/adding_bot.png)

Agora você já está apto a conversar com o bot diretamente, ou pelos canais usando @botnat antes da mensagem.

### Livechat

O livechat permite que seja criada uma janela de conversa com o bot integrável à outras páginas. Para ativá-lo acesse novamente a opção 
Administration, clicando na seta para baixo, ao lado do nome da sua conta, no meu lateral esquerdo. Em seguida, clique na opção Livechat.

![Livechat option on adm menu](https://gitlab.com/lappis-unb/minc/rouanet-bot/wikis/livechat_sidebar.png)

Na tela seguinte, marque a opção Livechat enabled como True e clique em SAVE CHANGES.

![Livechat activation screen](https://gitlab.com/lappis-unb/minc/rouanet-bot/wikis/active_livechat.png)

Fehe o menu lateral esquerdo de administração e clique novamente na seta para baixo, ao lado do nome da sua conta. Clique na opção Livechat.

![Livechat option](https://gitlab.com/lappis-unb/minc/rouanet-bot/wikis/livechat_option.png)

No menu lateral esquerdo Livechat, selecione a opção User Management. Você deve adicionar o bot como um agente, logo procure por botnat, 
e em seguida clique em ADD.

![Adding bot as agent](https://gitlab.com/lappis-unb/minc/rouanet-bot/wikis/add_agent.png)

Agora é necessário criar um departamento. No menu lateral esquerdo, clique em Departments, e em seguida em NEW DEPARTMENT.

![Adding bot as agent](https://gitlab.com/lappis-unb/minc/rouanet-bot/wikis/new_department.png)

Na tela seguinte, preencha um nome e uma descrição para o departamento e adicione o bot clicando no bot desejado em Available agents.
Em seguida clique em Save.

![Create new department](https://gitlab.com/lappis-unb/minc/rouanet-bot/wikis/add_agent_to_department.png)

No menu lateral esquerdo, clique em Installation. Agora é só copiar o código exibido e colar no site o qual você deseja integrar 
a janela de conversa com o bot.

![Installation code](https://gitlab.com/lappis-unb/minc/rouanet-bot/wikis/installation.png)

Após integrar o código ao seu site, uma janela semelhante a da imagem a seguir deve estar disponível.

![Livechat window](https://gitlab.com/lappis-unb/minc/rouanet-bot/wikis/livechat.png)

## Alterando o YAML

Para mais informações sobre a estrutura do YAML e como modificá-lo, acesse o [README do Hubot-Natural](https://github.com/RocketChat/hubot-natural/blob/master/README.md).
