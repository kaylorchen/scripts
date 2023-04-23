#!/usr/bin/env bash
echo_red() {
  # shellcheck disable=SC1110
  # shellcheck disable=SC2016
  echo -e "\033[31m$1\033[0m"
}
echo_green() {
  echo -e "\033[32m$1\033[0m"
}
echo_yellow() {
  echo -e "\033[33m$1\033[0m"
}
echo_blue() {
  echo -e "\033[34m$1\033[0m"
}
echo_purple() {
  echo -e "\033[35m$1\033[0m"
}
echo_sky_blue() {
  echo -e "\033[36m$1\033[0m"
}

print_route_table() {
  echo_purple "+++print_route_table of $1+++"
  ip route list dev $1
  echo_purple "+++print_route_table of $1+++"
}

print_ip() {
  res=$(ip addr show dev $1 | grep inet)
  if [[ -n ${res} ]]; then
    echo_green "+++print_ip of $1+++"
    ip addr show dev $1 | grep "inet" | awk -F ' ' '{print $2}'
    echo_green "+++print_ip of $1+++\n"
    print_route_table $1
  fi

}

dev_list=$(ls /sys/class/net)
for line in $dev_list; do
  echo_sky_blue "\n*************start***************"
  state=$(ip addr show dev $line | grep state | awk -F 'state' '{print $2}' | awk -F ' ' '{print $1}')
  echo_yellow "This device is ${line}, and state is $state"
  print_ip $line
  echo_sky_blue "-------------end-----------------\n"
done
