FROM ubuntu:latest AS builder

RUN set -x \
  && apt-get update \
  && apt-get upgrade -y

RUN set -x \
  && apt-get install -y build-essential libncurses5-dev libncursesw5-dev zlib1g-dev gawk git gettext libssl-dev xsltproc wget unzip python

RUN set -x \
  && apt-get install -y python3

ARG IMAGE_BUILDER_BASE_FIMENAME=openwrt-imagebuilder-19.07.8-ar71xx-tiny.Linux-x86_64
ARG IMAGE_BUILDER_TAR_FIMENAME=$IMAGE_BUILDER_BASE_FIMENAME.tar.xz

# obtained from https://downloads.openwrt.org/releases/19.07.3/targets/ar71xx/tiny/

COPY "$IMAGE_BUILDER_TAR_FIMENAME" .

RUN set -x \
  && tar xvf "$IMAGE_BUILDER_TAR_FIMENAME"

WORKDIR "$IMAGE_BUILDER_BASE_FIMENAME"

RUN set -x \
  && make image PROFILE="tl-wa901nd-v3" \
    PACKAGES="uhttpd uhttpd-mod-ubus libiwinfo-lua luci-base luci-app-firewall luci-mod-admin-full luci-theme-bootstrap \
      -ppp -ppp-mod-pppoe -ip6tables -odhcp6c -kmod-ipv6 -kmod-ip6tables -odhcpd-ipv6only"

RUN set -x \
  && tar czvf /outputs.tgz bin/

#FROM scratch
#COPY --from=builder /outputs.tgz /
