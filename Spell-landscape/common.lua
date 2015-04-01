----------------------------------
-- for some common things to use in every level
----------------------------------
local composer = require "composer"

debugMode = false
debugQuestionNum = 1
SUCCESS = true
FAILED = false

screenTop = display.screenOriginY
screenBottom = display.viewableContentHeight + display.screenOriginY
screenLeft = display.screenOriginX
screenRight = display.viewableContentWidth + display.screenOriginX
screenH = display.actualContentHeight
screenW = display.actualContentWidth
screencx = display.contentCenterX
screency = display.contentCenterY
barH = 105
barh = 40

mainBGMChannel = 1
vocaSoundChannel = 2
winLoseSoundChannel = 3

categoryStr = {"School", "Personal Characteristics", "Transportation", "Places and Locations", "Time"}
defaultCategory = categoryStr[1]
gametypeStr = {"Reading", "Listening"}
defaultGametype = gametypeStr[1]

defaultPattern = "slideUp"
softTransition = "fade"
backEffect = "slideDown"

function createBackground(sceneGroup)
	local background = display.newImageRect( "img/star_bg.jpg", display.contentWidth, display.contentHeight )
	background.x, background.y = 0, 0; 	background.anchorX = 0; background.anchorY = 0
	sceneGroup:insert( background )
end

function read_file(filedst)
	local path = system.pathForFile(filedst)
	local file = io.open( path, "r" )
	local wordtable = {}
	local lin = file:read( "*l" )
	while lin ~= nil do
		for w,c in string.gmatch(lin, "(.+) (.+)") do
			--print(w, c)
			local word = {n=2}
			--word[1] = string.lower(w)
			word[1] = w
			word[2] = c
			table.insert(wordtable, word)
		end
		lin = file:read( "*l" )
	end
	
	io.close( file )
	file = nil
	
	return wordtable
end

function check_pause() 
	if ispause then
		return true
	else
		return false
	end
end
function pause_with_exit()
	print("pause exit")
	--timer.pause(question_timer)
	transition.pause()  -- pause all moving object
	pause_btn.alpha = 0;
	resume_btn.alpha = 1;
	composer.showOverlay( "pause" ,{effect = "flipFadeOutIn" , time = 300, params ={mode = "back"}, isModal = true} ) --change effect
end
function pause_with_ans(c, e, nowLevelName)
	print("pause ans")
	--timer.pause(question_timer)
	transition.pause()  -- pause all moving object
	pause_btn.alpha = 0;
	resume_btn.alpha = 1;
	local pause_params = {
		mode = "show",
		chinese = c,
		english = e,
		level = nowLevelName
	}
	composer.showOverlay( "pause" ,{effect = "flipFadeOutIn" , time = 300, params = pause_params, isModal = false} )
end
function pause() --disable all buttons(composer helps)
	print("pause")
	audio.pause(vocaSoundChannel)
	transition.pause()  -- pause all moving object
	pause_btn.alpha = 0;
	resume_btn.alpha = 1;
	composer.showOverlay( "pause" ,{effect = "fromBottom" , time = 300, params ={mode = "pause"}, isModal = true} )
	-- triggered twice = = http://forums.coronalabs.com/topic/43558-storyboard-firing-enterscene-event-twice-when-using-fade-effect-new-composer-class/
end
function resume()
	print("resume")
	audio.resume(vocaSoundChannel)
	transition.resume() 
	pause_btn.alpha = 1;
	resume_btn.alpha = 0;
	composer.hideOverlay("slideUp", 300)
end
function resume_quiet()
	print("resume")
	--timer.resume(question_timer)
	transition.resume() 
	pause_btn.alpha = 1;
	resume_btn.alpha = 0;
	composer.hideOverlay()
end
function resume_trans()
	transition.resume() 
end

local alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUWXYZ'
function isalpha(ch)	
	local is_alpha = false
	for i = 1, #alphabet do
		if alphabet:sub(i, i) == ch then
			is_alpha = true
			break
		end
	end
	return is_alpha
end
-- ref: http://forums.coronalabs.com/topic/17277-create-a-shake-effect-on-a-object/
function doShake(target, onCompleteDo)
	local thirdTran = function()
		if target.shakeType == "Loop" then
			transition.to(target, {transition = inOutExpo, time = 100, rotation = 0, onComplete = firstTran})
		else
			transition.to(target, {transition = inOutExpo, time = 100, rotation = 0, onComplete = onCompleteDo})
		end
	end
	local secondTran = function()
		transition.to(target, {transition = inOutExpo, time = 100, rotation = -15, onComplete = thirdTran})
	end
	local firstTran = function()
		transition.to(target, {transition = inOutExpo, time = 100, rotation = 15, onComplete = secondTran})
	end

	--Do the first transition
	firstTran()
end 

function go_select_gametype(event)
	--composer.removeScene("show_score", true)
	local options = {
		effect = "slideUp",
		time = 500,
		params = {}
	}
	composer.gotoScene( "select_gametype", options)
end
function go_home(event) --remove scene
	composer.removeScene("show_score", false)
	resume()
	pattern = "slideUp"
	composer.removeScene("level", false)
	composer.gotoScene( "menu", pattern, 500)
end


--sceneStr = {"menu", "select_gametype", "selectLevel", "level", "show_score"} -- normal playing 
function handle_back_key() -- so many exception situation
	local current_scene = composer.getSceneName("current")
	if current_scene == "menu" or current_scene == "show_score" then -- do nothing
		return false
	elseif current_scene == "select_gametype" or current_scene == "selectLevel"  then --now in level
		if composer.getSceneName("previous") == "show_rank" then
			composer.gotoScene(composer.getSceneName("previous"), softTransition, 500)
		else
			returnToMenu()
		end
	elseif current_scene == "level" then --now in level
		if ispause then
			return false
		else 
			pause_with_exit()		
		end
	elseif current_scene == "show_rank" then
		returnToMenu()
	else
		composer.gotoScene(composer.getSceneName("previous"), backEffect, 500)
	end
	return true
end
function returnToMenu() 
	composer.gotoScene("menu", backEffect, 500)
end
function handle_system_key(event)
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )

	if event.phase == "down" then
		-- http://forums.coronalabs.com/topic/35792-is-there-a-way-to-simulate-a-back-button-press-in-simulator/
		if ( (event.keyName == "back" and system.getInfo( "platformName" ) == "Android") or (event.keyName == "b" and system.getInfo("environment") == "simulator")) then
			return handle_back_key()
		end
	end
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    return false
end
function quit_game() -- can only used in android
	native.requestExit() 
end

function init_score() -- only used before building

end
