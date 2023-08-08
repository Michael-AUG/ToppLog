echo "WELCOME TO GM5AUG'S LOGGING PROGRAM"
echo "-----------------------------"
echo "Station Callsign"
read station
echo "Station Locator"
read locator
date=$(date +%Y%m%d)
echo "Station Operator"
read op
echo "CAT control = 1, manual = 0"
read catcont
echo "Contest = 1, non contest = 0"
read contest
if [ "$contest"  == 1 ]
then
  echo "Callsign,Frequency,Mode,TX-RST,TX-SER,RX-RST,RX-SER,UTC-On,UTC-Off,Operator,Station,Date,Locator" >> contest_log_${station//\//-}$date.csv
  declare -i txser=1
elif [ -z "$contest" ]
then
  echo "Callsign,Frequency,Mode,TX-RST,RX-RST,UTC-On,UTC-Off,Operator,Station,Date,Locator" >> log_${station//\//-}$date.csv
fi
declare -i y=0

while true
do
echo "-----------------------------"
echo "Callsign"
read call
utcon=$(date -u +%H%M%S)
if [ "$catcont" == 1 ]
then
  freq=$(rigctl -m2 \get_freq)
  mode=$(rigctl -m2 \get_mode|awk 'NR==1{print $1}')
  echo "Freq and mode from radio"
  echo "$freq $mode"
elif [ -z "$catcont" ]
then
  echo "Same Freq and Mode = 1 Diff Freq and Mode = 0"
  read same
  if [ -z "$same" ]
  then
    echo "Frequency"
    read freq
    echo "Mode"
    read mode
  elif [ "$same" == 1 ]
  then
    echo "Freq and Mode"
    echo "$freq $mode"
  fi
fi
if [ "$contest" == 1 ]
then
  declare -i tx=599
  declare -i rx=599
  echo "TX Serial $txser"
  echo "RX Serial"
  read rxser
elif [ -z "$contest" ]
then
  echo "TX RST"
  read tx
  echo "RX RST"
  read rx
fi
utcoff=$(date -u +%H%M%S)
echo "Correct? 1 or 0"
echo "$call $freq $mode $tx $rx $utc $op"
read confirm
if [ "$confirm" == 1 ]
then
  if [ "$contest" == 1 ]
  then
    echo "$call,$freq,$mode,$tx,$txser,$rx,$rxser,$utcon,$utcoff,$op,$station,$date,$locator" >> contest_log_${station//\//-}$date.csv
    txser=$((txser+1))
  elif [ -z "$contest" ]
  then
    echo "$call,$freq,$mode,$tx,$rx,$utcon,$utcoff,$op,$station,$date,$locator" >> log_${station//\//-}$date.csv
  fi
  y=$((y+1))
  echo "$y Logged"
elif [ -z "$confirm" ]
then
  echo "re-enter details"
fi
sleep 2
done
