#!/bin/bash
# 输入参数1：要找出的进程数n 
# 输出前n个CPU占用最高的进程和内存占用 

# 生成表格的分隔符
SEP="+--------+--------+--------+--------+---------------+-----------+----------------------+--------+--------+---------------------------------------+"
# 计算表格的宽度
WIDTH=122

if [ "$1" == "" ]; then
    echo "Usage: $0 <number of processes>"
    exit 1
fi

# 通过awk命令生成CPU占用前n个进程的表格，包括表头
TOP_CPU=$(ps -eo pid,ppid,%cpu,%mem,rss,vsz,stat,cputime,cmd --sort=-%cpu | awk -v n="$1" '{if (NR<=n+1) print NR-1,$1,$2,$3,$4,$5/1024"MiB",$6/1024"MiB",$7,$8,$9}')
# 根据表格的宽度和分隔符，生成表格的表头
HEADER=$(echo $SEP && printf "|%-8s|%-8s|%-8s|%-8s|%-15s|%-11s|%-21s|%-8s|%-8s|%-39s|\n" "Rank" "PID" "PPID" "CPU(%)" "Memory %" "Memory Size" "Virtual Size" "Status" "CPU Time" "Command" && echo $SEP)

#echo $TOP_CPU

# 打印表格
echo "Top $1 processes by CPU usage:"
printf "%*s\n" $WIDTH | tr " " "-"
echo "$HEADER"
echo "$TOP_CPU" | awk '{printf("|%-8s|%-8s|%-8s|%-8s|%-15s|%-11s|%-21s|%-8s|%-8s|%-39s|\n",$1,$2,$3,$4,$5" %",$6,$7,$8,$9,$10)}'
echo $SEP

# 通过awk命令生成内存占用前n个进程的表格，包括表头
TOP_MEM=$(ps -eo pid,ppid,%cpu,%mem,rss,vsz,stat,cputime,cmd --sort=-%mem | awk -v n="$1" '{if (NR<=n+1) print NR-1,$1,$2,$3,$4,$5/1024"MiB",$6/1024"MiB",$7,$8,$9}')
# 打印表格
echo "Top $1 processes by memory usage:"
printf "%*s\n" $WIDTH | tr " " "-"
echo "$HEADER"
echo "$TOP_MEM" | awk '{printf("|%-8s|%-8s|%-8s|%-8s|%-15s|%-11s|%-21s|%-8s|%-8s|%-39s|\n",$1,$2,$3,$4,$5" %",$6,$7,$8,$9,$10)}'
echo $SEP

