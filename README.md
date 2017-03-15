Dockerized EAGLE
================

This project is about installing and running the CadSoft EAGLE 7.7.0 software from a docker image.

You do not have to pollute your original operating system, with installing the several libs and the app itself.
Instead you only need docker to be installed.

At the same time you can keep your projects on your disk, that the EAGLE docker container will reach through volumes.

This solution was made based on the [Running GUI apps with Docker](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/)
blog post written by Fábio Rehm.


## Installation

The final eagle docker images can be made with the following steps:

1. Build the base image.
2. Start the image in the initial container for installation and configuration.
3. Execute the interactive install script.
4. Start the eagle application and set the options pointing to the projects folders, etc.
5. Commit the changes made to the container during the installation and configuration.
6. Push your newly created image to your docker hub as a reference image.
7. Start using the eagle image.

### Build the image

Execute:

```bash
    docker build -t eagle:latest .
```

### Install and configure the initial image

Start the new image in a terminal:

```bash
    docker run \
        -it \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /home/tombenke/topics:/home/developer/topics \
        --name=eagle_base \
        eagle:latest \
        bash
```

Start the EAGLE setup script from an other terminal:

```bash
    docker exec -ti -e DISPLAY=$DISPLAY  eagle_base /home/developer/eagle-lin64-7.7.0.run
```

This opens an X window and goes through the interactive setup session.
It offers a destination folder where to install the executables.
You can accept the default, that is `/home/developer/eagle-7.7.0`.
In the next step, choose the `EAGLE Express` licence.
Then press the `Finish` button and the script finishes its job.

Keep the first docker session running, and now start the installed EAGLE application:

    docker exec -ti -e DISPLAY=$DISPLAY eagle_base /home/developer/eagle-7.7.0/bin/eagle

Say `No` to the question about if you want to set the default project folder to `~/eagle`,
and change the values under the `Options/Directories` dialog box according to your needs.

For example append `:$HOME/topics/eagle_libs` to the `Libraries` field,
then remove the `$HOME/eagle` from the beginning of the `Projects` field, and append `:$HOME/topics` to it.
Now you can exit from the EAGLE application.

Remove the install script:

```bash
    sudo su - 
    rm /home/developer/eagle-lin64-7.7.0.run 
    logout
```

Stop the container running in the original terminal:

```bash
    exit
```

Get the container ID:

```bash
    docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
    f4e14adfb9cb        eagle:latest        "bash"              32 minutes ago      Exited (0) 3 seconds ago                       eagle_base
```

Commit the changes you have made (replace `tombenke` with your account name):

```bash
    docker commit f4e14adfb9cb tombenke/eagle:latest
    sha256:a7f69df3baa0a54dcc8edd7755d7719eb4a3e31535effdde7485d9d5ef053d9b
```

For the sake of brevity, push the image to the docker hub.


## Use the container

Run this if you want the container to be removed after the session:

```bash
    docker run \
        -it \
        --rm \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /home/tombenke/topics:/home/developer/topics \
        tombenke/eagle:latest \
        /home/developer/eagle-7.7.0/bin/eagle
```

In case you want to make changes, then start the container without the `--rm` switch, 
and execute the `commit` and `push` sequence mentioned previously:

```bash
    docker run \
        -it \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /home/tombenke/topics:/home/developer/topics \
        tombenke/eagle:latest \
        /home/developer/eagle-7.7.0/bin/eagle
```

## References

- [Running GUI apps with Docker](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/)
- [Ubuntu Package Search](http://packages.ubuntu.com/)
- [CadSoft EAGLE ftp site](ftp://ftp.cadsoft.de/eagle/program/7.7/)
- [Qt keyboard problem](http://stackoverflow.com/questions/26974644/no-keyboard-input-in-qt-creator-after-update-to-qt5)
