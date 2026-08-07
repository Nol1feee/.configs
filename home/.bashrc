export PATH="$HOME/.local/bin:$PATH"

if [[ -r /etc/ssl/certs/YandexInternalCA.pem ]]; then
  export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/YandexInternalCA.pem
fi
