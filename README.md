# LEMP
Setups PHP environment using Nginx, MySQL, PHP-FPM and Laravel for Ubuntu 25 (Linux)

# How to Use This Script
Save this script to a file (e.g., setup-development-environment.sh)

Make it executable: chmod +x setup-development-environment.sh

Run it with sudo: sudo ./setup-development-environment.sh

# What This Script Installs

Web Server: NGinx

PHP: PHP-FPM with all extensions needed for Laravel

Database Servers: MySQL and PostgreSQL

Cache Servers: Redis and Memcached

Node.js: For frontend dependencies

Composer: PHP dependency manager

Laravel Installer: For creating new Laravel projects

Developer Tools: Git, curl, unzip, etc.

After running this script, you'll have a complete Laravel development environment ready to go. The script also configures NGinx to work with PHP-FPM and sets up proper permissions for your web directory.

Remember to adjust the NGinx configuration if you need to use a different domain or directory structure.
