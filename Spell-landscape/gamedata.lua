-------------
-- gamedata.lua, for general game data
------------

gameData = {
	-- static
	FINISH_QUESTION_NUM = 15,
	MAX_WRONG_QUESTION_NUM = 3, 
	EMPTY_CHAR_NUM = 5, -- at most input 5 characters
	-- variable
	question_score = 10,
	char_score = 1,
	penalty_score = 1,
	score = 0, 
	now_wrong_num = 0,
	now_solved_num = 0
}
function gameData:reset()
	self.question_score = 10
	self.char_score = 1
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
		self.score = self.score + self.question_score
		score_text.text = self.score
		self.now_solved_num = self.now_solved_num + 1
	else 
		self.score = self.score - self.question_score
		score_text.text = self.score
		self.now_wrong_num = self.now_wrong_num + 1
	end
end
function gameData:updateScore(isCorrect)
	if isCorrect then
		self.penalty_score = 1 -- reset penalty score
		self.score = self.score + self.char_score
		self.char_score = self.char_score + 1
		score_text.text = self.score
	else 
		self.char_score = 1
		self.score = self.score - self.penalty_score
		self.penalty_score = self.penalty_score + 1
		score_text.text = self.score
	end
end
