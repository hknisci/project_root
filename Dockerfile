# Node.js bazlı bir imaj kullan
FROM node:14

# Uygulama dosyalarını container içine kopyala
WORKDIR /app
COPY nodejs-express-mysql/package*.json ./
RUN npm install
COPY . .

# Uygulamanın çalıştırılacağı portu belirle
EXPOSE 3000

# Uygulamayı çalıştır
CMD ["npm", "start"]
