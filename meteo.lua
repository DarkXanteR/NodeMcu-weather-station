SDA_PIN = 6 -- sda pin, GPIO12
SCL_PIN = 5 -- scl pin, GPIO14

alt=200 -- altitude of the measurement place
i2c.setup(0, SDA_PIN, SCL_PIN, i2c.SLOW) -- call i2c.setup() only once
bme280.setup()


function read_meteo()
	T, P, H, QNH = bme280.read(alt)

  local temp = string.format("%.2f", T/100)
  local pressure = string.format("%.2f", (P/1000) * 0.750064)
  local pressure_to_sea = string.format("%.2f", (QNH/1000) * 0.750064)
  local humidity = string.format("%.2f", H/1000)

  return temp, humidity, pressure, pressure_to_sea
end
