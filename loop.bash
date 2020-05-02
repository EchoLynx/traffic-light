while [ : ]
do
	mosquitto_pub -t "/traffic-light/red" -m 1
	sleep 1
	mosquitto_pub -t "/traffic-light/red" -m 0
	mosquitto_pub -t "/traffic-light/yellow" -m 1
	sleep 1
	mosquitto_pub -t "/traffic-light/yellow" -m 0
	mosquitto_pub -t "/traffic-light/green" -m 1
	sleep 1
	mosquitto_pub -t "/traffic-light/green" -m 0
done
