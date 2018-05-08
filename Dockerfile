FROM debian:stretch-slim

RUN groupadd -r digibyte && useradd -r -m -g digibyte digibyte

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV DIGIBYTE_VERSION 0.16.2
ENV DIGIBYTE_URL https://github.com/digibyte/digibyte/releases/download/v6.16.2/digibyte-6.16.2-x86_64-linux-gnu.tar.gz
ENV DIGIBYTE_SHA256 6ff9c92989c5fcd19da01bb748fcab0d7c059efae03e01eb8f7c18a927746704

# install digibyte binaries
RUN set -ex \
	&& cd /tmp \
	&& wget -qO digibyte.tar.gz "$DIGIBYTE_URL" \
	&& echo "$DIGIBYTE_SHA256 digibyte.tar.gz" | sha256sum -c - \
	&& tar -xzvf digibyte.tar.gz -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm -rf /tmp/*

# create data directory
#ENV DIGIBYTE_DATA /data
#RUN mkdir "$DIGIBYTE_DATA" \
#	&& chown -R digibyte:digibyte "$DIGIBYTE_DATA" \
#	&& ln -sfn "$DIGIBYTE_DATA" /home/digibyte/.digibyte \
#	&& chown -h digibyte:digibyte /home/digibyte/.digibyte
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8332 8333 18332 18333
CMD ["digibyted"]
