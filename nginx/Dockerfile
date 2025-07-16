FROM nginx:alpine

# Copy Cert
COPY nginx/cert.pem /etc/nginx/cert.pem
COPY nginx/key.pem /etc/nginx/key.pem

COPY nginx/default.conf /etc/nginx/conf.d/default.conf