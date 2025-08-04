#!/bin/bash

# Laravel PHP Developer Environment Setup Script for Ubuntu 25
# This script installs NGinx, PHP-FPM, Composer, and all required dependencies
# for Laravel development.

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Try using sudo."
    exit 1
fi

# Update system packages
echo "Updating system packages..."
apt-get update
apt-get upgrade -y

# Install basic development tools
echo "Installing basic development tools..."
apt-get install -y git curl unzip build-essential

# Install NGinx
echo "Installing NGinx..."
apt-get install -y nginx

# Install PHP and required extensions
echo "Installing PHP and extensions..."
apt-get install -y php-fpm php-cli php-mysql php-pgsql php-sqlite3 php-redis \
    php-gd php-imagick php-mbstring php-xml php-zip php-curl php-bcmath \
    php-intl php-soap php-xmlrpc php-common php-json php-opcache

# Install Node.js and npm (for frontend dependencies)
echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

# Install Composer
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install database servers (MySQL and PostgreSQL)
echo "Installing database servers..."
apt-get install -y mysql-server postgresql postgresql-contrib

# Configure PHP-FPM
echo "Configuring PHP-FPM..."
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/*/fpm/php.ini
systemctl restart php*-fpm.service

# Configure NGinx for PHP-FPM
echo "Configuring NGinx for PHP-FPM..."
cat > /etc/nginx/sites-available/laravel << 'EOL'
server {
    listen 80;
    server_name localhost;
    root /var/www/html/public;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOL

ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
systemctl restart nginx

# Install Redis
echo "Installing Redis..."
apt-get install -y redis-server
systemctl enable redis-server
systemctl start redis-server

# Install Memcached
echo "Installing Memcached..."
apt-get install -y memcached php-memcached
systemctl enable memcached
systemctl start memcached

# Install Laravel dependencies via Composer globally
echo "Installing Laravel installer..."
sudo -u $SUDO_USER composer global require laravel/installer

# Add Composer's global bin directory to PATH
echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> /home/$SUDO_USER/.bashrc
source /home/$SUDO_USER/.bashrc

# Set proper permissions for web directory
echo "Setting up web directory permissions..."
mkdir -p /var/www/html
chown -R $SUDO_USER:$SUDO_USER /var/www/html
chmod -R 755 /var/www

# Install additional useful tools
echo "Installing additional developer tools..."
apt-get install -y htop tmux

# Clean up
echo "Cleaning up..."
apt-get autoremove -y
apt-get clean

echo ""
echo "Laravel development environment setup complete!"
echo "Here are the installed versions:"
echo ""
echo "PHP: $(php -v | head -n 1)"
echo "NGinx: $(nginx -v 2>&1)"
echo "MySQL: $(mysql --version)"
echo "PostgreSQL: $(psql --version)"
echo "Node.js: $(node -v)"
echo "npm: $(npm -v)"
echo "Composer: $(composer --version)"
echo ""
echo "You can now create a new Laravel project with:"
echo "  laravel new project-name"
echo "or"
echo "  composer create-project --prefer-dist laravel/laravel project-name"
echo ""
echo "Don't forget to configure your database connections as needed."