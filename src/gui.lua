local utils = require "utils"

function button(font, name, x_, y_, width, height, color, colorHover, mode)
  ret = ret or true
  mode = mode or "line"
  width = width or 120
  height = height or 30
  color = color or colors.grey
  colorHover = colorHover or colors.white

  local nameVec2 = utils.vec2(font:getWidth(name), font:getHeight(name))
  local x = utils.vec2(x_, x_ + width)
  local y = utils.vec2(y_, y_ + height)

  local textVec2 = utils.vec2(
    x.min + (width * 0.5) - (nameVec2.min * 0.5),
    y.min + (height * 0.5) - (nameVec2.max * 0.5)
  )

  color = utils.isHover(x.min, y.min, x.max, y.max) and colorHover or color

  love.graphics.setColor(color)
  love.graphics.rectangle(mode, x.min + 3.0, y.min + 3.0, width - 3.0, height - 3.0)
  love.graphics.print(name, font, textVec2.min,  textVec2.max)

  return utils.isHover(x.min, y.min, x.max, y.max) and love.mouse.isDown(1)
end

function setBackgroundStateGame(state)
  love.graphics.setBackgroundColor(state and colors.white or colors.black)
end

function print(font, text, x, y, color)
  color = color or colors.white
  love.graphics.setColor(color)
  love.graphics.print(text, font, x, y)
end

function rectangle(x, y, width, height, color)
  color = color or colors.white
  love.graphics.setColor(color)
  love.graphics.rectangle("line", x, y, width, height)
end

function separator(x, y, x2, y2, color)
  color = color or colors.black
  love.graphics.setColor(color)
  love.graphics.line(x, y, x2, y2)
end

function drawO(x, y, x2, y2, color)
  color = color or colors.black
  love.graphics.setColor(color)
  love.graphics.circle("line", (x + x2) * 0.5, (y + y2) * 0.5, (y2 - y) * 0.5 - 10)
end

function drawX(x, y, x2, y2, color)
  color = color or colors.black
  separator(x + 20, y + 20, x2 - 20, y2 - 20, color)
  separator(x2 - 20, y + 20, x + 20, y2 - 20, color)
end

colors = {
  white   = { 1.00, 1.00, 1.00 },
  black   = { 0.00, 0.00, 0.00 },
  grey    = { 0.65, 0.65, 0.65 },

  green   = { 0.00, 1.00, 0.00 },
  red     = { 1.00, 0.00, 0.00 },
  blue    = { 0.25, 0.50, 1.00 },
  purple  = { 0.62, 0.17, 0.41 }
}

return {
  button                  = button,
  setBackgroundStateGame  = setBackgroundStateGame,
  print                   = print,
  rectangle               = rectangle,
  separator               = separator,

  drawO   = drawO,
  drawX   = drawX,
  colors  = colors
}