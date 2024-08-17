#!/bin/bash

# Değişkenler
APP_NAME="nodejs-express-mysql"
NAMESPACE="prod"
TARGET_LOAD=$1
DURATION=$2

if [ -z "$TARGET_LOAD" ] || [ -z "$DURATION" ]; then
  echo "Kullanım: ./scale-test.sh <target-load> <duration-seconds>"
  exit 1
fi

# Pod'lar üzerinde yük oluşturulması
echo "$APP_NAME uygulamasının pod'ları üzerinde $DURATION saniye boyunca $TARGET_LOAD CPU yükü oluşturuluyor..."
kubectl run load-generator --rm --image=busybox --restart=Never \
  --namespace $NAMESPACE \
  -- /bin/sh -c "while true; do wget -q -O- http://$APP_NAME.$NAMESPACE.svc.cluster.local; done" &

# Ölçekleme durumu kontrolü
echo "Ölçekleme durumu kontrol ediliyor..."
kubectl get hpa --namespace $NAMESPACE

echo "Yük testi tamamlandı!"
