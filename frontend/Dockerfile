#Base ligera para validar/preparar
FROM alpine:3.18 AS verify
WORKDIR /app
COPY . .

#Servidor de producción optimizado
FROM nginx:1.25-alpine

# Eliminar contenido por defecto
RUN rm -rf /usr/share/nginx/html/*
# Copiar archivos estáticos
COPY --from=verify /app /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
