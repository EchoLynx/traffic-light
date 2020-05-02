tl_pins={}
tl_pins.red=0
tl_pins.yellow=1
tl_pins.green=2


function check_light_state(value)
	if (value == nil) then
		return nil
	elseif (value == 0 or value == "0") then
		return 0
	elseif (valu == 1 or value == "1") then
		return 1
	else
		return nil
	end
end

function subscribe()
	-- init mqtt client without logins, keepalive timer 120s
	m = mqtt.Client("clientid", 120)
	
	-- init mqtt client with logins, keepalive timer 120sec
	--m = mqtt.Client("clientid", 120, "user", "password")
	
	-- setup Last Will and Testament (optional)
	-- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
	-- to topic "/lwt" if client don't send keepalive packet
	--m:lwt("/lwt", "offline", 0, 0)
	
	m:on("connect", function(client) print ("connected") end)
	m:on("offline", function(client) print ("offline") end)
	
	-- on publish message receive event
	m:on("message", function(client, topic, data) 
		if (topic=="/traffic-light/red") then
			if (data == nil) then
				red()
			else
				red(check_light_state(data))
			end
		elseif (topic=="/traffic-light/yellow") then
			if (data == nil) then
				yellow()
			else
				yellow(check_light_state(data))
			end
		elseif (topic=="/traffic-light/green") then
			if (data == nil) then
				green()
			else
				green(check_light_state(data))
			end
		end
	end)
	
	-- for TLS: m:connect("192.168.11.118", secure-port, 1)
	m:connect("host.local.lan", 1883, 0, function(client)
	  print("connected")
	  -- Calling subscribe/publish only makes sense once the connection
	  -- was successfully established. You can do that either here in the
	  -- 'connect' callback or you need to otherwise make sure the
	  -- connection was established (e.g. tracking connection status or in
	  -- m:on("connect", function)).
	
	  -- subscribe topic with qos = 0
	  client:subscribe({["/traffic-light/red"]=2,["/traffic-light/yellow"]=2,["/traffic-light/green"]=2}, function(client) print("subscribe success") end)
	end,
	function(client, reason)
	  print("failed reason: " .. reason)
	end)
	
	m:close();
	-- you can call m:connect again
end



srv=0
function create_server()
	wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
		print("IP: "..T.IP)
		subscribe()
		srv = net.createServer(net.TCP,1)
		srv:listen(80,function(conn)
			conn:on("receive",function(cn,request)
				yellow()
				print("yellow()")
				cn:send("yellow()", function()
					cn:close()
					collectgarbage()
				end)
			end)
		end)
	end)
end
function connect()
	print("MAC: "..wifi.ap.getmac())
	--Set Country
	country_info={}
	country_info.country="US"
	country_info.start_ch=1
	country_info.end_ch=13
	country_info.policy=wifi.COUNTRY_AUTO;
	wifi.setcountry(country_info)
	--Set Mode
	wifi.setmode(wifi.STATION)
	--Connect
	station_cfg={}
	station_cfg.ssid="wifi-ssid"
	station_cfg.pwd="wifi-password"
	station_cfg.auto=false
	wifi.sta.config(station_cfg)
	wifi.sta.connect()
end

function init_gpio()
	gpio.mode(tl_pins.red, gpio.OUTPUT, gpio.PULLUP)
	gpio.mode(tl_pins.yellow, gpio.OUTPUT, gpio.PULLUP)
	gpio.mode(tl_pins.green, gpio.OUTPUT, gpio.PULLUP)
	
	gpio.write(tl_pins.red, gpio.HIGH)
	gpio.write(tl_pins.yellow, gpio.HIGH)
	gpio.write(tl_pins.green, gpio.HIGH)
end

function flip(pinNumber, pinState)
	local pinState = pinState or gpio.read(pinNumber)
	if pinState == gpio.LOW then
		gpio.write(pinNumber, gpio.HIGH) 
	elseif pinState == gpio.HIGH then
		gpio.write(pinNumber, gpio.LOW)
	end
end

function set_light(lightState,pinNumber)
	local pinState = gpio.read(pinNumber)
	if (lightState == nil) then
		flip(pinNumber)
	elseif (lightState == 0) then
		gpio.write(pinNumber, gpio.HIGH)
	elseif (lightState == 1) then
		gpio.write(pinNumber, gpio.LOW)
	end
end

function yellow(lightState)
	set_light(lightState, tl_pins.yellow)
end
function red(lightState)
	set_light(lightState, tl_pins.red)
end
function green(lightState)
	set_light(lightState, tl_pins.green)
end

init_gpio()
connect()
create_server()
