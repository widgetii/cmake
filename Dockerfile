FROM debian:sid-20190506-slim

RUN apt update && \
    apt install -y git build-essential cmake ccache && \
    apt autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
