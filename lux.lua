SDA_PIN = 6 -- sda pin, GPIO12
SCL_PIN = 5 -- scl pin, GPIO14

bh1750 = require("bh1750")

bh1750.init(SDA_PIN, SCL_PIN)

function getlux( ... )
	bh1750.read(OSS)
    return string.format("%.2f", bh1750.getlux()/100)
end
