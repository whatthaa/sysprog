FROM jenkins/jenkins:lts
USER root

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    rpm \
    dpkg-dev \
    build-essential \
    devscripts \
    debhelper \
    alien

RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh

RUN usermod -aG docker jenkins

COPY countscript/count_files.sh /usr/local/bin/count_files.sh
RUN chmod +x /usr/local/bin/count_files.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER jenkins

RUN jenkins-plugin-cli --plugins \
    workflow-aggregator \
    git \
    docker-workflow

CMD ["jenkins-slave"]
