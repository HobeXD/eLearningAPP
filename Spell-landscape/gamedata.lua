-------------
-- gamedata.lua, for general game data
------------
local common = require "common"
local composer = require "composer"
-- todo: overwrite print() , when nil print "object is nil

function showScore(target, origv, value, duration)  
    local mt = {}
    function mt.__index(t, k)
        if k == 'score' then return t._score end
    end
    function mt.__newindex(t, k, value)
        if k == 'score' then
            t._score = value
            target.text = string.format('%d', value)
        end
    end

    local scoreTable = {_score = origv}
    setmetatable(scoreTable, mt)

    transition.to(scoreTable, {score = value, time = duration, transition = easing.inExpo})
end

gameData = {
	-- static
	FINISH_QUESTION_NUM = (debugMode and debugQuestionNum ) or 15,
	MAX_WRONG_QUESTION_NUM = 3, 
	EMPTY_CHAR_NUM = 5, -- at most input 5 characters
	-- variable
	question_score = 10,
	character_score = 1,
	penalty_score = 1,
	score = 0, 
	now_wrong_num = 0,
	now_solved_num = 0,
	nowLevelName = defaultCategory,
	nowGametype = defaultGametype
}
function gameData:reset()
	print("reset")
	self.question_score = 10
	self.character_score = 1
	self.penalty_score = 1
	self.score = 0
	self.now_wrong_num = 0
	self.now_solved_num = 0
	-- will not reset category and gametype??
	--self.nowLevelName = ""
	--self.nowGametype = ""
end

function gameData:setLevelName(levelName)
	self.nowLevelName = levelName
	self:print_category()
end
function gameData:setGametype(gametype)
	self.nowGametype = gametype
	self:print_gametype()
end

function gameData:isAllQuestionGenerated(question_count)
	return question_count > self.FINISH_QUESTION_NUM + self.MAX_WRONG_QUESTION_NUM
end
function gameData:getScore()
	return self.score
end
function gameData:isGameOver()
	return self.now_wrong_num >= self.MAX_WRONG_QUESTION_NUM
end
function gameData:isGameClear()
	return self.now_solved_num == self.FINISH_QUESTION_NUM
end
function gameData:updateProblemScore(isCorrect) -- also update solve and failed num
	if isCorrect then
		local origv = self.score
		self.score = self.score + self.question_score
		score_text.text = self.score
		self.now_solved_num = self.now_solved_num + 1
		showScore(score_text, origv, self.score, 500) 
	else 
		local origv = self.score
		self.score = self.score - self.question_score
		score_text.text = self.score
		self.now_wrong_num = self.now_wrong_num + 1
		showScore(score_text, origv, self.score, 500) 
	end
end
function gameData:updateScore(isCorrect)
	if isCorrect then
		self.penalty_score = 1 -- reset penalty score
		local origv = self.score
		self.score = self.score + self.character_score
		self.character_score = self.character_score + 1
		showScore(score_text, origv, self.score, 500) 
		--score_text.text = self.score
	else 
		self.character_score = 1
		local origv = self.score
		self.score = self.score - self.penalty_score
		self.penalty_score = self.penalty_score + 1
		showScore(score_text, origv, self.score, 500) 
		--score_text.text = self.score
	end
end

function gameData:finish_level(msg, nowLevelName)
	local pattern = "fromBottom"
	if gameData:getScore() > 0 then
		scoremsg = "You collect ".. gameData:getScore() .. " stars!"
		if gameData:isHighScore() then
			print("high score! : " .. gameData:getScore())
			gameData:updateRank()
			msg = msg .. " - High Score!"
		end
	else
		scoremsg = "You do not get any star..."
	end
	local option =
	{
		effect = pattern,
		time = 500,
		params = {
			msg = msg,
			scoremsg = scoremsg,
			score = gameData:getScore(), 
			star_scale = star_scale_rate
		}
	}
	composer.removeScene("level", false)
	composer.gotoScene("show_score", option)
end

function compare(a,b)
  return a[1] > b[1]
end
function gameData:isHighScore()
	self:print_category()
	self:print_gametype()
	local scoretable = gameData:loadScore(self.nowLevelName, self.nowGametype)
	if scoretable[#scoretable][1] > self.score then --not in high score
		return false
	end
	return true
end
function gameData:updateRank()
	local scoretable = gameData:loadScore(self.nowLevelName, self.nowGametype)
   --start update
   table.insert(scoretable, {self.score})
   table.sort(scoretable, compare) --sort again
   --�u�s����
   local path = system.pathForFile( "rank/" .. self.nowLevelName .. "-" .. self.nowGametype ..".txt")
   local file = io.open(path, "w")
   
   if ( file ) then
		local  writeLineNum = 5
	   if #scoretable < 5 then
		writeLineNum = #scoretable
	   end
	  for i = 1, writeLineNum do
		--file:write( scoretable[i][1] .. " " .. tostring( scoretable[i][2] ) .. "\n" )
		file:write( scoretable[i][1] .. "\n" )
	  end
      io.close( file )
	  print("update complete")
      return
   else
      print( "Error: could not read ", "/rank/" ..levelName..".txt", "." )
      return
   end
end

function gameData:print_category()
	if self.nowLevelName ~= nil then
		print("now category = " .. self.nowLevelName)
	else 
		print("no category!!!")
	end
end
function gameData:print_gametype()
	if self.nowGametype ~= nil then
		print("now gametype = " .. self.nowGametype)
	else 
		print("no gametype!!!")
	end
end
function gameData:loadScore(category, gametype)
	self:print_category()
	self:print_gametype()
	local path = system.pathForFile( "rank/" .. self.nowLevelName .. "-" .. self.nowGametype ..".txt")
	local file = io.open( path, "r" )
	if ( file ) then
	  local scoretable = {}
	  for i = 1, 5 do -- at most 5 high scores
		local lin = file:read( "*l" )
		if lin == nil then
			break
		end
		for s in string.gmatch(lin, "(.+)") do
			local score = tonumber(s)
			scoretable[i] = {score}
		end
	  end
	  io.close( file )
	  table.sort(scoretable, compare)
	  return scoretable
	else
	  print( "Error: could not read scores from ", "/rank/" ..category..".txt", "." )
	end
	return nil
end


