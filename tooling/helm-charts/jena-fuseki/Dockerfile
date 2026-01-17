FROM 123456789011.dkr.ecr.us-west-1.amazonaws.com/mirrors/ubuntu:22.04

ENV LANG=C.UTF-8 \
    FUSEKI_VERSION=5.5.0 \
    FUSEKI_SHA512=bfbf59eac731b71bcf8e148f2abeda9b4adca215639eef3bba61243b308572b23a9a70a43c1483247f9894bfb23d69b59e0e64e1da47cb3cfc592aa979084d5c \
    FUSEKI_BASE=/fuseki \
    FUSEKI_HOME=/jena-fuseki \
    JVM_ARGS="-Xms256m -Xmx2048m -Dorg.eclipse.jetty.server.Request.maxFormKeys=100000 -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+HeapDumpOnOutOfMemoryError"

RUN apt-get update -qq && apt-get install -y -qq \
    openjdk-21-jre-headless curl ca-certificates tini \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN echo "$FUSEKI_SHA512  fuseki.tar.gz" > fuseki.tar.gz.sha512 && \
    curl --location --silent --show-error --fail --retry 3 --output fuseki.tar.gz https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz && \
    sha512sum -c fuseki.tar.gz.sha512 && \
    tar zxf fuseki.tar.gz && \
    mv apache-jena-fuseki* $FUSEKI_HOME && \
    rm fuseki.tar.gz*

WORKDIR $FUSEKI_HOME
VOLUME $FUSEKI_BASE

# Copy default shiro.ini for dev/build
COPY shiro.ini $FUSEKI_HOME/shiro.ini

EXPOSE 3030

ENTRYPOINT ["/usr/bin/tini", "--", "/jena-fuseki/fuseki-server"]
