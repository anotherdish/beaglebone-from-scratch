from ubuntu:20.04

run apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
        autoconf automake bison bzip2 cmake flex g++ gawk gcc                             `# for crosstool-ng` \ 
        gettext git gperf help2man libncurses5-dev libstdc++6 libtool libtool-bin make \
        patch python3-dev rsync texinfo unzip wget xz-utils \
        libssl-dev bc                                                                     `# for uboot` 

RUN mkdir /work
workdir /work

RUN git clone https://github.com/crosstool-ng/crosstool-ng.git

RUN cd crosstool-ng && git checkout crosstool-ng-1.25.0 && ./bootstrap && ./configure && make && make install

#the config provided here in toolchain/.config is default options with CT_PREFIX_DIR_RO set to n
COPY toolchain /work/

# build the ng arm unknown toolchain
RUN mv /work/ct-ng-arm-unknown-linux-gnueabi.config /work/.config
RUN CT_ALLOW_BUILD_AS_ROOT_SURE=y CT_ALLOW_BUILD_AS_ROOT=y CT_EXPERIMENTAL=y ct-ng build

# build the other two
RUN mv /work/ct-ng-arm-cortex_a8-linux-gnueabi-hw-float.config /work/.config
RUN CT_ALLOW_BUILD_AS_ROOT_SURE=y CT_ALLOW_BUILD_AS_ROOT=y CT_EXPERIMENTAL=y ct-ng build

RUN mv /work/ct-ng-arm-cortex_a8-linux-gnueabi.config /work/.config
RUN CT_ALLOW_BUILD_AS_ROOT_SURE=y CT_ALLOW_BUILD_AS_ROOT=y CT_EXPERIMENTAL=y ct-ng build


# time for uboot
RUN git clone https://source.denx.de/u-boot/u-boot.git && cd u-boot && git checkout v2022.10

WORKDIR /work/u-boot
# in this, the cross compile option is basically specifying which value in the path is going to be used as a prefix for the compiler and other shit
RUN PATH=/root/x-tools/arm-unknown-linux-gnueabi/bin:${PATH} CROSS_COMPILE=arm-unknown-linux-gnueabi- ARCH=arm make qemu_arm_defconfig && \
        PATH=/root/x-tools/arm-unknown-linux-gnueabi/bin:${PATH} CROSS_COMPILE=arm-unknown-linux-gnueabi- ARCH=arm make

RUN mkdir -p /root/uboot/arm-unkown-linux-gnueabi && cp /work/u-boot/u-boot* /root/uboot/arm-unkown-linux-gnueabi

# now do the same thing for arm-cortex_a8-linux-gnueabi and arm-cortex_a8-linux-gnueabihf
RUN PATH=/root/x-tools/arm-cortex_a8-linux-gnueabi/bin:${PATH} CROSS_COMPILE=arm-cortex_a8-linux-gnueabi- ARCH=arm make qemu_arm_defconfig && \
        PATH=/root/x-tools/arm-cortex_a8-linux-gnueabi/bin:${PATH} CROSS_COMPILE=arm-cortex_a8-linux-gnueabi- ARCH=arm make

RUN mkdir -p /root/uboot/arm-cortex_a8-linux-gnueabi && cp /work/u-boot/u-boot* /root/uboot/arm-cortex_a8-linux-gnueabi

RUN apt install qemu-utils parted udev -y

# create the disk image that we are going to be booting from
WORKDIR /work
RUN qemu-img create -f raw disk.img 16G
# create the partition table
RUN parted disk.img mklabel msdos 
# make the boot partition
RUN parted disk.img mkpart primary fat32 0 1GB
# make the root partition
RUN parted disk.img mkpart primary ext4 1GB 16GB