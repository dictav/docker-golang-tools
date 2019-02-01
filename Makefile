LAST=1.11.5
DEP=v0.5.0
META=v3.0.0
VERSION=$(LAST)-dep.$(DEP)-gometalinter.$(META)
REPO=dictav/golang-tools

build: Dockerfile
	docker build -t $(REPO):$(VERSION) .
	docker tag $(REPO):$(VERSION) $(REPO):$(LAST)

push:
	docker push $(REPO):$(VERSION)
	docker push $(REPO):$(LAST)

