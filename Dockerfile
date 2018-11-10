FROM pureumirnarae/basic:1.0

ENV HOST_NAME=developer

RUN apt-get update && apt-get install -y \
    gconf2-common \
    libxss1 \
    libxtst6 \
    libxkbfile1 \
    libdbus-glib-1-2 \
    libgconf-2-4 \
    libnotify4 \
    libnspr4 \
    libnss3 \
    libsecret-1-0 \
    libsecret-common \
    --no-install-recommends

WORKDIR /tmp
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
 && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ \
 && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > \ 
    /etc/apt/sources.list.d/vscode.list' \
 && rm -f microsoft.gpg

RUN apt-get update && apt-get -y install code --no-install-recommends

ADD utils /tmp/utils
RUN chown -R ${HOST_NAME}:${HOST_NAME} /tmp/utils \
 && mv utils/.uim.d /home/${HOST_NAME} \
 && mv utils/.config /home/${HOST_NAME} \
 && rm -rf /tmp/utils


USER ${HOST_NAME}
WORKDIR /home/${HOST_NAME}

RUN code --install-extension ms-ceintl.vscode-language-pack-ko

CMD ["/usr/bin/code"]

