# ---------- Etapa 1: preparar archivos estáticos con configuración inyectada ----------
FROM alpine:3.19 AS build

ARG BACKEND_URL=http://localhost:3001

WORKDIR /site
COPY index.html app.js config.template.js ./

# Sustituye el placeholder por la URL real del backend (pasada como build-arg)
RUN sed "s|__BACKEND_URL__|${BACKEND_URL}|g" config.template.js > config.js && \
    rm config.template.js

# ---------- Etapa 2: imagen final, minimalista ----------
FROM nginx:1.27-alpine AS runtime

RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /site/index.html /usr/share/nginx/html/index.html
COPY --from=build /site/app.js /usr/share/nginx/html/app.js
COPY --from=build /site/config.js /usr/share/nginx/html/config.js

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
