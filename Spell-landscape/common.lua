----------------------------------
-- for some common things to use in every level
----------------------------------
local composer = require "composer"

debugMode = 1
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
function pause_with_ans(c, e)
	print("pause ans")
	--timer.pause(question_timer)
	transition.pause()  -- pause all moving object
	pause_btn.alpha = 0;
	resume_btn.alpha = 1;
	composer.showOverlay( "pause" ,{effect = "flipFadeOutIn" , time = 300, params ={mode = "show", chinese = c, english = e}, isModal = false} )
end
function pause() --disable all buttons(composer helps)
	print("pause")
	if countDownTimer ~= nil then
		timer.pause(countDownTimer)
	end
	transition.pause()  -- pause all moving object
	pause_btn.alpha = 0;
	resume_btn.alpha = 1;
	composer.showOverlay( "pause" ,{effect = "fromBottom" , time = 300, params ={mode = "pause"}, isModal = true} )
	-- triggered twice = = http://forums.coronalabs.com/topic/43558-storyboard-firing-enterscene-event-twice-when-using-fade-effect-new-composer-class/
end
function resume()
	print("resume")
	if countDownTimer ~= nil then
		timer.resume(countDownTimer)
	end
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

function go_select_level(event)
	--composer.removeScene("show_score", true)
	composer.gotoScene( "selectLevel", "slideUp", 500)
end
function go_home(event) --remove scene
	composer.removeScene("show_score", false)
	resume()
	finish_level("")
end
function finish_level(msg)
	local pattern
	if msg == "" then
		pattern = "slideUp"
		composer.removeScene("level", false)
		composer.gotoScene( "menu", pattern, 500)
	else
		pattern = "fromBottom"
		--native.showAlert( msg, "Your Score: ".. score)
		if score > 0 then
			scoremsg = "You collect ".. score .. " stars!"
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
				score = score, 
				star_scale = star_scale_rate
			}
		}
		composer.removeScene("level", false)
		composer.gotoScene( "show_score", option)
	end
end

function handle_back_key() -- so many exception situation
	local current_scene = composer.getSceneName("current")
	if current_scene == "level" then --now in level
		print("current scene is level")
		pause_with_exit()		
	elseif current_scene == "show_score" or current_scene == "menu" then -- do nothing
		return false
	else
		composer.gotoScene(composer.getSceneName( "previous"), "slideDown", 500)
	end
	return true
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
    -- This lets the operating system execute its default handling of the key
    return false
end
function quit_game() -- can only used in android
	native.requestExit() 
end
