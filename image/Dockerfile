FROM ghcr.io/paperless-ngx/paperless-ngx:v3.0.5

COPY seeds/ /seeds/
COPY branding/ /branding/
COPY run-seed.sh /custom-cont-init.d/10-seed.sh
RUN chmod +x /custom-cont-init.d/10-seed.sh
