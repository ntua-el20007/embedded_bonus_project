# WSS and Heatmap Generation for DAMO Monitoring  

This repository contains scripts for **testing the handler script** (`handler.py`) in the same directory. The scripts generate:  

- **WSS text report** (`<prefix>_wss.txt`)  
- **WSS plot** (`<prefix>_wss.png`)  
- **Per-region heatmaps** (`<prefix>_<region>.png`)  

## Prerequisites  

Before running the scripts, **DAMO must be invoked to record the handler** and then stopped:  

```bash
sudo damo record "./handler.py"
# Perform necessary tests or workload
sudo damo stop
