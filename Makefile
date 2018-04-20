VERSION=1.10.1
REPO=dictav/golang-tools

build: Dockerfile
	docker build -t $(REPO):$(VERSION) .
	docker tag $(REPO):$(VERSION) $(REPO):latest

push:
	docker push $(REPO):$(VERSION)
	docker push $(REPO):latest

