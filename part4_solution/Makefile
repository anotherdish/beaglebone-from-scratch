TUTORIAL_STAGE = 4
IMAGE_NAME = build

#build the docker image
build:
	docker build -t $(IMAGE_NAME):$(TUTORIAL_STAGE) .

#run the docker image
run: build
	docker run -it --rm $(IMAGE_NAME):$(TUTORIAL_STAGE)

#assemble the code
as:
	arm-none-eabi-as -o main.o main.s

#link it
link: as
	arm-none-eabi-ld -M -T solution.ld -o solution.o main.o

#run the docker image with the current directory mounted
wd: build
	docker run -it --rm -v $(PWD):/work --workdir=/work $(IMAGE_NAME):$(TUTORIAL_STAGE)