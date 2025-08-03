FROM php:8.2-cli

# 安裝常見套件
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev zip libpng-dev libonig-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# 安裝 Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 建立工作目錄
WORKDIR /var/www

# 複製專案檔案
COPY . .

# 安裝 Laravel 套件
RUN composer install --no-dev --optimize-autoloader

# 設定 Laravel config 快取（你也可以用 buildCommand 處理）
RUN php artisan config:cache

# 開啟伺服器
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]