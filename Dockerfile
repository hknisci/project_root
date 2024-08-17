# Node.js bazlı bir imaj kullan
FROM node:14

# Uygulamanın çalışacağı çalışma dizinini ayarla
WORKDIR /app

# package.json ve package-lock.json dosyalarını kopyala
COPY nodejs-express-mysql/package*.json ./

# Uygulamanın bağımlılıklarını yükle
RUN npm install

# Tüm uygulama dosyalarını kopyala
COPY nodejs-express-mysql/ ./

# Uygulamanın çalıştırılacağı portu belirle
EXPOSE 3000

# Uygulamayı başlat
CMD ["node", "server.js"]
