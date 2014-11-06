module(..., package.seeall)

function new()
		local localGroup = display.newGroup()
local background = display.newImage("photo/"..stageNumStage.."/stage.png")
localGroup:insert(background)

background:scale(display.contentHeight / background.contentWidth, display.contentWidth / background.contentHeight)
background.x = background.contentHeight / 2
background.y = background.contentWidth / 2
background.rotation = 90

local sound = getMusic()
if sound == 1 then
	media.playEventSound( lostSound )
end

local retry = display.newImage("photo/lost.png")
localGroup:insert(retry)

retry:scale(display.contentHeight / retry.contentWidth, display.contentWidth / retry.contentHeight)
retry.x = retry.contentHeight / 2
retry.y = retry.contentWidth / 2
retry.rotation = 90

local function retryEvent (event)
	if event.phase == "ended" then
		local x = event.x
		local y = event.y
		if x >= 125 and x <= 169 and y >= 203 and y <= 246 then
			director:changeScene ("game")
		elseif x >= 125 and x <= 168 and y >= 317 and y <= 360 then
			director:changeScene ("stageMenu", stageNumStage)
		end
	end
end
retry:addEventListener ("touch", retryEvent)
	
		return localGroup

end