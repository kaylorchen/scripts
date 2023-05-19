#!/bin/bash

# 获取网络设备列表
devices=$(ip -o link show | awk -F': ' '{print $2}')

# 输出表头
printf "%-15s %-20s\n" "设备" "IP地址"
printf "===============================\n"

# 遍历每个设备
for device in $devices; do
    # 获取设备IP地址列表
    ip_addresses=$(ip addr show dev "$device" | awk '/inet /{print $2}')

    # 输出设备名称和IP地址
    for ip_address in $ip_addresses; do
        printf "%-15s %-20s\n" "$device" "$ip_address"
    done

    # 输出设备间的间隔线
    printf "%s\n" "-------------------------------"
done

