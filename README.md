# ChatGPT UI Server
This is a simple [ChatGPT UI](https://github.com/WongSaang/chatgpt-ui) server based on the Django framework.

### Development

Create the network to be shared between backend and frontend:

```sh
docker network create chatgpt-ui-network
```

To run the application in development mode, execute the following script:

```sh
docker compose up -d
```