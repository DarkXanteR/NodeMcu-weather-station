
function onWifiReady()
  print("WiFi Ready")
  dofile("mqtt.lua")
end

dofile("wifi.lua")
