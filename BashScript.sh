#!/bin/bash
function check_cpu() {
 THRESHOLD=90

cpu_usage=$(top -bn 1 | grep &#39;%Cpu&#39; | awk &#39;{print $2}&#39
echo &quot;CPU usage is: $cpu_usage%&quot;

if (( $(echo "$cpu_usage > $THRESHOLD" | bc -l) )); then
    echo -e "\033[1;31m CPU load average is currently $load_avg, which is higher than the maximum of $max_load \033[0m" >&2
    return 1
  else
    echo -e "\033[1;32m CPU load average is currently $load_avg, which is within the acceptable range.\033[0m"
    return 0
  fi
}

function check_memory() {
  THRESHOLD=90

  total_memory=$(grep 'MemTotal' /proc/meminfo | awk '{print $2}')
  available_memory=$(grep 'MemAvailable' /proc/meminfo | awk '{print $2}')

  memory_utilization=$(echo "scale=2; ($total_memory - $available_memory)/$total_memory * 100" | bc)

  if (( $(echo "$memory_utilization > $THRESHOLD" | bc -l) ))
  then 
      echo -e "\033[1;32m Memory utilization is above the threshold!!! Memory utilization is: $utilization% \033[0m"
      return 1
  else
      echo -e "\033[1;32m Memory utilizationis currently $memory_utilization, which is within the acceptable range.\033[0m"
      return 0
  fi 
}

function check_io() {
  iowait_state=$(top -b -n 1 | head -n +3|awk '{print $10}'|tail -1 |bc)
  if [[ $(echo "$iowait_state > 1" | bc) -eq 1 ]]; then
    echo -e "\033[1;31m IOWAIT is currently $iowait_state, which is higher than the acceptable range \033[0m" >&2
    return 1
  else
    echo -e "\033[1;32m IOWAIT is currently $iowait_state, which is within the acceptable range.\033[0m"
    return 0
  fi
}


function send_email() {
  # Replace with your email
  recipient="tgrahesh@example.com"
  subject="Alert: System performance issue detected"
  body="One or more performance issues have been detected on the system. Please check the system immediately."
  echo "$body" | mail -s "$subject" $recipient
}

function main() {
  check_cpu || send_email
  check_memory || send_email
  check_io || send_email
}

main