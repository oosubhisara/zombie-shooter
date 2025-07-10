-- util.lua

local Util = {}

function Util.angleBetweenPoints(x1, y1, x2, y2)
	return math.atan2(y1 - y2, x1 - x2)
end

function Util.distanceBetween(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function Util.rotatePoint(x, y, rad)
	local cos = math.cos(rad)
	local sin = math.sin(rad)
	return x * cos - y * sin, x * sin + y * cos
end

return Util
