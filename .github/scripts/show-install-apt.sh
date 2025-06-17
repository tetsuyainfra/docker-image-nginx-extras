#!/bin/bash
DOCKER_IMAGE="ubuntu:24.04"
INSTALL_PACKAGES="nginx nginx-extras"

# pullして最新にする
docker pull $DOCKER_IMAGE > /dev/null 2>&1

docker run --pull never --rm $DOCKER_IMAGE\
    bash -c "dpkg-query -W -f='\${binary:Package} \${Version}\n'"

# show upgrade packages/ install pacakge
docker run --pull never --rm $DOCKER_IMAGE \
    bash -c "apt-get update > /dev/null && \
                echo ----- && \
                apt list --upgradable 2>/dev/null | grep -v 'Listing...' | tr / ' ' | awk '{print \$1, \$3}' && \
                echo ----- && \
                apt-get install -s $INSTALL_PACKAGES | grep ^Inst | tr -d '(' | awk '{print \$2, \$3}'
            "

# show nginx version
# docker run --rm $DOCKER_IMAGE \
#    bash -c "apt-get update > /dev/null && apt-cache policy nginx | grep Candidate | awk '{ print \$2 }'"
# docker run --pull never --rm $DOCKER_IMAGE \
#     bash -c "apt-get update > /dev/null && apt-get install -s $INSTALL_PACKAGES | grep ^Inst | tr -d '(' | awk '{print \$2, \$3}'"