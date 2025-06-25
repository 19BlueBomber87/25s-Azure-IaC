# Update apt cache.
sudo apt-get update

#We need to add repo before installing nginx-core. Otherwise we get an error
sudo add-apt-repository main
sudo add-apt-repository universe
sudo add-apt-repository restricted
sudo add-apt-repository multiverse  

# Install Nginx.
sudo apt-get install -y nginx

# Set the home page.
sudo curl https://raw.githubusercontent.com/19BlueBomber87/25s-Azure-IaC/refs/heads/main/html/azurehome.html -o /var/www/html/index.html

#get computer name and add it to home page
host=$(hostname)
sed -i "s/Custom Heading Size and Font Type/Welcome to Azure!! Computer Name is-> $host/g" /var/www/html/index.html

sudo mkdir /var/www/html/jpg

sudo curl "https://github.com/19BlueBomber87/25s-Azure-IaC/blob/main/html/cert.jpg" -o /var/www/html/jpg/cert.jpg
sudo curl "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/AquaMoose.jpg" -o /var/www/html/jpg/AquaMoose.jpg
sudo curl "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/babymoose2.jpg" -o /var/www/html/jpg/babymoose2.jpg
sudo curl "https://raw.githubusercontent.com/19BlueBomber87/toDoApp/refs/heads/master/jpg/bull.jpg" -o /var/www/html/jpg/bull.jpg
