#!/bin/bash

# Uygulamanın ismi ve namespace tanımları
APP_NAME="nodejs-express-mysql"
NAMESPACE="prod"

# Namespace kontrolü ve oluşturulması
kubectl get namespace $NAMESPACE >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Namespace $NAMESPACE bulunamadı, oluşturuluyor..."
  kubectl create namespace $NAMESPACE
fi

# Helm Chart kullanarak uygulamanın dağıtımı
echo "Helm Chart kullanılarak $APP_NAME uygulaması dağıtılıyor..."
helm upgrade --install $APP_NAME charts/nodejs-express-mysql \
  --namespace $NAMESPACE \
  --values kustomization/overlays/prod/values-prod.yaml

# Deploy durumu kontrolü
echo "$APP_NAME uygulaması dağıtıldı, durumu kontrol ediliyor..."
kubectl rollout status deployment/$APP_NAME --namespace $NAMESPACE

echo "$APP_NAME uygulaması başarıyla dağıtıldı!"
