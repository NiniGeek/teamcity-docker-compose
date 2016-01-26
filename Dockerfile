FROM java:8

MAINTAINER Adrien Bettini (ninigeek@gmail.com)

# TEAMCITY INTERNAL ENVIRONMENT VARIABLES
ENV TEAMCITY_DATA_PATH /var/lib/teamcity
ENV TEAMCITY_SERVER_MEM_OPTS -Xmx750m -XX:MaxPermSize=270m
ENV TEAMCITY_SERVER_OPTS -Dteamcity.git.fetch.separate.process=false

# TEMP VAR
ENV TEAMCITY_VERSION 9.1.5
ENV TEAMCITY_FILENAME TeamCity-${IMAGE_TEAMCITY_PACKAGE_VERSION}.tar.gz
ENV TEAMCITY_PATH /opt/${IMAGE_TEAMCITY_PACKAGE_FILENAME}
ENV TEAMCITY_URL http://download.jetbrains.com/teamcity/${IMAGE_TEAMCITY_PACKAGE_FILENAME}

VOLUME ${TEAMCITY_DATA_PATH}
EXPOSE 8242

RUN curl -vL --output ${TEAMCITY_PATH} ${TEAMCITY_URL} && \
    tar xvf ${TEAMCITY_PATH} -C /opt/ && \
    rm -fv ${TEAMCITY_PATH}


# ENABLE CORRECT VALVE BEHIND PROXY
RUN sed -i -e "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/" /opt/TeamCity/conf/server.xml

ENTRYPOINT ["/opt/TeamCity/bin/teamcity-server.sh"]
CMD  ["run"]
