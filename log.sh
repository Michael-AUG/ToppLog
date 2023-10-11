echo "WELCOME TO ToppLog - GM5 AUG'S LOGGING PROGRAM"
echo "-----------------------------"
echo "Station Callsign"
read station
filename=$(echo $station | sed 's/^\///;s/\//_/g')
echo "Station Locator"
read stationLocator
date=$(date +%Y%m%d)
echo "Station Operator"
read op
echo "CAT control = 1, manual = 0"
read catcont
if [ "$catcont" -eq 1 ]
then
echo "Maximum TXCVR Power (W)"
echo "(Here enter the maximum power the radio can provide)"
read maxPower
fi
echo "Contest = 1, non contest = 0"
read contest

if [ "$contest"  -eq 1 ]
then
  echo "Callsign,Frequency,Mode,TX-RST,TX-SER,RX-RST,RX-SER,UTC-On,UTC-Off,Operator,Station,Date,Power,StationLocator,Locator" >> contest_log_$filename\_$date.csv
  declare -i txser=1
elif [ "$contest" -ne 1 ]
then
  echo "Callsign,Frequency,Mode,TX-RST,RX-RST,UTC-On,UTC-Off,Operator,Station,Date,Power,StationLocator,Locator" >> log_$filename\_$date.csv
fi

declare -i y=0

while true
do
echo "-----------------------------"
echo "Callsign"
read call
utcon=$(date -u +%H%M%S)

if [ "$catcont" -eq 1 ]
then
  rawFreq=$(rigctl -m2 \get_freq)
  freq=$(echo "scale=4; $rawFreq / 1000000" | bc)
  mode=$(rigctl -m2 \get_mode|awk 'NR==1{print $1}')
  tempPower=$(rigctl -m2 \get_level 'RFPOWER')
  power=$(echo "scale=1; ($maxPower * $tempPower * 100) / 100" | bc)
  echo "Freq, mode and power from radio"
  echo "$freq $mode $power"
elif [ "$catcont" -ne 1 ]
then
  echo "Same Freq and Mode = 1 Diff Freq and Mode = 0"
  read same

  if [ "$same" -ne 1 ]
  then
    echo "Frequency in MHz"
    read freq
    echo "Mode"
    read mode
    echo "Power (in W)"
    read power
  elif [ "$same" -eq 1 ]
  then
    echo "Freq, Mode and Power"
    echo "$freq $mode $power"
  fi
fi

if [ "$contest" -eq 1 ]
then
  declare -i tx=599
  declare -i rx=599
  echo "TX Serial $txser"
  echo "RX Serial"
  read rxser
elif [ "$contest" -ne 1 ]
then
  echo "TX RST"
  read tx
  echo "RX RST"
  read rx
  locator=""
  echo "Log location? 1/0"
  read binaryLocator
  if [ "$binaryLocator" -eq 1 ]
    then
    echo "Locator"
    read locator
  fi
fi

utcoff=$(date -u +%H%M%S)
echo "Correct? 1 or 0"
echo "$call $freq $mode $tx $rx $utc $op $locator"
read confirm

if [ "$confirm" -eq 1 ]
then

  if [ "$contest" -eq 1 ]
  then
    echo "$call,$freq,$mode,$tx,$txser,$rx,$rxser,$utcon,$utcoff,$op,$station,$date,$power,$stationLocator,$locator" >> contest_log_$filename\_$date.csv
    txser=$((txser+1))
  elif [ "$contest" -ne 1 ]
  then
    echo "$call,$freq,$mode,$tx,$rx,$utcon,$utcoff,$op,$station,$date,$power,$stationLocator,$locator" >> log_$filename\_$date.csv
  fi

  y=$((y+1))
  echo "$y Logged"
elif [ "$confirm" -ne 1 ]
then
  echo "re-enter details"
fi

sleep 1

done
