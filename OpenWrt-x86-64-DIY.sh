  
#!/bin/bash

cd openwrt

# 安装额外依赖软件包
# sudo -E apt-get -y install rename

# 更新feeds文件
# sed -i 's@#src-git helloworld@src-git helloworld@g' feeds.conf.default #启用helloworld
cat feeds.conf.default

# 更新并安装源
./scripts/feeds clean
./scripts/feeds update -a && ./scripts/feeds install -a

# 添加第三方软件包
git clone https://github.com/kenzok8/openwrt-packages.git

# 再次更新并安装源
./scripts/feeds clean
./scripts/feeds update -a && ./scripts/feeds install -a

# 替换更新haproxy默认版本
# rm -rf feeds/packages/net/haproxy && svn co https://github.com/db-one/openwrt-app-package/trunk/haproxy feeds/packages/net/haproxy
# rm -rf package/lean/luci-app-haproxy-tcp && svn co https://github.com/db-one/openwrt-app-package/trunk/luci-app-haproxy-tcp package/lean/luci-app-haproxy-tcp

# 自定义定制选项
sed -i 's#192.168.1.1#192.168.2.101#g' package/base-files/files/bin/config_generate #定制默认IP
sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings #取消系统默认密码
# sed -i 's/procd_set_param command $PROG -C $CONFIGFILE -k -x \/var\/run\/dnsmasq\/dnsmasq.\"${cfg}\".pid/procd_set_param command $PROG -C $CONFIGFILE -k --dhcp-sequential-ip -x \/var\/run\/dnsmasq\/dnsmasq.\"${cfg}\".pid/g' package/network/services/dnsmasq/files/dnsmasq.init #DHCP顺序分配IP

#创建自定义配置文件 - OpenWrt-x86-64

rm -f ./.config*
touch ./.config

#
# ========================固件定制部分========================
# 

# 
# 如果不对本区块做出任何编辑, 则生成默认配置固件. 
# 

# 以下为定制化固件选项和说明:
#

#
# 有些插件/选项是默认开启的, 如果想要关闭, 请参照以下示例进行编写:
# 
#          =========================================
#         |  # 取消编译VMware镜像:                   |
#         |  cat >> .config <<EOF                   |
#         |  # CONFIG_VMDK_IMAGES is not set        |
#         |  EOF                                    |
#          =========================================
#

# 
# 以下是一些提前准备好的一些插件选项.
# 直接取消注释相应代码块即可应用. 不要取消注释代码块上的汉字说明.
# 如果不需要代码块里的某一项配置, 只需要删除相应行.
#
# 如果需要其他插件, 请按照示例自行添加.
# 注意, 只需添加依赖链顶端的包. 如果你需要插件 A, 同时 A 依赖 B, 即只需要添加 A.
# 
# 无论你想要对固件进行怎样的定制, 都需要且只需要修改 EOF 回环内的内容.
# 

# 编译x64固件:
cat >> .config <<EOF
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_x86_64_Generic=y
EOF

# 设置固件大小:
cat >> .config <<EOF
CONFIG_TARGET_KERNEL_PARTSIZE=16
CONFIG_TARGET_ROOTFS_PARTSIZE=160
EOF

# 固件压缩:
cat >> .config <<EOF
CONFIG_TARGET_IMAGES_GZIP=y
EOF

# 编译UEFI固件:
cat >> .config <<EOF
CONFIG_EFI_IMAGES=y
EOF

# IPv6支持:
# cat >> .config <<EOF
# CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y
# CONFIG_PACKAGE_ipv6helper=y
# EOF

# 多文件系统支持:
# cat >> .config <<EOF
# CONFIG_PACKAGE_kmod-fs-nfs=y
# CONFIG_PACKAGE_kmod-fs-nfs-common=y
# CONFIG_PACKAGE_kmod-fs-nfs-v3=y
# CONFIG_PACKAGE_kmod-fs-nfs-v4=y
# CONFIG_PACKAGE_kmod-fs-ntfs=y
# CONFIG_PACKAGE_kmod-fs-squashfs=y
# EOF

# USB3.0支持:
# cat >> .config <<EOF
# CONFIG_PACKAGE_kmod-usb-ohci=y
# CONFIG_PACKAGE_kmod-usb-ohci-pci=y
# CONFIG_PACKAGE_kmod-usb2=y
# CONFIG_PACKAGE_kmod-usb2-pci=y
# CONFIG_PACKAGE_kmod-usb3=y
# EOF

# 第三方插件选择:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-openclash=y #OpenClash
# CONFIG_PACKAGE_luci-app-oaf is not set #应用过滤
# CONFIG_PACKAGE_luci-app-serverchan is not set #微信推送
# CONFIG_PACKAGE_luci-app-eqos is not set #IP限速
# CONFIG_PACKAGE_luci-app-adguardhome is not set #ADguardhome
EOF

# ShadowsocksR插件:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Socks=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_V2ray=y
EOF

# Passwall插件:
# cat >> .config <<EOF
# CONFIG_PACKAGE_luci-app-passwall is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ipt2socks is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ChinaDNS_NG is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2rayis not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_v2ray-plugin is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_simple-obfs is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Brook is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_kcptun is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_haproxy is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_dns2socks is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_pdnsd is not set
# CONFIG_PACKAGE_kcptun-client is not set
# CONFIG_PACKAGE_chinadns-ng is not set
# CONFIG_PACKAGE_haproxy is not set
# CONFIG_PACKAGE_v2ray is not set
# CONFIG_PACKAGE_v2ray-plugin is not set
# CONFIG_PACKAGE_simple-obfs is not set
# CONFIG_PACKAGE_trojan is not set
# CONFIG_PACKAGE_brook is not set
# CONFIG_PACKAGE_ipt2socks is not set
# CONFIG_PACKAGE_shadowsocks-libev-config is not set
# CONFIG_PACKAGE_shadowsocks-libev-ss-local is not set
# CONFIG_PACKAGE_shadowsocks-libev-ss-redir is not set
# CONFIG_PACKAGE_shadowsocksr-libev-alt is not set
# CONFIG_PACKAGE_shadowsocksr-libev-ssr-local is not set
# CONFIG_PACKAGE_pdnsd-alt is not set
# CONFIG_PACKAGE_dns2socks is not set
# EOF

# 常用LuCI插件:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-adbyby-plus=y #adbyby去广告
CONFIG_PACKAGE_luci-app-autoreboot=y #定时重启
CONFIG_PACKAGE_luci-app-upnp=y #通用即插即用UPnP(端口自动转发)
CONFIG_PACKAGE_luci-app-ddns=y #DDNS服务
CONFIG_PACKAGE_luci-app-arpbind=y #ARP绑定
CONFIG_PACKAGE_luci-app-ramfree=y #清理内存
CONFIG_PACKAGE_luci-app-firewall=y #添加防火墙
CONFIG_PACKAGE_luci-app-smartdns=y #smartdnsDNS服务
# CONFIG_PACKAGE_luci-app-webadmin is not set #Web管理页面设置
# CONFIG_PACKAGE_luci-app-vlmcsd is not set #KMS激活服务器
# CONFIG_PACKAGE_luci-app-filetransfer is not set #系统-文件传输
# CONFIG_PACKAGE_luci-app-accesscontrol is not set #上网时间控制
# CONFIG_PACKAGE_luci-app-wol is not set #网络唤醒
# CONFIG_PACKAGE_luci-app-sqm is not set #SQM智能队列管理
# CONFIG_PACKAGE_luci-app-flowoffload is not set #Turbo ACC 网络加速
# CONFIG_PACKAGE_luci-app-softethervpn is not set #SoftEtherVPN服务器
# CONFIG_PACKAGE_luci-app-frpc is not set #Frp内网穿透
# CONFIG_PACKAGE_luci-app-nlbwmon is not set #宽带流量监控
# CONFIG_PACKAGE_luci-app-zerotier is not set #zerotier内网穿透
# CONFIG_PACKAGE_luci-app-haproxy-tcp is not set #Haproxy负载均衡
# CONFIG_PACKAGE_luci-app-diskman is not set #磁盘管理磁盘信息
# CONFIG_PACKAGE_luci-app-transmission is not set #TR离线下载
# CONFIG_PACKAGE_luci-app-qbittorrent is not set #QB离线下载
# CONFIG_PACKAGE_luci-app-amule is not set #电驴离线下载
# CONFIG_PACKAGE_luci-app-xlnetacc is not set #迅雷快鸟
# CONFIG_PACKAGE_luci-app-hd-idle is not set #磁盘休眠
# CONFIG_PACKAGE_luci-app-wrtbwmon is not set #实时流量监测
# CONFIG_PACKAGE_luci-app-unblockmusic is not set #解锁网易云灰色歌曲
# CONFIG_PACKAGE_luci-app-airplay2 is not set #Apple AirPlay2音频接收服务器
# CONFIG_PACKAGE_luci-app-music-remote-center is not set #PCHiFi数字转盘遥控
# CONFIG_PACKAGE_luci-app-usb-printer is not set #USB打印机
#
# VPN相关插件(禁用):
#
# CONFIG_PACKAGE_luci-app-v2ray-server is not set #V2ray服务器
# CONFIG_PACKAGE_luci-app-pptp-server is not set #PPTP VPN 服务器
# CONFIG_PACKAGE_luci-app-ipsec-vpnd is not set #ipsec VPN服务
# CONFIG_PACKAGE_luci-app-openvpn-server is not set #openvpn服务
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Kcptun is not set #Kcptun客户端
#
# 文件共享相关(禁用):
#
# CONFIG_PACKAGE_luci-app-minidlna is not set #miniDLNA服务
# CONFIG_PACKAGE_luci-app-vsftpd is not set #FTP 服务器
# CONFIG_PACKAGE_luci-app-samba is not set #网络共享
# CONFIG_PACKAGE_autosamba is not set #网络共享
# CONFIG_PACKAGE_samba36-server is not set #网络共享
EOF

# LuCI主题:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-theme-argon=y
# CONFIG_PACKAGE_luci-theme-atmaterial is not set
# CONFIG_PACKAGE_luci-theme-argon_new is not set
# CONFIG_PACKAGE_luci-theme-netgear is not set
EOF

# 常用软件包:
cat >> .config <<EOF
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_htop=y
CONFIG_PACKAGE_nano=y
CONFIG_PACKAGE_wget=y
# CONFIG_PACKAGE_screen=y
# CONFIG_PACKAGE_tree=y
# CONFIG_PACKAGE_vim-fuller=y
EOF

# 其他软件包:
# cat >> .config <<EOF
# CONFIG_HAS_FPU=y
# EOF

# 取消编译VMware镜像以及镜像填充 (不要删除被缩进的注释符号):
cat >> .config <<EOF
# CONFIG_TARGET_IMAGES_PAD is not set
# CONFIG_VMDK_IMAGES is not set
EOF

# 
# ========================固件定制部分结束========================
# 


sed -i 's/^[ \t]*//g' ./.config

# 配置文件创建完成
