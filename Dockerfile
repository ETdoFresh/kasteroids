FROM ubuntu

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
	gdb \
    git \
    python \
    python-openssl \
    unzip \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://downloads.tuxfamily.org/godotengine/3.2.2/Godot_v3.2.2-stable_linux_server.64.zip && \
    unzip Godot_v3.2.2-stable_linux_server.64.zip && \
    mv Godot_v3.2.2-stable_linux_server.64 /usr/local/bin/godot-server && \
    rm -f Godot_v3.2.2-stable_linux_server.64.zip

RUN mkdir app
COPY ./ app/
RUN sed -i 's/run\/main_scene=.*/run\/main_scene="res:\/\/scenes\/web_socket\/server.tscn"/g' app/project.godot
WORKDIR app

CMD gdb -ex run --args /usr/local/bin/godot-server --path /app
#CMD godot-server