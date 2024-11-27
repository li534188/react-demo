# 使用官方的 Node.js 运行时作为父镜像
FROM node:14 AS builder

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制应用文件
COPY . .

# 构建应用
RUN npm run build

# 使用 Nginx 作为生产环境的服务器
FROM nginx:alpine

# 将构建好的应用复制到 Nginx 的默认目录
COPY --from=builder /app/build /usr/share/nginx/html

# 复制自定义的 Nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]