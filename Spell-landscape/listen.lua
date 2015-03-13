local widget = require "widget"
-------------
-- Listen.lua, for listening stage
------------
-- refactor: question, reading, listening
-- add sound player at wrong-answer scene

local nowVocaSound
local listenQuestion = {}
local playing_q_button
function recoverListenButton()
	print("recover listen")
	display.remove(playing_q_button)
	listenQuestion["q_button"].alpha = 1
end
function playVocaSound(event)
	if audio.isChannelActive(vocaSoundChannel) then
		return
	end
	isPlayingSound = true
	print("playsound")
	listenQuestion["q_button"].alpha = 0.1
	playing_q_button = widget.newButton
	{
		id = question_count,
		left = screencx-80,
		top = screenTop,
		defaultFile = "img/sound.png",
		overFile = "img/sound.png",
		width = 95,
		height = 100
	}
	nowSceneGroup:insert(playing_q_button)
	audio.play(nowVocaSound, {channel = vocaSoundChannel, onComplete = recoverListenButton})
end
function generate_new_question_listen(sceneGroup, levelName) 
	is_generate_question = true
	if sceneGroup ~= nil then
		nowSceneGroup = sceneGroup
	end

	local q_engligh, q_chinese = getNewQuestionInfo()
	if(q_engligh == nil) then -- no available question 
		return
	end
	
	local q_button = widget.newButton
	{
		onPress = playVocaSound,
		id = question_count,
		left = screencx-80,
		top = screenTop,
		defaultFile = "img/no_sound.png",
		overFile = "img/no_sound.png",
		width = 54,
		height = 100,
		alpha = 0
	}
	nowSceneGroup:insert(q_button)
	
	listenQuestion["eng"] = q_engligh
	listenQuestion["chi"] = q_chinese
	listenQuestion["q_button"] = q_button
	listenQuestion["question_count"] = question_count --id
	listenQuestion["solved"] = false
	listenQuestion["wrong_trial"] = 0
	listenQuestion["count_down"] = countDownTime
	
	fillHint(listenQuestion)
	
	questions[question_count] = listenQuestion
	q_button.alpha = 1
	
	print("pronounce/"  ..levelName  .. "/" .. listenQuestion["eng"] ..".mp3")
	nowVocaSound = audio.loadStream("pronounce/"  ..levelName  .. "/" .. listenQuestion["eng"] ..".mp3")
	playVocaSound()
	
	select_question(question_count)
	
	countDownText.text = listenQuestion["count_down"]
	countDownTimer = timer.performWithDelay(1000,countDown,countDownTime)
	
	is_generate_question = false
end
function countDown()
	if listenQuestion["count_down"] == nil then
		return
	end
	listenQuestion["count_down"] = listenQuestion["count_down"] - 1
	countDownText.text = listenQuestion["count_down"]
	if(listenQuestion["count_down"] == 0) then
		print("time up")
		question_failed(listenQuestion)
	end
end