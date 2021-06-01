FROM lsiobase/rdesktop-web:alpine

# set version label
ARG BUILD_DATE
ARG VERSION
ARG FIREFOX_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	curl && \
 if [ -z ${FIREFOX_VERSION+x} ]; then \
	FIREFOX_VERSION=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.13/community/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp \
	&& awk '/^P:firefox-esr$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
 fi && \
 apk add --no-cache \
	firefox-esr==${FIREFOX_VERSION} && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*
RUN apk add konqueror
RUN apk add chromium
RUN apk add midori

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config
