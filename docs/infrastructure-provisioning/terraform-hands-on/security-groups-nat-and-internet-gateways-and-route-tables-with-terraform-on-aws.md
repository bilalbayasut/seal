# Task 2 : Docker

After creating all resources over Terraform. Now, go to the EC2 instance that you have created, click the **Connect** button in the right corner of the page. Select the **SSH client method** option. In the **Command line client** section, copy the command that is provided. Open a terminal window and paste the command. Press Enter to connect to your EC2 instance.

<figure><img src="../../.gitbook/assets/image (1) (1).png" alt=""><figcaption></figcaption></figure>

Once you have successfully SSHed into your EC2 instance, install **Docker and Docker Compose**. To do this, you can find all the commands for [Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04) and [Docker compose](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-22-04) .

Run below command, if you want to avoid typing `sudo` whenever you run `docker` command, add your username to the `docker` group. **(exit the ssh, and reconnect again to take effect)**

```bash
sudo usermod -aG docker ${USER}
```

Create a Docker compose file with a name of your choice. The file extension should be `.yml`.

let’s name it docker-compose.yml and save it with following content:

```
version: "3"

services:
  wordpress:
    image: wordpress:latest
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: my-rds-instance.c**********.us-east-1.rds.amazonaws.com
      WORDPRESS_DB_USER: bilal
      WORDPRESS_DB_PASSWORD: Bilal123456
      WORDPRESS_DB_NAME: wordpressdb
    volumes:
      - wordpress_data:/var/www/html

volumes:
  wordpress_data:
```

<figure><img src="../../.gitbook/assets/image (9).png" alt=""><figcaption></figcaption></figure>

Make sure to replace the values of **`WORDPRESS_DB_HOST`**, **`WORDPRESS_DB_USER`**, **`WORDPRESS_DB_PASSWORD`**, and **`WORDPRESS_DB_NAME`** with your values for your RDS instance.

Now, run following commands to build the images:
