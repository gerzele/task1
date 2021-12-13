FROM debian:latest
VOLUME /debexport
#RUN apt-get update && apt-get upgrade --yes && \
#	apt-get install --yes checkinstall && \
#	apt-get clean

COPY ./sources/PatchManagerPlus.tgz /tmp/build/
WORKDIR /tmp/build
RUN tar -xf PatchManagerPlus.tgz
#RUN tar -xf PatchManagerPlus.tgz --wildcards "*.bin" "*json"

COPY /debmaker.sh /tmp/build/
WORKDIR /tmp/build
RUN chmod +x debmaker.sh

CMD ./debmaker.sh
