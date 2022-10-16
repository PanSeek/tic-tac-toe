local utils = require "utils"

function getBestChoice(board, player)
  local my_end = moveEndGame(board, player)
  if my_end ~= "random" then
    return my_end
  end

  local move = getBestMove(board, player)
  if move == "enemy" then
    return moveEndGame(board, getInversePlayer(player))
  end
  if move == "random" then
    return getRandom(board)
  end

  return move
end

function getBestMove(board, player)
  local end_move_inverse = moveEndGame(board, getInversePlayer(player))
  if end_move_inverse ~= "random" then
    return "enemy"
  end

  local t_str_h, t_str_v, str_dl, str_dr = board:getHorizontal(), board:getVertical(), board:getDiagonalL(), board:getDiagonalR()
  local mode = board:getSize()
  local bestMove = 0

  --> Check enemy cells and best move
  if utils.stringCount(str_dl, getInversePlayer(player)) == 0 and board:getEmptySide("dl")[1] ~= nil then
    bestMove = utils.stringCount(str_dl, player)
  end
  if utils.stringCount(str_dr, getInversePlayer(player)) == 0 and board:getEmptySide("dr")[1] ~= nil then
    local c = utils.stringCount(str_dr, player)
    if bestMove < c then bestMove = c end
  end

  for i = 1, mode do
    if utils.stringCount(t_str_h[i], getInversePlayer(player)) == 0 and board:getEmptySide("h")[i][1] ~= nil then
      local c = utils.stringCount(t_str_h[i], player)
      if bestMove < c then bestMove = c end
    end
    if utils.stringCount(t_str_v[i], getInversePlayer(player)) == 0 and board:getEmptySide("v")[i][1] ~= nil then
      local c = utils.stringCount(t_str_v[i], player)
      if bestMove < c then bestMove = c end
    end
  end

  --> Best move
  if bestMove == 0 then
    return "random"
  end

  if utils.stringCount(str_dl, player) == bestMove and board:getEmptySide("dl")[1] ~= nil then
    return board:getEmptySide("dl")[1]
  end
  if utils.stringCount(str_dr, player) == bestMove and board:getEmptySide("dr")[1] ~= nil then
    return board:getEmptySide("dr")[1]
  end

  for i = 1, mode do
    if utils.stringCount(t_str_h[i], player) == bestMove and board:getEmptySide("h")[i][1] ~= nil then
      return board:getEmptySide("h")[i][1]
    end
    if utils.stringCount(t_str_v[i], player) == bestMove and board:getEmptySide("v")[i][1] ~= nil then
      return board:getEmptySide("v")[i][1]
    end
  end
end

function moveEndGame(board, player)
  local t_str_h, t_str_v, str_dl, str_dr = board:getHorizontal(), board:getVertical(), board:getDiagonalL(), board:getDiagonalR()
  local mode = board:getSize()

  if utils.stringCount(str_dl, player) == mode - 1 and board:getEmptySide("dl")[1] ~= nil then
    return board:getEmptySide("dl")[1]
  end
  if utils.stringCount(str_dr, player) == mode - 1 and board:getEmptySide("dr")[1] ~= nil then
    return board:getEmptySide("dr")[1]
  end

  for i = 1, mode do
    if utils.stringCount(t_str_h[i], player) == mode - 1 and board:getEmptySide("h")[i][1] ~= nil then
      return board:getEmptySide("h")[i][1]
    end
    if utils.stringCount(t_str_v[i], player) == mode - 1 and board:getEmptySide("v")[i][1] ~= nil then
      return board:getEmptySide("v")[i][1]
    end
  end

  return "random"
end

function getInversePlayer(player)
  return player == "x" and "o" or "x"
end

function getRandom(board)
  local empty_cells = board:getEmpty()
  return empty_cells[math.random(#empty_cells)]
end

return {
  getBestChoice = getBestChoice
}