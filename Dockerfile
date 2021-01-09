FROM golang:1.15.6

ENV CLOUD_SDK_VERSION 322.0.0
ENV PROTOC_GEN_GO_VERSION 1.4.3
ENV GOLANGCI_LINT_VERSION 1.35.0

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
ENV CLOUD_SDK_URL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz
ENV PATH $PATH:/google-cloud-sdk/bin
RUN curl -o google-cloud-sdk.tar.gz ${CLOUD_SDK_URL} \
  && tar zxf google-cloud-sdk.tar.gz \
  && mv google-cloud-sdk /google-cloud-sdk \
  && /google-cloud-sdk/install.sh -q \
  && /google-cloud-sdk/bin/gcloud components update -q

# install gosumcheck, go-bindata and stringer
RUN go get github.com/haya14busa/gosum/cmd/gosumcheck \
  && go get github.com/TeamMomentum/go-bindata/go-bindata \
	&& go get github.com/rakyll/statik \
  && go get golang.org/x/tools/cmd/stringer

# install protobuf for Go
RUN GO111MODULE=on go get github.com/golang/protobuf/protoc-gen-go@v${PROTOC_GEN_GO_VERSION}

# golangci-lint
RUN curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh| sh -s -- -b $(go env GOPATH)/bin v${GOLANGCI_LINT_VERSION}
RUN golangci-lint --version
COPY golangci.yml /golangci.yml
