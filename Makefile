LAST=1.10.3
VERSION=1.10.3-dep.v5
REPO=dictav/golang-tools

build: Dockerfile
	docker build -t $(REPO):$(VERSION) .
	docker tag $(REPO):$(VERSION) $(REPO):$(LAST)

push:
	docker push $(REPO):$(VERSION)
	docker push $(REPO):$(LAST)

