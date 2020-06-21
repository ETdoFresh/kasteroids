FROM ubuntu

RUN mkdir app
COPY ./ app/
RUN sed -i 's/run\/main_scene=.*/run\/main_scene="res:\/\/scenes\/web_socket_server.tscn"/g' app/project.godot

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    python \
    python-openssl \
    unzip \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://downloads.tuxfamily.org/godotengine/3.2.1/Godot_v3.2.1-stable_linux_server.64.zip && \
    unzip Godot_v3.2.1-stable_linux_server.64.zip && \
    mv Godot_v3.2.1-stable_linux_server.64 /usr/local/bin/godot-server && \
    rm -f Godot_v3.2.1-stable_linux_server.64.zip

WORKDIR app

CMD godot-server


### Some Tips
#
# To build a Docker image
# docker build PATH_TO_DOCKER_FILE -t TAG{:VERSION}
# docker build . -t test123
# docker build . -t etdofresh/kasteroids:v2
#
# Run docker in background on on machine port 1234 from program port 5678
# docker run -dp 1234:5678 etdofresh/kasteroids:v2
#
# Run docker in foreground
# docker run -itp 1234:5678 etdofresh/kasteroids:v2
#
# Save docker image for nas
# docker save -o kasteroids.tar etdofresh/kasteroids:v2
#
#
