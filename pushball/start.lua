module(..., package.seeall)


function new()
		local localGroup = display.newGroup()
		
local background = display.newImage("photo/ground.png")
localGroup:insert(background)

background:scale(display.contentWidth / background.contentWidth, display.contentHeight / background.contentHeight)
background.x = background.contentWidth / 2
background.y = background.contentHeight / 2

local compass = display.newImage("photo/compass.png")
localGroup:insert(compass)

compass.x = 160
compass.y = 560
local botton = display.newImage("photo/start00.png")
localGroup:insert(botton)
botton.x = 160
botton.y = 510

local t
local startOnce = 1

local function listener(event)
	compass.rotation = compass.rotation - 1
	if compass.rotation < 0 then compass.rotation = 360 end
	t = timer.performWithDelay( 1, listener )
end

t = timer.performWithDelay( 1, listener )
-------------------------
local musicIcon1 = display.newImage("photo/music on.png")
localGroup:insert(musicIcon1)
musicIcon1.x = 260
musicIcon1.y = 520

local musicIcon2 = display.newImage("photo/music off.png")
localGroup:insert(musicIcon2)
musicIcon2.x = 260
musicIcon2.y = 520
musicIcon2.isVisible = false

function updateIcon()
	show = getMusic()
	if show == 1 then
		musicIcon1.isVisible = true
		musicIcon2.isVisible = false
	else
		musicIcon1.isVisible = false
		musicIcon2.isVisible = true
	end
end
updateIcon()


local nameBlock = display.newImage("photo/nameBlock.png")
localGroup:insert(nameBlock)
nameBlock.x = 160
nameBlock.y = 450
	
--local botton = display.newRect( display.contentWidth * 0.35, display.contentHeight * 0.6,
--								display.contentWidth * 0.3, display.contentHeight * 0.15)

local defaultField
local getname = name
local text = display.newText(getname, 0, 0, nil, 15)
localGroup:insert(text)
text.x = 218
text.y = 453
text:setTextColor(0,0,0)

local function fieldHandler( getObj )
	
	return function( event )
		if ( "began" == event.phase ) then
				-- This is the "keyboard has appeared" event
				defaultField.text = ""
		elseif ( "ended" == event.phase ) then
				-- This event is called when the user stops editing a field:
				-- for example, when they touch a different field or keyboard focus goes away
				getname = getObj().text
				text.text = getname
		elseif ( "submitted" == event.phase ) then
				-- This event occurs when the user presses the "return" key
				-- (if available) on the onscreen keyboard
				getname = getObj().text
				text.text = getname
				defaultField.isVisible = false
				-- Hide keyboard
				native.setKeyboardFocus( nil )
		else
				getname = getObj().text
				text.text = getname
		end
	end
		
end     -- "return function()"
 
-- Create our Text Field

defaultField = native.newTextField( 20, 120, 280, 40, fieldHandler( function() return defaultField end ) )
localGroup:insert(defaultField)
defaultField.isVisible = false

local function waitStart (event)
	director:changeScene ("menu")
end

local function gamestart (event)
	if event.phase == "ended" and startOnce == 1 then
		startOnce = 0
		chname(getname)
		saveSys()
		load() 
		local botton2 = display.newImage("photo/start01.png")
		localGroup:insert(botton2)
		botton2.x = botton.x
		botton2.y = botton.y
		timer.cancel( t )
		timer.performWithDelay( 100, waitStart )
	--director:changeScene ("menu")
	end
end

local function chmusic (event)
	if event.phase == "ended" then
		chMusic()
		updateIcon()
	end
end

local function pos(event)
	print(event.x.." "..event.y)
	if event.phase == "ended" then
		local x = event.x
		local y = event.y
		if x >= 175 and x <= 275 and y >= 440 and y <= 460 then
			defaultField.text = "texting your name here"
			defaultField.isVisible = true
		end
	end
end

botton:addEventListener ("touch", gamestart)
background:addEventListener ("touch", pos)
musicIcon1:addEventListener ("touch", chmusic)
musicIcon2:addEventListener ("touch", chmusic)

------------Rank--------------
local rankBotton = display.newImage("photo/prize.png")
localGroup:insert(rankBotton)
rankBotton.x = 40
rankBotton.y = 410
local rankBotton2 = display.newImage("photo/prize01.png")
localGroup:insert(rankBotton2)
rankBotton2.x = rankBotton.x
rankBotton2.y = rankBotton.y
rankBotton:toFront()
local netError = display.newText("Network error!!", 0,0,native.systemFontBold,40)
localGroup:insert(netError)
netError.x = -150
netError.y = 280
netError:setTextColor(255, 255, 255)

local errorListener = function(obj)
	netError.x = -150
end

function rankGot( event )
	if ( event.isError ) then
        print( "Network error!")
		startOnce = 1
		rankBotton:toFront()
		netError.x = -150
		transition.to( netError, { time=3000, x=470, onComplete=errorListener} )
		t = timer.performWithDelay( 1, listener )
    else
		print ( "RESPONSE2: " .. event.response )
		print("?")
		chRank(event.response)
		director:changeScene ("rank", event.responce)
	end
end

local function rank (event)
	if event.phase == "ended" and startOnce == 1 then
		startOnce = 0
		chname(getname)
		saveSys()
		load() 
		rankBotton2:toFront()
		timer.cancel( t )
		print(network.request( "http://web.ntnu.edu.tw/~699210745/app/rank.php", "GET", rankGot))
	--director:changeScene ("menu")
	end
end

rankBotton:addEventListener ("touch", rank)



		return localGroup

end