FROM centos:7.6.1810

LABEL "com.github.actions.name"="CMake"
LABEL "com.github.actions.description"="Build CMake projects"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="http://github.com/popperized/cmake"
LABEL "homepage"="http://github.com/systemslab/popper"
LABEL "maintainer"="Ivo Jimenez <ivo@cs.ucsc.edu>"

RUN yum install -y git gcc g++ make cmake ccache && \
    yum clean all && \
    rm -rf /var/cache/yum
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
