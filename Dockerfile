FROM debian:buster-20190506-slim

LABEL "com.github.actions.name"="CMake"
LABEL "com.github.actions.description"="Build CMake projects"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="http://github.com/popperized/cmake"
LABEL "homepage"="http://github.com/systemslab/popper"
LABEL "maintainer"="Ivo Jimenez <ivo@cs.ucsc.edu>"

RUN apt update && \
    apt install -y git build-essential cmake ccache && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
