#!/bin/bash

# 创建调试密钥库
KEYSTORE_PATH="magnet-manager-debug.p12"
KEY_ALIAS="magnet-manager-debug"
STORE_PASS="123456"
KEY_PASS="123456"

echo "创建鸿蒙应用签名证书..."
echo "密钥库: $KEYSTORE_PATH"
echo "别名: $KEY_ALIAS"

# 使用keytool创建p12文件（需要JDK）
keytool -genkeypair -alias "$KEY_ALIAS" \
  -keyalg RSA -keysize 2048 \
  -validity 3650 \
  -storetype PKCS12 \
  -keystore "$KEYSTORE_PATH" \
  -storepass "$STORE_PASS" \
  -keypass "$KEY_PASS" \
  -dname "CN=Magnet Manager Debug, OU=HarmonyOS, O=ninemonths, L=Shanghai, ST=Shanghai, C=CN"

if [ $? -eq 0 ]; then
  echo "✅ 签名证书创建成功！"
  echo "文件位置: $(pwd)/$KEYSTORE_PATH"
  echo ""
  echo "在DevEco Studio中配置："
  echo "1. File → Project Structure → Project → Signing Configs"
  echo "2. 点击 '+' 添加配置"
  echo "3. 选择刚才创建的 .p12 文件"
  echo "4. 密码: $STORE_PASS"
  echo "5. 别名: $KEY_ALIAS"
  echo "6. 密钥密码: $KEY_PASS"
else
  echo "❌ 创建失败，请检查JDK是否安装"
  echo "需要安装JDK 11或17："
  echo "brew install --cask temurin"
fi