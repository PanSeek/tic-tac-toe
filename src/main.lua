local gui = require "gui"
local utils = require "utils"
local Board = require "board"
local ai = require "ai"

--> Variables
local start = false
local fonts = { }
local window = { 0, 0 }

local clrs = {
  [0] = gui.colors.green,
  [1] = gui.colors.red,
  [2] = gui.colors.blue,
  [3] = gui.colors.purple
}
local players = {
  current_player = "x",
  x = {
    isBot = false,
    color = 0
  },
  o = {
    isBot = false,
    color = 1
  }
}

local modes = { 3, 4, 5 }
local mode = 3
local winner = nil
local timer = 2.5

local board = Board.board

--> Logic
function love.load()
  math.randomseed(os.time())
  
  window = utils.getWindowVec2()
  
  fonts[16] = love.graphics.newFont(16)
  fonts[24] = love.graphics.newFont(24)
end

function love.mousepressed(x, y, button)
  if start then
    local info = board:getInfo()
    for i = 1, board:getFullSize() do
      if  button == 1 and utils.isHover(info[i].x.min, info[i].y.min, info[i].x.max, info[i].y.max) and
          board:isEmpty(i) and not players[players.current_player].isBot and timer >= 2.4
      then
        board:setCell(i, players.current_player)
        winner = board:getWinner(players.current_player)
        if winner == nil then
          changePlayer()
        end
      end
    end
  else
    if (utils.isHover(80, 240, 320, 480) or utils.isHover(440, 240, 680, 480)) and button == 1 then
      local p = utils.isHover(80, 240, 320, 480) and "x" or "o"
      changeColor(p)
    end
  end
end

function love.draw()
  gui.setBackgroundStateGame(start)

  if start then
    --> Game
    board:draw()
    if winner ~= nil then
      love.graphics.setBackgroundColor(gui.colors.grey)
      local width = fonts[24]:getWidth(winner)
      local coords = utils.vec2((window.min * 0.5) - (width * 0.5), (window.max * 0.5) - 30)
      gui.print(fonts[24], winner, coords.min, coords.max)
      gui.print(fonts[16], string.format("Back to the menu: %.1fs", timer), coords.min - 10, coords.max + 40)
    end

    if players[players.current_player].isBot and winner == nil then
      aiPlay()
    end

  else
    gui.rectangle(50, 40, 670, 460)
    --> Settings
    gui.print(fonts[24], "Board", 345, 60)

    for i = 1, #modes do
      local name = string.format("%dx%d", modes[i], modes[i])
      if gui.button(fonts[16], name, 80 + (i * 120), 100, nil, nil, isSelected(modes[i] == mode)) then
        mode = modes[i]
      end
    end

    setPlayerDraw("x")
    setPlayerDraw("o")

    --> Game buttons
    gui.print(fonts[16], "Player X start first", window.min - 480, window.max - 60)
    if gui.button(fonts[24], "Play", window.min - 190, window.max - 80, 160, 60) then
      resetPlayGame()
      start = true
    end

    if gui.button(fonts[24], "Exit", 30, window.max - 80, 160, 60) then
      love.event.quit()
    end
  end
end

local waiting = 0
function love.update(dt)
  if winner ~= nil then
    timer = timer - dt
    if timer < 0.1 then
      resetPlayGame()
    end
  end
  if winner == nil and players[players.current_player].isBot then
    waiting = waiting + dt
  end
end

--> Helpful functions
function aiPlay()
  if waiting > 1.0 then
    local choice = ai.getBestChoice(board, players.current_player)
    board:setCell(choice, players.current_player)
    winner = board:getWinner(players.current_player)
    if winner == nil then
      waiting = 0
      changePlayer()
    end
  end
end

function isSelected(selected)
  return selected and gui.colors.white or gui.colors.grey
end

function setPlayerDraw(p)
  gui.print(fonts[24], "Player " .. string.upper(p), p == "x" and 160 or 520, 160)
  if gui.button(fonts[16], "Human", p == "x" and 80 or 440, 200, nil, nil, isSelected(not players[p].isBot)) then
    players[p].isBot = false
  end
  if gui.button(fonts[16], "Bot", p == "x" and 200 or 560, 200, nil, nil, isSelected(players[p].isBot)) then
    players[p].isBot = true
  end

  local c = clrs[players[p].color]
  gui.button(fonts[16], "", p == "x" and 80 or 440, 240, 240, 240, c, c, "fill", false)
end

function changeColor(p)
  local ignoreCol = p ~= "x" and players["x"].color or players["o"].color
  players[p].color = players[p].color + 1

  if players[p].color > 3 then
    players[p].color = 0
  end

  if players[p].color == ignoreCol then
    return changeColor(p)
  end

  return players[p].color
end

function changePlayer()
  players.current_player = players.current_player == "x" and "o" or "x"
end

function resetPlayGame()
  players.current_player = "x"
  winner = nil
  timer = 2.5
  board = board:new(mode, clrs[players["x"].color], clrs[players["o"].color])
  start = false
end