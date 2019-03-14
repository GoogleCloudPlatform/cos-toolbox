# Start from debian:stretch-backports base.
FROM debian:stretch-backports

# Prepare the image.
ENV DEBIAN_FRONTEND noninteractive

# These instructions are derieved from the google/cloud-sdk docker image
# (https://github.com/GoogleCloudPlatform/cloud-sdk-docker/blob/master/Dockerfile)
# To keep the image size small, we install only the most
# needed components of gcloud & their dependencies.
RUN apt-get update && apt-get install -y -qq --no-install-recommends wget curl unzip python openssh-client python-openssl ca-certificates && apt-get clean

# Install the Google Cloud SDK.
ENV HOME /
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && unzip google-cloud-sdk.zip && rm google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components alpha beta docker-credential-gcr

# Various networking and other tools. net-tools installs arp, netstat, etc.
RUN apt-get install -u -qq vim \
    net-tools netcat ipset conntrack inetutils-traceroute bridge-utils \
    ebtables \
    && apt-get clean

COPY cos-kernel /usr/local/bin

RUN mkdir /.ssh && echo "PATH=\$PATH:/google-cloud-sdk/bin" > /etc/profile.d/gcloud_path.sh
ENV PATH /google-cloud-sdk/bin:$PATH
VOLUME ["/.config"]

CMD ["/bin/bash"]
