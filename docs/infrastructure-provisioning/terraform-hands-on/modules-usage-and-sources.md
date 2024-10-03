# Modules Usage and Sources

To save your Docker container image to Docker Hub, follow these steps:

1. **Docker Hub Account**: Make sure you have a Docker Hub account. If you don’t have one, you can create it at [**https://hub.docker.com/signup**](https://hub.docker.com/signup\*\*) **.**
2. **Docker Login**: Login to your Docker Hub account using the following command:\
   `docker login -u <YOURUSERNAME>`
3. **Tag the Image**: Before pushing the image to Docker Hub, you need to tag it with your Docker Hub username and the desired repository name. The format for tagging an image is:\
   `docker tag wordpress:latest <YOURUSERNAME>/wordpress:new_version`
4. **Push the Image**: After tagging the image, push it to Docker Hub using the following command:\
   `docker push YOUR_DOCKER_HUB_USERNAME/wordpress:new_version`\
   This will push the tagged image to your Docker Hub repository.
5. **Verify on Docker Hub**: Finally, go to your Docker Hub account at [**https://hub.docker.com**](https://hub.docker.com/) and navigate to your repository. You should see the pushed image listed in the repository.

That’s it as per the task. Docker container image is now saved in Docker Hub, and you can use it from anywhere by pulling it with **`docker pull`** and using the image name you specified during the push process.
