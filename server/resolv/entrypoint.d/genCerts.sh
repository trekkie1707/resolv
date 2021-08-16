CAPRIV=/etc/nginx/ssl/ca-private-key.pem
if test -f "$CAPRIV"; then
  echo "Certs already created!"
else
  openssl ecparam -name prime256v1 -genkey -noout -out /etc/nginx/ssl/ca-private-key.pem
  openssl req -new -x509 -key /etc/nginx/ssl/ca-private-key.pem -out /etc/nginx/ssl/ca-cert.pem -days 1800  -subj "/C=US/ST=GA/L=ATLANTA/O=SELF/OU=PERSONAL/CN=nginx"
  openssl ecparam -name prime256v1 -genkey -noout -out /etc/nginx/ssl/private-key.pem
  openssl req -new -key /etc/nginx/ssl/private-key.pem -out /etc/nginx/ssl/client.csr -subj "/C=US/ST=GA/L=ATLANTA/O=SELF/OU=PERSONAL/CN=LOCALHOST"
  openssl x509 -req -in /etc/nginx/ssl/client.csr -CA /etc/nginx/ssl/ca-cert.pem -CAkey /etc/nginx/ssl/ca-private-key.pem -CAcreateserial -out /etc/nginx/ssl/client.pem -days 1800 -sha256
  openssl pkcs12 -inkey /etc/nginx/ssl/private-key.pem -in /etc/nginx/ssl/client.pem -export -out /etc/nginx/ssl/client.pfx -passout pass:
fi