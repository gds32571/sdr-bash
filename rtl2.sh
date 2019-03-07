#!/bin/bash

MQTT_HOST="192.168.2.6"
MQTT_USER="hass"
MQTT_PASS="hass"

date

oldline="junk"

#./rtl_433/build/src/rtl_433 -d 0 -F json -f 433950000 -M level  | while read line
./rtl_433/build/src/rtl_433 -d 0 -F json -f 433920000 -M level -M protocol | while read line
do

    if [[ "$line" =~ "async read" ]]; then
       exit 2
    fi   

# default
    MQTT_TOPIC="rtl433/junk"

    if [ "$oldline" != "$line" ]; then
	oldline=$line
	# We don't know from the output which protocol number was received
	# However we can extract the id from json output
	DEVICE="$(echo $line | jq --raw-output '.sensor_id')"
        DEVICE2="$(echo $line | jq --raw-output '.id')"
        DEVICE3="$(echo $line | jq --raw-output '.rid')"
        DEVICE4="$(echo $line | jq --raw-output '.sid')"

	MT="$(echo $line | jq --raw-output '.message_type')"
         
               
	if [ "$DEVICE" = "3454" ]; then
	  if [ "$MT" = "56" ]; then
  	    MQTT_TOPIC="rtl433/acurite/cha"
	  else
   	    MQTT_TOPIC="rtl433/acurite/wind"
	  fi	
	elif [ "$DEVICE2" = "0" ]; then
	  MQTT_TOPIC="rtl433/acurite/inFactory"
	elif [ "$DEVICE2" = "66" ]; then
	  MQTT_TOPIC="rtl433/acurite/ac606tx"
	elif [ "$DEVICE2" = "6" ]; then
#	  MQTT_TOPIC="rtl433/acurite/ac606tx2"
	  MQTT_TOPIC="rtl433/acurite/kitchen"

#	elif [ "$DEVICE2" = "120" ]; then
#	  MQTT_TOPIC="rtl433/acurite/ac606tx3"
	elif [ "$DEVICE2" = "52" ]; then
	  MQTT_TOPIC="rtl433/acurite/lanai"
        elif [ "$DEVICE2" = "9" -a "$DEVICE3" = "65" ]; then
          MQTT_TOPIC="rtl433/prologue/1"
        elif [ "$DEVICE2" = "9" -a "$DEVICE3" = "15" ]; then
          MQTT_TOPIC="rtl433/prologue/2"
#	elif [ "$DEVICE" = "11908" ]; then
	elif [ "$DEVICE" = "4520" ]; then
	  MQTT_TOPIC="rtl433/acurite/tower"
#	elif [ "$DEVICE2" = "-18" ]; then
	elif [ "$DEVICE2" = "120" ]; then
	  MQTT_TOPIC="rtl433/acurite/ac606tx2"
	elif [ "$DEVICE" = "1" ]; then
	  MQTT_TOPIC="rtl433/acurite/rain1"
	elif [ "$DEVICE" = "2" ]; then
	  MQTT_TOPIC="rtl433/acurite/rain2"
	elif [ "$DEVICE4" = "144" ]; then
	  MQTT_TOPIC="rtl433/springfield/temperature"
        else
          MQTT_TOPIC="rtl433/junk"
	fi

  	printf "\033[34m\033[47m$MQTT_TOPIC --> \033[40m \033[33;1m $line \n\n\033[0m"
#	echo $line
#	printf "\n"
	
	# Publish the json to the appropriate topic
	echo $line | mosquitto_pub -l -h $MQTT_HOST -u $MQTT_USER -P $MQTT_PASS -t $MQTT_TOPIC

        ./deadman/socket1.py 3002 > /dev/null

    fi
done

exit 1

#   mosquitto_pub -h 192.168.1.40 -u hass -P hass -t rtl_433/acurite -l

