FROM golang:1.11 as gcr-build

RUN go get -u github.com/GoogleCloudPlatform/docker-credential-gcr

# Start from debian:buster-backports base.
FROM debian:buster-backports

# Prepare the image.
ENV DEBIAN_FRONTEND noninteractive

COPY --from=gcr-build /go/bin/docker-credential-gcr /usr/bin/

# Google Cloud SDK pre requisites.
RUN apt-get update && apt-get install -y -qq --no-install-recommends apt-transport-https \
    ca-certificates gnupg curl

# Install the Google Cloud SDK.
ENV HOME /
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] \
    https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get update && apt-get -y -qq install google-cloud-sdk && apt-get clean

# Various networking and other tools. net-tools installs arp, netstat, etc.
RUN apt-get install -u -qq vim \
    net-tools netcat ipset conntrack inetutils-traceroute bridge-utils \
    ebtables \
    && apt-get clean

# These packages are required or extracting source tarballs and building the kernel.
RUN apt-get update && \
    apt-get install -u -qq \
        xz-utils make gcc python-minimal bc libelf-dev libssl-dev \
        crash bison flex dwarves libdw1 && \
    apt-get clean
COPY cos-kernel /usr/local/bin

VOLUME ["/.config"]

CMD ["/bin/bash"]
