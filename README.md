# Docker wrapper for build for my router that does not have enough ram to run ipv6


## Download the imagebuilder file from openwrt - see Dockerfile

## Build and extract the upgrade file needed

docker build . -t owrt
docker run --rm owrt:latest cat /outputs.tgz > outputs.tgz
tar xzvf outputs.tgz bin/targets/ar71xx/tiny/openwrt-19.07.8-ar71xx-tiny-tl-wa901nd-v3-squashfs-sysupgrade.bin

## Don't foget the config

In the installed image I found it useful to disable ipv6 router advertising (I think that was the issue I had).
Put the following in Startup -> Local Startup before the "exit 0"

    sysctl -w net.ipv6.conf.all.disable_ipv6=1
    echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
    sysctl -w net.ipv6.conf.default.disable_ipv6=1
