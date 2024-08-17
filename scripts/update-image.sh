#!/bin/bash

# Değişkenler
APP_NAME="nodejs-express-mysql"
NAMESPACE="prod"
NEW_IMAGE_TAG=$1

if [ -z "$NEW_IMAGE_TAG" ]; then
  echo "Yeni image tag'i belirtilmedi. Kullanım: ./update-image.sh <new-image-tag>"
  exit 1
fi

# Deployment güncellenmesi
echo "$APP_NAME uygulamasının imajı $NEW_IMAGE_TAG ile güncelleniyor..."
kubectl set image deployment/$APP_NAME $APP_NAME=myregistry/nodejs-express-mysql:$NEW_IMAGE_TAG --namespace $NAMESPACE

# ArgoCD uygulama senkronizasyonu (opsiyonel)
echo "ArgoCD uygulaması senkronize ediliyor..."
argocd app sync $APP_NAME --namespace $NAMESPACE

echo "$APP_NAME uygulamasının imajı başarıyla güncellendi!"
