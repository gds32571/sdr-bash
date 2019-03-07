# sdr-bash
BASH scripts to read from the rtl_433 program and publish MQTT messages containing Acurite weather sensor data.

rtl.sh
   runs the second program. It will restart that program if it crashes. It counts the number of restarts and records the value in myctr.txt
   
rtl2.sh
   runs the rtl_433 program in JSON output mode, assigns MQTT topcis to the messages, and publishes them with the Paho client software.
   It uses a watchdog system on this network to signal it is up and running. A program called socket1.py does this function.  Remove
   it from the file if you don't use my deadman system (You probably don't!).   
