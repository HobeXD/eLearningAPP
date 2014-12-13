module(..., package.seeall)

--====================================================================--	
-- DIRECTOR CLASS
--====================================================================--
--
-- Version: 1.1
-- Made by Ricardo Rauber Pereira @ 2010
-- Blog: http://rauberlabs.blogspot.com/
-- Mail: ricardorauber@gmail.com
--
-- This class is free to use, feel free to change but please send new versions
-- or new features like new effects to me and help us to make it better!
--
--====================================================================--	
-- CHANGES
--====================================================================--
--
-- 06-OCT-2010 - Ricardo Rauber - Created
-- 07-OCT-2010 - Ricardo Rauber - Functions loadScene and fxEnded were
--                                taken off from the changeScene function;
--                                Added function cleanGroups for best
--                                memory clean up;
--                                Added directorView and effectView groups
--                                for better and easier control;
--                                Please see INFORMATION to know how to use it
--
--====================================================================--
-- VARIABLES
--====================================================================--
--
-- currentView: 	Main display group
-- nextView:		Display group for transitions
-- currentScreen:	Active module
-- nextScreen:		New module
-- lastScene:		Active module in string for control
-- nextScene:		New module in string for control
-- effect:		Transition type
-- arg[N]:		Arguments for each transition
-- fxTime:		Time for transition.to
--
--====================================================================--
-- INFORMATION
--====================================================================--
--
-- * For best practices, use fps=60, scale = "zoomStretch" on config.lua
--
-- * In main.lua file, you have to import the class like this:
--
--   director = require("director")
--   local g = display.newGroup()	
--	 g:insert(director.directorView)
--
-- * To change scenes, use this command [use the effect of your choice]
--
--   director:changeScene("settings","moveFromLeft")
--
-- * Every scene is a lua module file and must have a new() function that
--   must return a local display group, like this: [see template.lua]
--
--   module(..., package.seeall)
--   function new()
--	   local lg = display.newGroup()
--     ------ Your code here ------
--     return lg
--   end
--
-- * Every display object must be inserted on the local display group
--
--   local background = display.newImage("background.png")
--	 lg:insert(background)
--
-- * This class doesn't clean timers! If you want to stop timers when
--   change scenes, you'll have to do it manually.
--
--====================================================================--

directorView = display.newGroup()
currentView  = display.newGroup()
nextView     = display.newGroup()
effectView   = display.newGroup()
--
local currentScreen, nextScreen
local lastScene = "main"
local fxTime = 200
--
directorView:insert(currentView)
directorView:insert(nextView)
directorView:insert(effectView)

------------------------------------------------------------------------	
-- CLEAN GROUP
------------------------------------------------------------------------

local function cleanGroups ( curGroup, level )
	if curGroup.numChildren then
		while curGroup.numChildren > 0 do
			cleanGroups ( curGroup[curGroup.numChildren], level+1 )
		end
		if level > 0 then
			curGroup:removeSelf()
		end
	else
		curGroup:removeSelf()
		curGroup = nil
		return
	end
end

------------------------------------------------------------------------	
-- LOAD SCENE
------------------------------------------------------------------------

local function loadScene ( nextScene, arg)

	nextScreen = require(nextScene).new(arg)
	nextView:insert(nextScreen)
	
end

------------------------------------------------------------------------	
-- EFFECT ENDED
------------------------------------------------------------------------

local function fxEnded ( event )

	currentView.x = 0
	currentView.y = 0
	currentView.xScale = 1
	currentView.yScale = 1
	--
	cleanGroups(currentView,0)
	--
	currentScreen = nextScreen
	currentView:insert(currentScreen)
	nextView.x = display.contentWidth
	nextView.y = 0
	nextView.xScale = 1
	nextView.yScale = 1
	
end

------------------------------------------------------------------------	
-- CHANGE SCENE
------------------------------------------------------------------------

function director:changeScene(nextScene, 
                              arg)


	-----------------------------------
	-- If is the same, don't change
	-----------------------------------
	if lastScene then
		if string.lower(lastScene) == string.lower(nextScene) then
			--return true
		end
	end
	
	timer.performWithDelay( 0, fxEnded )
	loadScene (nextScene, arg)
	
	-----------------------------------
	-- Clean up memory
	-----------------------------------
	
	if lastScene then
		package.loaded[lastScene] = nil
	end
	lastScene = nextScene
	collectgarbage("collect")
	
	return true
end