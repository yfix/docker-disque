FROM yfix/baseimage

MAINTAINER Yuri Vysotskiy (yfix) <yfix.dev@gmail.com>

RUN buildDeps='gcc libc6-dev make git ca-certificates'; \
    set -x \
    && apt-get update \
    && apt-get install -y $buildDeps --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone https://github.com/antirez/disque.git \
    && cd disque \
    && git checkout tags/1.0-rc1 \
    && make -C /usr/src/disque \
    && make -C /usr/src/disque install \
    && rm -rf /usr/src/disque \
    && apt-get purge -y --auto-remove $buildDeps \
  \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /usr/{lib,lib/share,share}/{man,doc,info,gnome/help,cracklib} \
  && rm -rf /tmp/* \
  \
  && echo "====The end===="

COPY docker /

CMD [ "disque-server", "/etc/disque/disque.conf" ]

EXPOSE 7711 17711
