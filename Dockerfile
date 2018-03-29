FROM circleci/golang:1.10

COPY gometalinter.json /gometalinter.json

RUN sudo apt-get update && sudo apt-get install -y \
  libmecab2 \
  libmecab-dev \
  mecab \
  mecab-utils \
  parallel \
  awscli \
  ca-certificates \
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

RUN go get github.com/golang/dep/cmd/... \
  && go get github.com/alecthomas/gometalinter \
  && go get github.com/haya14busa/gosum/cmd/gosumcheck
