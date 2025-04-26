#/!bin/bash
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
SSID=$(ipconfig getsummary $(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}') | awk -F ' SSID : ' '/ SSID : / {print $2}')
echo "SSID" $SSID

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$PROJECT_ROOT/data"
mkdir -p "$DATA_DIR"

CSV_FILE="$DATA_DIR/$SSID.csv"
if [ ! -f "$CSV_FILE" ]; then
        echo "Timestamp,SSID,RSSI,TxRate,PingAvg,PingStdDev" >> "$CSV_FILE"
fi

WDUTIL_OUTPUT=$(wdutil info)

RSSI=$(echo "$WDUTIL_OUTPUT" | grep 'RSSI' | awk '{print $3}' | head -n 1)
echo "RSSI" $RSSI

TXRATE=$(echo "$WDUTIL_OUTPUT" | grep 'Tx Rate' | awk '{print $4}')
echo "Tx Rate" $TXRATE

PING_STATS=$(ping -c 10 google.com)
PING_AVG=$(echo "$PING_STATS" | tail -n 1 | awk -F'/' '{print $5}')
PING_STDEV=$(echo "$PING_STATS" | tail -n 1 | awk -F'/' '{print $7}' | sed 's/ ms//')

echo "Average Ping: $PING_AVG ms"
echo "Ping Standard Deviation: $PING_STDEV ms"

echo "$TIMESTAMP,$SSID,$RSSI,$TXRATE,$PING_AVG, $PING_STDEV" >> "$CSV_FILE"
