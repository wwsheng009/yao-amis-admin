# 证书申请示例

### 1. 生成 Token Signing Certificates（用于签名 OAuth access tokens）
```sh
# 生成私钥（不加密，生产可加 -aes256 加密）
openssl genrsa -out signing-key.pem 2048

# 生成对应的自签名公钥证书（有效期 365 天，可调整）
MSYS_NO_PATHCONV=1 openssl req -new -x509 -sha256 -days 365 -key signing-key.pem -out signing-cert.pem \
  -subj "/C=CN/ST=YourState/L=YourCity/O=YourOrg/CN=OAuth Signing Certificate" \
  -addext "keyUsage = critical, digitalSignature, keyEncipherment"


# 设置权限
chmod 600 signing-key.pem
chmod 644 signing-cert.pem
```


### 2. 生成 mTLS Client Authentication CA Certificates

```bash
# 生成 CA 私钥（测试专用，生产绝不要放在应用目录）
openssl genrsa -out mtls-client-ca-key-TESTING-ONLY-DO-NOT-USE-IN-PRODUCTION.pem 2048

# 生成 CA 公钥证书（自签名根 CA，有效期 3650 天）
MSYS_NO_PATHCONV=1  openssl req -new -x509 -sha256 -days 3650 \
  -key mtls-client-ca-key-TESTING-ONLY-DO-NOT-USE-IN-PRODUCTION.pem \
  -out mtls-client-ca.pem \
  -subj "/C=CN/ST=YourState/L=YourCity/O=YourOrg/CN=mTLS Client CA" \
  -addext "basicConstraints=CA:TRUE" \
  -addext "keyUsage=keyCertSign,cRLSign" \
  -addext "keyUsage = critical, digitalSignature, keyEncipherment"

# 设置权限
chmod 600 mtls-client-ca-key-TESTING-ONLY-DO-NOT-USE-IN-PRODUCTION.pem
chmod 644 mtls-client-ca.pem
```

### 可选：使用该 CA 签发一个测试客户端证书（验证 mTLS 流程）
```sh
# 生成客户端私钥
openssl genrsa -out client-key.pem 2048

# 生成客户端证书请求 (CSR)
MSYS_NO_PATHCONV=1 openssl req -new -key client-key.pem -out client.csr \
  -subj "/C=CN/ST=YourState/L=YourCity/O=YourOrg/CN=Test Client" \
  -addext "keyUsage = critical, digitalSignature, keyEncipherment"


MSYS_NO_PATHCONV=1 openssl x509 -req -sha256 -days 365 -in client.csr \
  -CA mtls-client-ca.pem \
  -CAkey mtls-client-ca-key-TESTING-ONLY-DO-NOT-USE-IN-PRODUCTION.pem \
  -CAcreateserial -out client-cert.pem \
  -extfile client.ext

# 清理临时文件
rm client.csr
```


### 检查命令
```sh
# Check certificate details
openssl x509 -in signing-cert.pem -text -noout

# Verify certificate chain
openssl verify -CAfile mtls-client-ca.pem client-cert.pem

# Check certificate expiration
openssl x509 -in signing-cert.pem -noout -dates
```

检查KeyUsage

```sh
openssl x509 -in signing-cert.pem -noout -text | grep -A 1 "Key Usage"
```

确保输出包含以下内容：
```txt
X509v3 Key Usage: critical
Digital Signature, Key Encipherment
```
