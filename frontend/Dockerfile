FROM alpine:3.18 AS verify
WORKDIR /app
COPY . .

FROM nginx:1.25-alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=verify /app /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
