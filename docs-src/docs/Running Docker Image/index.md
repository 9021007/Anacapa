# Running Prebuilt Docker Image

This tutorial is for users using the prebuilt image. Those looking to build the image themselves should see [Building Docker Image](../Building%20Docker%20Image/Steps).

Make sure you have completed the [Prerequisites](../Prerequisites/docker) before proceeding.

## Running the Container
To run the Anacapa Docker container, use the following command in your terminal:

```bash
docker run -ti --platform linux/amd64 -v /path/to/your/data:/data 902xyz/anacapa bash
```

Breaking that command down:

Command/Argument | Description |
--- | --- |
`docker run` | Tells Docker to run a container
`-ti` | Opens an interactive terminal session. This is a combination of `-t` (terminal) and `-i` (interactive)
`--platform linux/amd64` | Ensures compatibility with the image architecture. This is very important if you have an ARM64 CPU.
`-v /path/to/your/data:/data` | Mounts your local data directory to the container's `/data` directory. Replace `/path/to/your/data` with the actual path on your machine.
`902xyz/anacapa` | Specifies the Docker image to use. This is the prebuilt Anacapa image.
`bash` | Starts a bash shell inside the container.

### Using the Container
You'll know that you're inside the container when the temrinal prompt changes to something like `(base) root@a1b2c3d4e5f6:/app# `.

From here, you can use Anacapa as you normally would. The executables are inside the `/app/Anacapa_db/` directory, and your data is accessible at `/data/`.

To exit the container and return to your host system, simply type `exit` and press Enter. Make sure to copy your data to the data directory before exiting.