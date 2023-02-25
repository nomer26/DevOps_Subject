#!/bin/bash

# This script monitors and visualizes CPU, Memory, and Disk usage on Ubuntu 22.04 operating system.

# Define the terminal width

function fmt(){
  nc='\033[0m'

  case $1 in
	  "cpu") 
		  str="User_cpu Sys_cpu Total_cpu"
		  usg=$2
		  #usg=$(top -n1 | grep -i '%CPU(s)' | awk '{printf("%d %d %d", $2,$3,$2+$3)}')
		  #usg=$(vmstat 1 1 | tail -1 | awk '{ printf("%d %d %d", "$13","$14","$($13+$14)")}')
		  COLOR='\033[0;32m'
		  unit="%";;

	  "mem") 
		  str="Avail_mem Used_mem Mem_usage"
		  usg=$(free -m | awk '/Mem:/ { printf("%d %d %d", $3, $7, $3/$2*100) }')
		  COLOR='\033[0;33m'
		  unit="Mb";;

	  "disk")
		  str="Disk_usage Mount_point"
		  usg=$(df -H | grep -vE '^Filesystem' | awk '{ print $5 " " $1 }')
		  COLOR='\033[0;36m'
		  unit="None";;
	  "*")
		  str="Nothing"
		  usg=" "
		  COLOR=$nc
		  unit=" ";;

  esac

  n=${#str}
  
  n1=$(echo $str | cut -d' ' -f1)
  n2=$(echo $str | cut -d' ' -f2)
  n3=$(echo $str | cut -d' ' -f3)
  
  m1=$(echo $usg | cut -d' ' -f1)
  m2=$(echo $usg | cut -d' ' -f2)
  m3=$(echo $usg | cut -d' ' -f3)

  echo -e "${COLOR}"
  echo "$1 Usage: (Unit : $unit)"
  echo -e $(printf '  %-*s  ' $((${#n1} + ${#n2} + ${#n3} + 6)) " " | tr " " "-")
  echo -e $(printf "| %*s | %*s | %*s |\n" "$((${#n1}-${#m1}))" "$n1" "$((n-${#n2}))" "$n2" "$((n-${#n3}))" "$n3")
  echo -e $(printf '  %-*s  ' $((${#n1} + ${#n2} + ${#n3} + 6)) " " | tr " " "-")
  if [[ $1 == "disk" ]];
  then
    df -H | grep -vE '^Filesystem' | awk '{ print $5 " \t\t " $6}'
  else
    echo -e $(printf "| %${#n1}s | %${#n2}s | %${#n3}s |\n" "$m1" "$m2" "$m3") | awk -F \
	    '|' '{printf("| %'"${#n1}"'s | %'"${#n2}"'s | %'"${#n3}"'s |\n", $2, $3, $4)}'
    echo -e $(printf '  %-*s  ' $((${#n1} + ${#n2} + ${#n3} + 6)) " " | tr " " "-")
  fi
  echo -e "${nc}"
}

data=$(top -n1 | grep -i '%CPU(s)' | awk '{printf("%d %d %d", $2,$3,$2+$3)}' &)

while true;
do 
  clear
  fmt "cpu" $data
  fmt "mem" 
  fmt "disk" 
  data=$(top -n1 | grep -i '%CPU(s)' | awk '{printf("%d %d %d", $2,$3,$2+$3)}' &)
  sleep 1
done
