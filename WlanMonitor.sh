#!/bin/bash

# check for proxy
export http_proxy=

AP_URL='http://admin:admin@192.168.1.1/userRpm/WlanStationRpm.htm'
TARGET_WLAN_MAC='00-03-7F-BE-F1-3C'
if [ $# -eq 1 ]; then
    TARGET_WLAN_MAC=$1
fi
DATE_CMD='date +%R:%S'
DATE_CMD_SECS='date +%s'
INTERVAL_SECS=1

prev_stat=
cur_stat=
# 0 - not exist, 1 - exist
prev_stat_flag=0
cur_stat_flag=0

connect_count=0
disconnect_count=0

start_time=`$DATE_CMD`
start_time_secs=`$DATE_CMD_SECS`

echo '++++++++++++++++ START ++++++++++++++++'
echo "+ AP_URL: $AP_URL"
echo "+ TARGET_WLAN_MAC: $TARGET_WLAN_MAC"
echo "+ INTERVAL_SECS: $INTERVAL_SECS seconds"
echo '+++++++++++++++++++++++++++++++++++++++'
while [ 1 ]; do
    # curl: no proxy for all, and suppress progress output
    cur_stat=`curl --noproxy * -s "$AP_URL" |  grep -i -A 3 "$TARGET_WLAN_MAC"`
    prev_stat_flag=$cur_stat_flag
    if [ -z "$cur_stat" ]; then
        cur_stat_flag=0
    else
        cur_stat_flag=1
    fi

    # connection status changed
    if [ "$cur_stat_flag" != "$prev_stat_flag" ]; then
        if [ "$cur_stat_flag" -eq 1 ]; then
            echo "*** ESTABLISH Connection."
            echo "Timestamp: " `$DATE_CMD`
            echo "Status: " $cur_stat
            let connect_count=$connect_count+1
        else
            echo "*** LOST Connection."
            echo "Timestamp: " `$DATE_CMD`
            echo "Status: " $prev_stat
            let disconnect_count=$disconnect_count+1
        fi
    fi

    prev_stat=$cur_stat

    # exit status report, need to be updated here
    # NOTE: must get updated in every loop, so the value in trap could be updated
    end_time=`$DATE_CMD`
    end_time_secs=`$DATE_CMD_SECS`
    monitor_duration_min=`echo "($end_time_secs - $start_time_secs)/60" | bc`
    monitor_duration_sec=`echo "($end_time_secs - $start_time_secs)%60" | bc`
    trap "echo ''; echo '++++++++++++++++ End ++++++++++++++++';                    \
          echo '+ Start:' \"$start_time\";                                          \
          echo '+ CONNECT:' $connect_count;                                         \
          echo '+ DISCONNECT:' $disconnect_count;                                   \
          echo '+ END: ' \"$end_time\";                                             \
          echo '+ DURATION: ' \"$monitor_duration_min:$monitor_duration_sec\";      \
          echo '+++++++++++++++++++++++++++++++++++++'"                             \
          0                 # Ctrl-C


    sleep $INTERVAL_SECS
done

