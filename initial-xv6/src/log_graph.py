import pandas as pd
import matplotlib.pyplot as plt

# Load the data from kernel_logs.txt
file_path = 'kernel_logs.txt'
data = pd.read_csv(file_path, header=None, names=['pid', 'ticks', 'queuenumber'])

# Get the unique process IDs (pids)
pids = data['pid'].unique()

# Create a new plot
plt.figure(figsize=(10, 6))

# Plot each process' queue number over time
for pid in pids:
    # Filter data for each process
    process_data = data[data['pid'] == pid]
    plt.step(process_data['ticks'], process_data['queuenumber'], where='post', label=f'P{pid}')

# Add labels, title, and legend
plt.xlabel('Number of ticks')
plt.ylabel('Queue number')
plt.title('Process Queue Movement Over Time')
plt.legend(loc='best')

# Customize the plot
plt.grid(True)
plt.tight_layout()

# Show the plot
plt.show()
