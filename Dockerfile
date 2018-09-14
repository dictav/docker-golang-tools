FROM circleci/golang:1.11

COPY gometalinter.json /gometalinter.json

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

RUN sudo apt-get update && sudo apt-get install -y \
  libmecab2 \
  libmecab-dev \
  mecab \
  mecab-utils \
  parallel \
  awscli \
  ca-certificates \
  git-lfs \
  && sudo apt-get clean \
  && sudo rm -rf /var/lib/apt/lists/*

RUN sudo update-ca-certificates

ENV CLOUD_SDK_URL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-189.0.0-linux-x86_64.tar.gz
ENV PATH $PATH:/google-cloud-sdk/bin

RUN curl -o google-cloud-sdk.tar.gz ${CLOUD_SDK_URL} \
  && tar zxf google-cloud-sdk.tar.gz \
  && sudo mv google-cloud-sdk /google-cloud-sdk \
  && sudo /google-cloud-sdk/install.sh -q \
  && sudo /google-cloud-sdk/bin/gcloud components update -q

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh \
  && go get github.com/haya14busa/gosum/cmd/gosumcheck \
  && go get github.com/TeamMomentum/go-bindata/go-bindata

RUN sudo sh -c 'curl -L https://git.io/vp6lP | sh'
