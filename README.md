# ruby-Ip2region

## 介绍

这是一个ruby 版本的 ip2region,  基于 [lionsoul2014/ip2region](https://github.com/lionsoul2014/ip2region) v2.0 版本开发

此版本是完全仿照 python, 通过 copilot 进行的编写

为了方便直接搞成 gem 包, 故单独开了个项目

## 安装
`gem install ip2region`
## 使用

**需要外挂 xdb 文件**


```ruby
require 'ip2region'

# 使用前必须设置 xdb 文件路径
Ip2region.ip_2_region_path="./ip2region.xdb"

# 查询
Ip2region.search("114.114.114.114")
# => "中国|0|江苏省|南京市|0"

Ip2region.search "127.0.0.1"
 => "0|0|0|内网IP|内网IP"

Ip2region.search("192.168.1.1")
 => "0|0|0|内网IP|内网IP"


Ip2region.search("114.114.114.333")
# IPAddr::InvalidAddressError: invalid address


# 不支持 ipv6
Ip2region.search("24ff:8262:c7f:4dea:81e0:2dff:6f9d:f300")
 => nil

```

## 如何下载外挂 xdb 文件

下载这个文件 [https://github.com/lionsoul2014/ip2region/blob/master/data/ip2region.xdb](https://github.com/lionsoul2014/ip2region/blob/master/data/ip2region.xdb)


## 协议

MIT 协议