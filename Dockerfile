FROM golang:1.13.3

RUN apt-get update

# prepare to install git-lfs
RUN apt-get install -y \
  && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

# install 
RUN apt-get install -y \
  libmecab2 \
  libmecab-dev \
  mecab \
  mecab-utils \
  parallel \
  awscli \
  ca-certificates \
  git-lfs \
  protobuf-compiler \
  && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

# install gcloud command
ENV CLOUD_SDK_URL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-268.0.0-linux-x86_64.tar.gz
ENV PATH $PATH:/google-cloud-sdk/bin
RUN curl -o google-cloud-sdk.tar.gz ${CLOUD_SDK_URL} \
  && tar zxf google-cloud-sdk.tar.gz \
  && mv google-cloud-sdk /google-cloud-sdk \
  && /google-cloud-sdk/install.sh -q \
  && /google-cloud-sdk/bin/gcloud components update -q

# install dep, gosumcheck, go-bindata and stringer
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh \
  && go get github.com/haya14busa/gosum/cmd/gosumcheck \
  && go get github.com/TeamMomentum/go-bindata/go-bindata \
  && go get golang.org/x/tools/cmd/stringer

# install protobuf for Go
RUN GO111MODULE=on go get github.com/golang/protobuf/protoc-gen-go@v1.3.2

# golangci-lint
RUN sh -c "curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $(go env GOPATH)/bin"
RUN golangci-lint --version
COPY golangci.yml /golangci.yml
