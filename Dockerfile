from ubuntu:20.04

run apt update && DEBIAN_FRONTEND=noninteractive apt install -y autoconf automake bison bzip2 cmake flex g++ gawk gcc \
        gettext git gperf help2man libncurses5-dev libstdc++6 libtool libtool-bin make \
        patch python3-dev rsync texinfo unzip wget xz-utils
RUN mkdir /work
workdir /work

RUN git clone https://github.com/crosstool-ng/crosstool-ng.git

RUN cd crosstool-ng && git checkout crosstool-ng-1.25.0 && ./bootstrap && ./configure && make && make install

#the config provided here in toolchain/.config is default options with CT_PREFIX_DIR_RO set to n
COPY toolchain /work/

ENV CT_EXPERIMENTAL=y
ENV CT_ALLOW_BUILD_AS_ROOT=y
ENV CT_ALLOW_BUILD_AS_ROOT_SURE=y

RUN ct-ng build

# time for uboot
RUN git clone https://source.denx.de/u-boot/u-boot.git && cd u-boot && git checkout v2022.10

RUN apt install libssl-dev bc -y

# in this, the cross compile option is basically specifying which value in the path is going to be used as a prefix for the compiler and other shit
RUN cd u-boot && PATH=/root/x-tools/arm-unknown-linux-gnueabi/bin:${PATH} CROSS_COMPILE=arm-unknown-linux-gnueabi- ARCH=arm make qemu_arm_defconfig && \
        PATH=/root/x-tools/arm-unknown-linux-gnueabi/bin:${PATH} CROSS_COMPILE=arm-unknown-linux-gnueabi- ARCH=arm make