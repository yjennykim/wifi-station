import argparse
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

# parse args
parser = argparse.ArgumentParser(description="Plot Wi-Fi metrics from a CSV file.")
parser.add_argument("wifi", type=str, help="The SSID (Wifi Name) to Plot")
args = parser.parse_args()

project_root = Path(__file__).resolve().parent.parent
csv_path = project_root / "data" / args.wifi + ".csv"

if not csv_path.exists():
    print(f"Error: {csv_path} does not exist.")
    exit(1)

df = pd.read_csv(csv_path, parse_dates=["Timestamp"])

df.set_index("Timestamp", inplace=True)

plt.figure(figsize=(14, 7))
plt.plot(
    df.index, df["RSSI"], label="RSSI (dBm)", color="orange", linestyle="--", marker="o"
)
plt.plot(
    df.index,
    df["TxRate"],
    label="Tx Rate (Mbps)",
    color="green",
    linestyle="-.",
    marker="x",
)
plt.plot(df.index, df["PingAvg"], label="Ping Avg (ms)", color="blue", marker="s")
plt.plot(
    df.index,
    df["PingStdDev"],
    label="Ping StdDev (ms)",
    color="red",
    linestyle=":",
    marker="d",
)

plt.title("Wi-Fi Metrics Over Time")
plt.xlabel("Time")
plt.ylabel("Value")
plt.xticks(rotation=45)
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
