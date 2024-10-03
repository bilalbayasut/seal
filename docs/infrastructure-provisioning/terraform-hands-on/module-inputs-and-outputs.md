# Task 4: Wordpress Live

Finally, run the following command to deploy the WordPress stack. Make sure that you are running below command where the **`docker-compose.yml`** file saved.

```
docker-compose up -d
```

This will download the required Docker images and start Wordpress container along with Apache Webserver and PHP. You should be able to access the WordPress site by visiting **`http://EC2_publicip`** in your web browser.

<figure><img src="https://miro.medium.com/v2/resize:fit:700/1*HJhUWG3P9f-GG-jcoMhg4g.png" alt="" height="121" width="700"><figcaption></figcaption></figure>

In this case 3.89.195.28 so, it will be **`http://3.89.195.28` .** You can replace with your EC2 public ip.

<figure><img src="https://miro.medium.com/v2/resize:fit:700/1*2lCR5J8iHoGMX-5DIju13Q.png" alt="" height="439" width="700"><figcaption></figcaption></figure>

## Terraform destroy <a href="#bdde" id="bdde"></a>

To remove all your setup use the following command. It will remove each and every resource that you have created using terraform.

```
terraform destroy
```
