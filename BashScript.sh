#!/bin/bash
# Get CPU usage of the EC2 instance and Check if CPU usage exceeds thresholds
 check_cpu() {
 CPU_THRESHOLD=90

CPU_USAGE=$(top -bn 1 | grep '%Cpu' | awk '{print $2}')
echo "CPU usage is: $CPU_USAGE%"

if (( $(echo "$CPU_USAGE > $ CPU_THRESHOLD" | bc -l) )); then
    echo -e "\033[1;31m CPU load average is currently $CPU_USAGE, which is higher than the maximum of $CPU_THRESHOLD \033[0m" >&2
    return 1
  else
    echo -e "\033[1;32m CPU load average is currently $CPU_USAGE, which is within the acceptable range.\033[0m"
    return 0
  fi
}

#Get Memory usage of the EC2 instance and Check if Memory usage exceeds thresholds
 check_memory() {
  MEMORY_THRESHOLD=90

  total_memory=$(grep 'MemTotal' /proc/meminfo | awk '{print $2}')
  available_memory=$(grep 'MemAvailable' /proc/meminfo | awk '{print $2}')

  memory_utilization=$(echo " ($total_memory - $available_memory)/$total_memory * 100" | bc)

  if (( $(echo "$memory_utilization > $MEMORY_THRESHOLD" | bc -l) ))
  then 
      echo -e "\033[1;31m Memory utilization is above the threshold!!! Memory utilization is: $memory_utilization% \033[0m"
      return 1
  else
      echo -e "\033[1;32m Memory utilization is currently $memory_utilization, which is within the acceptable range.\033[0m"
      return 0
  fi 
}

#Get IO usage of the EC2 instance and Check if IO usage exceeds thresholds
check_io() {
IO_THRESHOLD=1
  iowait_state=$(top -b -n 1 | head -n +3|awk '{print $10}'|tail -1 |bc)
  if [[ $(echo "$iowait_state > IO_THRESHOLD" | bc) -eq 1 ]]; then
    echo -e "\033[1;31m IOWAIT is currently $iowait_state, which is higher than the acceptable range \033[0m" >&2
    return 1
  else
    echo -e "\033[1;32m IOWAIT is currently $iowait_state, which is within the acceptable range.\033[0m"
    return 0
  fi
}

# Email settings for sending alerts
send_email() {
  Replace with your email
 recipient="tgrahesh@gmail.com"
  subject="Alert: System performance issue detected"
  body="One or more performance issues have been detected on the system. Please check the system immediately."
  echo "$body" | mail -s "$subject" $recipient
}

 main() {
 check_cpu || send_email
  check_memory || send_email
 check_io || send_email
}
main
