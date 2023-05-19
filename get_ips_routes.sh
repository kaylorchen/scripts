#!/bin/bash

# 获取网络设备列表
devices=$(ip -o link show | awk -F': ' '{print $2}')

# 输出表头
printf "%-15s %-15s %-20s %-50s\n" "设备" "状态" "IP地址" "路由表"
printf "=================================================================\n"

# 遍历每个设备
for device in $devices; do
    # 输出设备名称
    printf "%-15s\n" "$device"

    # 获取设备状态
    status=$(ip -o link show dev "$device" | awk '{print $9}')

    # 获取设备IP地址列表（仅IPv4）
    ip_addresses=$(ip -4 addr show dev "$device" | awk '/inet /{print $2}')

    # 遍历每个IP地址
    for ip_address in $ip_addresses; do
        # 输出接口状态、IP地址
        printf "%-15s %-15s %-20s" "" "$status" "$ip_address"

        # 获取与当前接口相关的路由表
        routing_table=$(ip -4 route show table all dev "$device" to "$ip_address" | awk '{print $0}')

        # 输出路由表
        printf "%-50s\n" "$routing_table"
    done

    # 输出设备的其他路由表（仅IPv4）
    other_routing_table=$(ip -4 route show table all | awk -v device="$device" -v ip_addresses="$ip_addresses" \
        '($0 ~ device && !($0 ~ ip_addresses) && !/to /){printf "%-15s %-15s %-20s %-50s\n", "", "", "", $0}')

    # 输出其他路由表
    printf "%s\n" "$other_routing_table"

    # 输出设备的默认网关路由表（仅IPv4）
    default_gateway_routing_table=$(ip -4 route show table all dev "$device" default | awk '{print $0}')

    # 输出默认网关路由表
    printf "%-15s %-15s %-20s %-50s\n" "" "" "" "$default_gateway_routing_table"

    # 输出设备间的间隔线
    printf "%s\n" "================================================================="
done

