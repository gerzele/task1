FROM debian:latest
VOLUME /debexport
RUN apt-get update && apt-get upgrade --yes && \
	apt-get install --yes checkinstall && \
	apt-get clean

#COPY ./sources/PatchManagerPlus.tgz /tmp/build/
COPY sources/*.tgz /tmp/build/
COPY debscripts/* /tmp/build/
WORKDIR /tmp/build
RUN tar -xf *.tgz && \
	rm *.tgz && \
	chmod 755 debmaker.sh && \
	chmod 755 postinst && \
	chmod 755 postrm && \ 
	chmod 755 preinst && \
	chmod 755 prerm
CMD ./debmaker.sh
