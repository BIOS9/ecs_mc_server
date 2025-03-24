FROM ubuntu:24.04 AS installer
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get install -y \
  openjdk-21-jre \
  wget

WORKDIR /installer
RUN wget -O neoforge_installer.jar https://maven.neoforged.net/releases/net/neoforged/neoforge/21.4.123/neoforge-21.4.123-installer.jar
RUN java -jar neoforge_installer.jar --install-server server

FROM ubuntu:24.04
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get install -y \
  openjdk-21-jre \
  && rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash apprunner
USER apprunner

COPY --from=installer /installer/server /server
WORKDIR /server

# Configure server
COPY eula.txt .

CMD ["/bin/bash", "./run.sh"]