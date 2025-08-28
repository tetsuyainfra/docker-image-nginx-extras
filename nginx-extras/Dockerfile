ARG DOCKER_BASE_IMAGE=debian:trixie
FROM $DOCKER_BASE_IMAGE

ARG INSTALL_PACKAGES="nginx nginx-extras libnginx-mod-http-js libnginx-mod-stream-js"

RUN set -eux; \
        env ; \
        apt-get update; \
        DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y; \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
                ${INSTALL_PACKAGES} ca-certificates tzdata ; \
        DEBIAN_FRONTEND=noninteractive apt-get remove --purge --auto-remove -y; \
        rm -rf /var/lib/apt/lists/*; \
        # Change default configuration to allow local network access \
        # link for logging
        ln -sf /dev/stdout /var/log/nginx/access.log ; \
        ln -sf /dev/stderr /var/log/nginx/error.log ; \
        # create manifest \
        mkdir -p /usr/share/rocks; \
        # (echo "# os-release" && cat /etc/os-release && echo "# dpkg-query" && dpkg-query -f '${db:Status-Abbrev},${binary:Package},${Version},${source:Package},${Source:Version}\n' -W) > /usr/share/rocks/dpkg.query \
        (dpkg-query -f '${binary:Package},${Version}\n' -W | sort) > /usr/share/rocks/packages.list

COPY --from=nginx:bookworm docker-entrypoint.sh /
COPY --from=nginx:bookworm /docker-entrypoint.d /docker-entrypoint.d

EXPOSE 80 443
STOPSIGNAL SIGQUIT

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]