#!/bin/sh
echo "Starting Clean Mem..."
pkill -9 python
pkill -9 Xvfb
pkill -9 chrome
echo "Finished Cleaning Mem..."
