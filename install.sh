#!/bin/bash
sudo apt update
sudo apt install unzip
sudo mkdir -p /tmp/newrapor2025
sudo mkdir -p /tmp/dbraporsp25
sudo tar -xzvf newraporsp2025.tar.gz -C /tmp/newrapor2025
sudo cp /tmp/newrapor2025/tmp/dbraporsp/dberaporsplinux.sql /tmp/dbraporsp25
sudo rsync -avz /tmp/newrapor2025/var/www/wwwroot /var/www/ 
# Memperbarui dan meng-upgrade sistem 
sudo apt update && sudo apt upgrade -y
sudo apt install nginx -y 
sudo systemctl enable nginx
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install php8.2 php8.2-fpm php8.2-pgsql php8.2-cli php8.2-curl php8.2-gd php8.2-mbstring php8.2-xml php8.2-zip php8.2-soap php8.2-intl -y
sudo systemctl enable php8.2-fpm
sudo systemctl start php8.2-fpm
uname -m
cd /tmp
wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -xzf ioncube_loaders_lin_x86-64.tar.gz
sudo mkdir -p /usr/local/ioncube
sudo cp -r ioncube/* /usr/local/ioncube
sudo sed -i '/^; Dynamic Extensions/i zend_extension=/usr/local/ioncube/ioncube_loader_lin_8.2.so' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^max_execution_time = .*/max_execution_time = 3000000/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^max_input_time = .*/max_input_time = -1/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^memory_limit = .*/memory_limit = 20480M/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^post_max_size = .*/post_max_size = 10240M/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 1024M/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^default_socket_timeout = .*/default_socket_timeout = 600000/' /etc/php/8.2/fpm/php.ini
echo "max_input_vars = 50000" | sudo tee -a /etc/php/8.2/fpm/php.ini
echo "suhosin.request.max_vars = 50000" | sudo tee -a /etc/php/8.2/fpm/php.ini
echo "suhosin.post.max_vars = 50000" | sudo tee -a /etc/php/8.2/fpm/php.ini
echo "suhosin.get.max_vars = 50000" | sudo tee -a /etc/php/8.2/fpm/php.ini
echo "suhosin.cookie.max_vars = 50000" | sudo tee -a /etc/php/8.2/fpm/php.ini
sudo sed -i '/^; Dynamic Extensions/i zend_extension=/usr/local/ioncube/ioncube_loader_lin_8.2.so' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^max_execution_time = .*/max_execution_time = 3000000/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^max_input_time = .*/max_input_time = -1/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^memory_limit = .*/memory_limit = 20480M/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^post_max_size = .*/post_max_size = 10240M/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 1024M/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^default_socket_timeout = .*/default_socket_timeout = 600000/' /etc/php/8.2/cli/php.ini
echo "max_input_vars = 50000" | sudo tee -a /etc/php/8.2/cli/php.ini
echo "suhosin.request.max_vars = 50000" | sudo tee -a /etc/php/8.2/cli/php.ini
echo "suhosin.post.max_vars = 50000" | sudo tee -a /etc/php/8.2/cli/php.ini
echo "suhosin.get.max_vars = 50000" | sudo tee -a /etc/php/8.2/cli/php.ini
echo "suhosin.cookie.max_vars = 50000" | sudo tee -a /etc/php/8.2/cli/php.ini
sudo systemctl restart php8.2-fpm
sudo apt install wget -y
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt update
sudo apt install postgresql-14 -y  
sudo systemctl start postgresql
DB_NAME="dbraporsp25"
DB_USER="raporsp_user"
DB_PASS="secrets_deveraporsp2025*#rsppasek" 
sudo -u postgres psql <<EOF 
DROP DATABASE IF EXISTS $DB_NAME; 
DO
\$do\$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = '$DB_USER'
   ) THEN
      CREATE ROLE $DB_USER LOGIN PASSWORD '$DB_PASS';
   END IF;
END
\$do\$;
CREATE DATABASE $DB_NAME OWNER $DB_USER;
\c $DB_NAME; 
\i /tmp/dbraporsp25/dberaporsplinux.sql;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA nilai TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA nilai TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA nilai TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA pkl TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA pkl TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA pkl TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA projec TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA projec TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA projec TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA tambah TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA tambah TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA tambah TO $DB_USER;
\q
EOF

sudo mkdir -p /etc/raporsp
DB_PORT=$(sudo -u postgres psql -t -c "SHOW port;" | tr -d '[:space:]')
sudo tee /etc/raporsp/.encapp > /dev/null <<EOF
UB_PASSWORD=$DB_PASS
U_USER=$DB_USER
DB_PORT=$DB_PORT
WebPort=8055
EOF

sudo tee /etc/nginx/sites-available/raporsp2025 > /dev/null <<EOF
server {
    listen 8055 default_server;
    listen [::]:8055 default_server;
    server_name _;

    root /var/www/wwwroot/public;
    index index.php index.html index.htm;

    access_log /var/log/nginx/wwwroot.access.log;
    error_log /var/log/nginx/wwwroot.error.log;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    client_max_body_size 1024M;
    keepalive_timeout 60000;
}
EOF
sudo chown -R www-data:www-data /var/www/wwwroot/writable/
sudo chmod -R 775 /var/www/wwwroot/writable/
sudo chown -R www-data:www-data /var/www/wwwroot/public/bcfile/
sudo chmod -R 775 /var/www/wwwroot/public/bcfile/
sudo chown -R www-data:www-data /var/www/wwwroot/public/excel/
sudo chmod -R 775 /var/www/wwwroot/public/excel/
sudo chown -R www-data:www-data /var/www/wwwroot/public/images/
sudo chmod -R 775 /var/www/wwwroot/public/images/
sudo chown -R www-data:www-data /var/www/wwwroot/public/pdf/
sudo chmod -R 775 /var/www/wwwroot/public/pdf/
sudo chown -R www-data:www-data /var/www/wwwroot/public/restore/
sudo chmod -R 775 /var/www/wwwroot/public/restore/
sudo chown -R www-data:www-data /var/www/wwwroot/public/tempup/
sudo chmod -R 775 /var/www/wwwroot/public/tempup/
sudo chown -R www-data:www-data /var/www/wwwroot/public/uploads/
sudo chmod -R 775 /var/www/wwwroot/public/uploads/
sudo ln -s /etc/nginx/sites-available/raporsp2025 /etc/nginx/sites-enabled/
sudo systemctl reload nginx
sudo systemctl reload php8.2-fpm
sudo systemctl reload postgresql
sudo systemctl restart php8.2-fpm
sudo systemctl restart postgresql
sudo systemctl restart nginx
sudo rm -r /tmp/newrapor2025
sudo rm -r /tmp/dbraporsp25
sudo rm newraporsp2025.tar.gz 
sudo rm install.sh