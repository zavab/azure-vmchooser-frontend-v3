FROM node:lts-alpine
RUN npm install -g http-server
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ENV API_HOSTNAME=""
ENV APPINSIGHTS_INSTRUMENTATIONKEY=""
RUN npm run build
EXPOSE 8080
CMD [ "http-server", "dist" ]