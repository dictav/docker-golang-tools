FROM golang:1.11.5

# prepare to install git-lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

# install 
RUN apt-get update && apt-get install -y \
  libmecab2 \
  libmecab-dev \
  mecab \
  mecab-utils \
  parallel \
  awscli \
  ca-certificates \
  git-lfs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

# install gcloud command
ENV CLOUD_SDK_URL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-189.0.0-linux-x86_64.tar.gz
ENV PATH $PATH:/google-cloud-sdk/bin
RUN curl -o google-cloud-sdk.tar.gz ${CLOUD_SDK_URL} \
  && tar zxf google-cloud-sdk.tar.gz \
  && mv google-cloud-sdk /google-cloud-sdk \
  && /google-cloud-sdk/install.sh -q \
  && /google-cloud-sdk/bin/gcloud components update -q

# install dep, gosumcheck and go-bindata
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh \
  && go get github.com/haya14busa/gosum/cmd/gosumcheck \
  && go get github.com/TeamMomentum/go-bindata/go-bindata

# gometalinter
RUN sh -c 'curl -L https://git.io/vp6lP | sh'
COPY gometalinter.json /gometalinter.json
