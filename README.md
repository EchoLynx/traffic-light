# traffic-light
Code for controlling an IKEA decorative traffic light (discontinued) over a network using MQTT, an ESP8266 running NodeMCU, and AC relay boards.

## Necessary Hardware
* A Linux computer with bash, mosquitto, and python3. (flasher may work on Windows, but that was not tested)
* IKEA decorative traffic light (discontinued)
* An ESP8266
* A wifi network
* Three AC relay boards controllable with 3.3V TTL
* Small 5V DC power supply that runs on 120V AC

## Quickstart
1. Wire the AC relay boards inline with each light, connecting the control pins to the ESP8266.
3. Connect the ESP8266 and relay boards to the power supply.
2. Use the flasher to flash the included NodeMCU build to an ESP8266.
3. Update init.lua with your wifi network credentials and load init.lua onto the ESP8266.
4. Start mosquitto on your computer.
5. Run the bash scripts and watch the traffic light blink!
6. Modify the bash script as necessary.
