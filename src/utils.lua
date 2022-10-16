function isHover(x, y, x2, y2)
  local m = vec2( love.mouse.getX(), love.mouse.getY() )
  return  m.min >= x and m.min <= x2 and
          m.max >= y and m.max <= y2
end

function vec2(min, max)
  return {
    min = min,
    max = max
  }
end

function getWindowVec2()
  return vec2(love.graphics.getWidth(), love.graphics.getHeight())
end

function stringCount(str, search)
	local count, pos = 0, 1
	repeat
		local s, f = str:find(search, pos, true)
		count = s and count + 1 or count
		pos = f and f + 1
	until pos == nil
	return count
end

return {
  isHover       = isHover,
  vec2          = vec2,
  getWindowVec2 = getWindowVec2,
  stringCount   = stringCount
}