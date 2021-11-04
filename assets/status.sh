#!/bin/bash
PWD=$(pwd)
op_sys=$(uname -o)
kern=$(uname -r)
arch_sys=$(uname -m)
krname=$(uname)
dev_brand(){
printf "`getprop ro.product.manufacturer` %s"
printf "`getprop ro.product.model` %s"
}
Battery=$(termux-battery-status | jq -r .percentage)
package() {
apt list --installed 2>/dev/null | wc -l
}

eq() {
  case $1 in
  $2) ;;
  *) return 1 ;;
  esac
}

while read -r line; do
eq "$line" 'MemTotal*' && set -- $line && break
done </proc/meminfo

r1="$(($2/1000))"
ovrm=$(bc <<< "scale=2; $r1 / 1000")
r2=$(free -m | sed -n 's/^Mem:\s\+[0-9]\+\s\+\([0-9]\+\)\s.\+/\1/p')
memory=$(bc <<< "scale=2; $r2 /1000")
echo -e "${R0}"
strused=$(df -h /sdcard | grep "/" | awk '{print $3}')
stravai=$(df -h /sdcard | grep "/" | awk '{print $2}')

#<<======program========>>>
cat <<- EQF > ${PWD}/fetch
Device  : $(dev_brand)
OS      : ${op_sys}
Packages: $(package)
Shell   : $(basename $SHELL)
UpTime  : $(uptime -p | sed 's/up//')
Ram     : ${memory}GB / ${ovrm}GB
Arch    : ${arch_sys}
Kernel  : ${kern}
Storage : ${strused}B used from ${stravai}B
Battery : ${Battery}%
EQF
