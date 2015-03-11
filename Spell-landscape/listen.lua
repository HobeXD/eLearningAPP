local widget = require "widget"
-------------
-- Listen.lua, for listening stage
------------
-- deal with pause
-- destory timer.delay...


local nowVocaSound
local listenQuestion
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
		width = 100,
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

	local q_engligh, q_chinese = getNewQuestion()
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
		width = 80,
		height = 100,
		alpha = 0
	}
	nowSceneGroup:insert(q_button)
	
	local question = {} -- include data about a question
	question["eng"] = q_engligh
	question["chi"] = q_chinese
	question["q_button"] = q_button
	question["question_count"] = question_count --id
	question["solved"] = false
	question["wrong_trial"] = 0
	question["count_down"] = countDownTime
	
	fillHint(question)
	
	questions[question_count] = question
	q_button.alpha = 1
	listenQuestion = question
	
	print("pronounce/"  ..levelName  .. "/" .. question["eng"] ..".mp3")
	nowVocaSound = audio.loadStream("pronounce/"  ..levelName  .. "/" .. question["eng"] ..".mp3")
	playVocaSound()
	
	
	is_generate_question = false
end
function countDown()
	listenQuestion["count_down"] = listenQuestion["count_down"] - 1
	if(listenQuestion["count_down"] == 0) then
		print("time up")
	else 
		print("countdown")
		countDownText.text = listenQuestion["count_down"]
	end
end