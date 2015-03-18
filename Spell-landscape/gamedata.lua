-------------
-- gamedata.lua, for general game data
------------
local debugQuestionNum = 1

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
	now_solved_num = 0
}
function gameData:reset()
	print("reset")
	self.question_score = 10
	self.character_score = 1
	self.penalty_score = 1
	self.score = 0
	self.now_wrong_num = 0
	self.now_solved_num = 0
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

function compare(a,b)
  return a[2] > b[2]
end
function gameData:isHighScore(levelName)
	local scoretable = gameData:load(levelName)
	if scoretable[#scoretable][2] > self.score then --not in high score
		return false
	end
	return true
end
function gameData:update(levelName, name)
	local scoretable = gameData:load(levelName)
   --start update
   table.insert(scoretable, {name, self.score})
   table.sort(scoretable, compare)
   --sort
   --只存五個
   local path = system.pathForFile( "/rank/" ..levelName..".txt")
   local file = io.open(path, "w")
   if ( file ) then
	  for i = 1, (#scoretable or 5) do
		local contents = scoretable[i][1] .. " " .. tostring( scoretable[i][2] ) .. "\n"
		file:write( contents )
	  end
      io.close( file )
	  print("update complete")
      return
   else
      print( "Error: could not read ", "/rank/" ..levelName..".txt", "." )
      return
   end
end
function gameData:load(levelName)
	local path = system.pathForFile( "/rank/" ..levelName..".txt")
	local file = io.open( path, "r" )
	if ( file ) then
	  local scoretable = {}
	  for i = 1, 5 do -- at most 5 high scores
		local lin = file:read( "*l" )
		if lin == nil then
			break
		end
		for n, s in string.gmatch(lin, "(.+) (.+)") do
			local score = tonumber(s)
			scoretable[i] = {n, score}
		end
	  end
	  io.close( file )
	  return scoretable
	else
	  print( "Error: could not read scores from ", "/rank/" ..levelName..".txt", "." )
	end
	return nil
end


