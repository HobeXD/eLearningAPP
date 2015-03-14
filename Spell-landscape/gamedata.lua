-------------
-- gamedata.lua, for shared game data
------------

gameData = {
	question_score = 10,
	char_score = 1,
	penalty_score = 1,
	now_wrong_num = 0
}
function gameData:reset()
	self.question_score = 10
	self.char_score = 1
	self.penalty_score = 1
	self.now_wrong_num = 0
end
function gameData:updateWrong()
	self.now_wrong_num = self.now_wrong_num + 1
end
function gameData:isGameOver()
	return self.now_wrong_num >= max_wrong_question_num
end
function gameData:updateProblemScore(isCorrect)
	if isCorrect then
		score = score + self.question_score
		score_text.text = score
	else 
		score = score - self.question_score
		score_text.text = score
		gameData:updateWrong()
	end
end
function gameData:updateScore(isCorrect)
	if isCorrect then
		self.penalty_score = 1 -- reset penalty score
		score = score + self.char_score
		self.char_score = self.char_score + 1
		score_text.text = score
	else 
		self.char_score = 1
		score = score - self.penalty_score
		self.penalty_score = self.penalty_score + 1
		score_text.text = score
	end
end
