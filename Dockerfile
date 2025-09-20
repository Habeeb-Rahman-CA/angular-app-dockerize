FROM node:20-alpine

RUN addgroup app && adduser -S -G app app

WORKDIR /app

COPY package*.json ./

USER root
RUN chown -R app:app /app
USER app

RUN npm install

COPY . .

EXPOSE 4200

CMD ["npm", "run", "start"]
