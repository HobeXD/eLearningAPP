----------------------------------
-- for some common things to use in every level
----------------------------------
local composer = require "composer"

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

function read_file(filedst)
	local path = system.pathForFile(filedst)
	local file = io.open( path, "r" )
	local wordtable = {}
	local lin = file:read( "*l" )
	while lin ~= nil do
		for w,c in string.gmatch(lin, "(.+) (.+)") do
			--print(w, c)
			local word = {n=2}
			word[1] = string.lower(w)
			word[2] = c
			table.insert(wordtable, word)
		end
		lin = file:read( "*l" )
	end
	
	io.close( file )
	file = nil
	
	return wordtable
end

function pause() --disable all buttons(composer helps)
	print("pause")
	--timer.pause(question_timer)
	transition.pause()  -- pause all moving object
	pause_btn.alpha = 0;
	resume_btn.alpha = 1;
	composer.showOverlay( "pause" ,{effect = "fromBottom" , time = 300, params ={levelNum = "level01"}, isModal = true} )
	-- triggered twice = = http://forums.coronalabs.com/topic/43558-storyboard-firing-enterscene-event-twice-when-using-fade-effect-new-composer-class/
end
function resume()
	print("resume")
	--timer.resume(question_timer)
	transition.resume() 
	pause_btn.alpha = 1;
	resume_btn.alpha = 0;
	composer.hideOverlay("slideUp", 300)
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
	composer.removeScene("show_score", false)
	composer.gotoScene( "selectLevel", "slideUp", 500)
end
function go_home(event) --remove scene
	composer.removeScene("show_score", false)
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