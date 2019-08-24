dofile("mqtt_config.lua")
dofile("meteo.lua")
dofile("lux.lua")

-- initiate the mqtt client and set keepalive timer to 120sec
mqtt = mqtt.Client("nodemcu", 120)


local mqtt_connected = false

-- mqtt:on("connect", function(con)
--   print ("mqtt on:connected")
-- end)
mqtt:on("offline", function(con)
  print ("mqtt on:offline")
  mqtt_connected = false
  do_mqtt_connect()
end)

function handle_mqtt_error(client, reason)
  print(string.format("mqtt connection error %i", reason))
  tmr.create():alarm(5 * 1000, tmr.ALARM_SINGLE, do_mqtt_connect)
end

function handle_mqtt_connected(client, reason)
  print(string.format("mqtt connected to %s", mqtt_server))
  mqtt_connected = true
  -- publish a message with data, QoS = 0, retain = 0
  -- mqtt:publish("/nodemcu","i'm here", 0, 0)
end

function do_mqtt_connect()
  mqtt:connect(mqtt_server, mqtt_port, handle_mqtt_connected, handle_mqtt_error)
end


function mqtt_publish(topic, value)
  local result = mqtt:publish(mqtt_topic..topic, value, 0, 0)
  print(topic.." = "..value.." publish "..(result and "success" or "failed"))
end


tmr.create():alarm(mqtt_publish_interval, tmr.ALARM_AUTO, function()
    if not mqtt_connected then
      -- print("get_lux not executed because mqtt is not connected")
      return
    end

    mqtt_publish("illuminance", getlux())

    local temp, humidity, pressure, pressure_to_sea = read_meteo()
    mqtt_publish("temperature", temp)
    mqtt_publish("humidity", humidity)
    mqtt_publish("pressure", pressure)
    mqtt_publish("pressure_to_sea", pressure_to_sea)
end)

do_mqtt_connect()
