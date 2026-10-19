from pathlib import Path
from stardust_reader import load_stardust

dataset_path = Path("")

data = load_stardust(dataset_path)

data.attitude.to_csv(
    "attitude.csv",
    index=False,
    date_format="%Y-%m-%dT%H:%M:%S.%f"
)

data.small_forces.to_csv(
    "small_forces.csv",
    index=False,
    date_format="%Y-%m-%dT%H:%M:%S.%f"
)

print(f"Attitude rows: {len(data.attitude)}")
print(f"Small Forces rows: {len(data.small_forces)}")
