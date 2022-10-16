local gui = require "gui"
local utils = require "utils"

local board = { }

function board:new(size, colorO, colorX)
  object = setmetatable({ }, self)
  self.__index = self
  object:init(size, colorO, colorX)
  return object
end

function board:init(size, colorO, colorX)
  self.size = size or 3
  self.full_size = self.size * self.size
  self.colorO = colorO or gui.colors.white
  self.colorX = colorX or gui.colors.white
  self.window = utils.getWindowVec2()
  self.space = utils.vec2(self.window.min / self.size, self.window.max / self.size)
  self.info = { }
  local int = 0

  for i = 1, self.size do
    for j = 1, self.size do
      local sX = utils.vec2((i - 1) * self.space.min, i * self.space.min)
      local sY = utils.vec2((j - 1) * self.space.max, j * self.space.max)
      int = int + 1

      self.info[int] = {
        symbol = nil,
        x = sX,
        y = sY
      }
    end
  end
end

function board:setCell(num, symbol)
  self.info[num].symbol = symbol
end

function board:isEmpty(num)
  return self.info[num].symbol == nil
end

function board:hasEmpty()
  return #self:getEmpty() > 0
end

function board:getEmpty()
  local res = { }
  for i = 1, self.full_size do
    if self:isEmpty(i) then
      table.insert(res, i)
    end
  end
  return res
end

function board:getEmptySide(side)
  local res = { }

  if side == "h" then
    for i = 1, self.size do
      res[i] = { }
      for j = i, self.full_size, self.size do
        if self:isEmpty(j) then
          table.insert(res[i], j)
        end
      end
    end
  elseif side == "v" then
    local row = 0
    for i = 1, self.full_size do
      if self.info[i].y.min == 0 then
        row = row + 1
        res[row] = { }
      end
      if self:isEmpty(i) then
        table.insert(res[row], i)
      end
    end
  elseif side == "dl" then
    local _, dl = self:getDiagonalL()
    for i in ipairs(dl) do
      if self:isEmpty(dl[i]) then
        table.insert(res, dl[i])
      end
    end
  elseif side == "dr" then
    local _, dr = self:getDiagonalR()
    for i in ipairs(dr) do
      if self:isEmpty(dr[i]) then
        table.insert(res, dr[i])
      end
    end
  end

  return res
end

function board:getFullSize()
  return self.full_size
end

function board:getSize()
  return self.size
end

function board:getInfo()
  return self.info
end

function board:draw()
  --> Separators
  for i = 1, self.size do
    gui.separator(i * self.space.min, 0, i * self.space.min, self.window.max)
    for j = 1, self.size do
      gui.separator(0, i * self.space.max, self.window.min, i * self.space.max)
    end
  end

  --> X & O
  for i = 1, self.full_size do
    if self.info[i].symbol == "x" then
      gui.drawX(self.info[i].x.min, self.info[i].y.min, self.info[i].x.max, self.info[i].y.max, self.colorX)
    elseif self.info[i].symbol == "o" then
      gui.drawO(self.info[i].x.min, self.info[i].y.min, self.info[i].x.max, self.info[i].y.max, self.colorO)
    end
  end
end

function board:getWinner(p)
  if (string.rep(p, self.size) == self:getDiagonalL()) or (string.rep(p, self.size) == self:getDiagonalR()) then
    return string.format("Player %s win!", p:upper())
  else
    for i = 1, self.size do
      if (string.rep(p, self.size) == self:getVertical()[i]) or (string.rep(p, self.size) == self:getHorizontal()[i]) then
        return string.format("Player %s win!", p:upper())
      end
    end
  end
  
  return not self:hasEmpty() and "\tDraw" or nil
end

function board:getVertical()
  local res = { }
  local nums = { }
  local row = 0

  for i = 1, self.full_size do
    if self.info[i].y.min == 0 then
      row = row + 1
      res[row] = ""
      nums[row] = { }
    end
    res[row] = res[row] .. (self.info[i].symbol == nil and "-" or self.info[i].symbol)
    table.insert(nums[row], i)
  end

  return res, nums
end

function board:getHorizontal()
  local res = { }
  local nums = { }
  
  for i = 1, self.size do
    res[i] = ""
    nums[i] = { }
    for j = i, self.full_size, self.size do
      res[i] = res[i] .. (self.info[j].symbol == nil and "-" or self.info[j].symbol)
      table.insert(nums[i], j)
    end
  end

  return res, nums
end

function board:getDiagonalL()
  local res = ""
  local nums = { }
  local realCell = 1

  for i = 1, self.size do
    for j = 1, self.size do
      if i == j then
        realCell = (i == 1 and j == 1) and 1 or realCell + self.size + 1
        res = res .. (self.info[realCell].symbol == nil and "-" or self.info[realCell].symbol)
        table.insert(nums, realCell)
      end
    end
  end

  return res, nums
end

function board:getDiagonalR()
  local res = ""
  local nums = { }
  local realCell = self.full_size - self.size + 1

  for i = self.size, 1, -1 do
    for j = 1, self.size do
      local offset = (self.size - i) + 1
      if j == offset then
        realCell = j == 1 and realCell or realCell - self.size + 1
        res = res .. (self.info[realCell].symbol == nil and "-" or self.info[realCell].symbol)
        table.insert(nums, realCell)
      end
    end
  end

  return res, nums
end

return {
  board = board
}