TUTORIAL_STAGE = 2
IMAGE_NAME = build

#build the docker image
build:
	docker build -t $(IMAGE_NAME):$(TUTORIAL_STAGE) .

#run the docker image
run:
	docker run -it --rm $(IMAGE_NAME):$(TUTORIAL_STAGE)

#this is to be run in the container
solve:
	