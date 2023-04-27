FROM ubuntu:22.04

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
        gcc-arm-none-eabi                                                      `# jwe want to be able to compile for not linux, which is where the "none" part comes in` \
        build-essential cmake bison flex                                       `# bringing in the build systems` \
        qemu-system-arm                                                        `# qemu arm is cool` \
        bsdmainutils                                                         `# we need this for hexdump` \
        python3-pip telnet

RUN python3 -m pip install 'xonsh[full]'

WORKDIR /root

# copy the startup file into the container
ADD main.s /root/

# assembly the startup file
RUN arm-none-eabi-as -o main.o main.s

# link the object file into an elf file
#RUN arm-none-eabi-ld -T solution.ld -o startup.elf startup.o main.o