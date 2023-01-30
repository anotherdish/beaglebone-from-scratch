TUTORIAL_STAGE = 1
IMAGE_NAME = build

#build the docker image
build:
	docker build -t $(IMAGE_NAME):$(TUTORIAL_STAGE) .

#run the docker image
run:
	docker run -it --rm $(IMAGE_NAME):$(TUTORIAL_STAGE)