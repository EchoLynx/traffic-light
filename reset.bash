#!/bin/bash
mosquitto_pub -t "/traffic-light/green" -m 0
mosquitto_pub -t "/traffic-light/yellow" -m 0
mosquitto_pub -t "/traffic-light/red" -m 0
