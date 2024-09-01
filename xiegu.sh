
function xiegu() {

port=$1

rigctld -m 3070 -s 19200 -r /dev/ttyUSB$port &
}
