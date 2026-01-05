

openssl ecparam -genkey -name prime256v1 -out master-local.key

openssl req -new -key master-local.key -out master-local.csr

openssl x509 -req -days 365 -in master-local.csr -signkey master-local.key -out master-local.crt
