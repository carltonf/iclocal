#!/bin/sh

function _start_rest() {
    xwrits                                                                  \
        warning-picture=/home/xiongchao/Documents/gif/counting_money.gif    \
        typetime=14 br=:17 +flashtime=:5 +mouse -idle &

    xwrits                                                          \
        warning-picture=/home/xiongchao/Documents/gif/pass_by.gif   \
        rest-picture=/home/xiongchao/Documents/gif/sleepy_girl.gif  \
        ready-picture=/home/xiongchao/Documents/gif/donut_girl.gif  \
        typetime=47 br=7 +flashtime=:5 +mouse +idle=20 &
}


ALL_ON=3
PARTIAL_ON=2
OFF=1
SUSPEND=
function _query_status() {
    return $(ps aux | grep 'xwrits' | wc -l)
}

# main
case $1 in
    start)
        if [ _query_status -eq $OFF ]; then
            echo "** start all instances"
            _start_rest
        else
            echo "** some instances are running, please stop them first."
        fi
        ;;
    stop)
        echo "** stop all instances"
        killall xwrits;
        ;;
    status)
        case _query_status in
            $ALL_ON)
            echo "** all on"
            ;;
            $PARTIAL_ON)
            echo "** only one instance on"
            ;;
            $OFF)
            echo "** all off"
            ;;
            *)
        esac
        ;;
    suspend)
        echo "** suspend all instances"
        killall -STOP xwrits;
        ;;
    resume)
        if [ _query_status -eq $OFF ]; then
            echo "** start all instances"
            _start_rest
        else
            echo "** some instances are running, please stop them first."
        fi
        ;;
    *)

esac
