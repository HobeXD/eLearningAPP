-- swipe library
 
--[[ Libraries ]]--
 
local composer = require("composer")
 
--[[ Fields ]]--
 
local mainstage = display.getCurrentStage()
local stage = composer.stage
local stagewrap = display.newGroup()
 
local touchpanel = display.newRect( display.actualContentWidth*.05, display.contentCenterY, display.actualContentWidth*.2, display.contentHeight )
touchpanel.fill = {0,0,0}
touchpanel.isHitTestable = true
touchpanel.alpha = 0
if (composer.isDebug) then
	touchpanel.alpha = .1
end
 
stagewrap:insert( stage )
stagewrap:insert( touchpanel )
 
composer.backSwipeActive = true
 
--[[ Extensions ]]--
 
composer.getCurrentScene = function()
	return composer.getScene( composer.getSceneName( "current" ) )
end
 
composer.getPreviousScene = function()
	return composer.getScene( composer.getSceneName( "previous" ) )
end
 
composer.getOverlayScene = function()
	return composer.getScene( composer.getSceneName( "overlay" ) )
end
 
composer.setPreviousScene = function( sceneName )
	composer._previousScene = sceneName
end
 
--[[ Overrides ]]--
 
local gotoscene = composer.gotoScene
composer.gotoScene = function( sceneName, options )
	composer.backSwipeActive = (options.isBackSwipe or false) and stage.numChildren > 0
	touchpanel.isVisible = composer.backSwipeActive
	
	if (sceneName == composer.getSceneName( "previous" )) then
		local previousview = composer.getPreviousScene().view
		composer.effectList[ options.effect ].to.xStart = previousview.x
	end
	
	gotoscene( sceneName, options )
end
 
--[[ Navigation ]]--
 
local function prepareBack()
	local previous, current = composer.getPreviousScene().view, composer.getCurrentScene().view
	
	previous.alpha = 1
	previous.isVisible = true
	previous:toFront()
	
	current.alpha = 1
	current.isVisible = true
	current:toFront()
end
 
local function touch(e)
	local view = stage[ stage.numChildren ]
	local under = stage[ stage.numChildren-1 ]
	
	if (composer.backSwipeActive) then
		if (e.phase == "began") then
			e.target.hasFocus = true
			mainstage:setFocus( e.target )
			e.target.prev = e
			prepareBack()
			composer.getCurrentScene():dispatchEvent{ name="swipe", phase="began" }
			return true
		elseif (e.target.hasFocus) then
			if (e.phase == "moved") then
				view.x = view.x + (e.x - e.target.prev.x)
				if (view.x < 0) then
					view.x = 0
				end
				under.x = -(display.actualContentWidth * .3) + (display.actualContentWidth * .3 * (view.x / display.actualContentWidth))
				e.target.prev = e
				composer.getCurrentScene():dispatchEvent{ name="swipe", phase="moved" }
			else
				e.target.hasFocus = false
				mainstage:setFocus( nil )
				e.target.prev = nil
				
				if (view.x < display.actualContentWidth*.3) then
					transition.to( view, { time=250, x=0, onComplete=function()
						composer.getCurrentScene():dispatchEvent{ name="swipe", phase="cancelled" }
					end } )
				else
					composer.getCurrentScene():dispatchEvent{ name="swipe", phase="ended" }
				end
			end
			return true
		end
		
		return false
	else
		return false
	end
end
touchpanel:addEventListener( "touch", touch )
 
--[[ Effects ]]--
 
composer.effectList["iosSlideLeft"] = {
	sceneAbove = true,
	concurrent = true,
	to = {
		xStart     = display.actualContentWidth,
		yStart     = 0,
		xEnd       = 0,
		yEnd       = 0,
		transition = easing.outQuad
	},
	from = {
		xStart     = 0,
		yStart     = 0,
		xEnd       = -display.actualContentWidth * 0.3,
		yEnd       = 0,
		transition = easing.outQuad
	}
}
 
composer.effectList["iosSlideRight"] = {
	sceneAbove = false,
	concurrent = true,
	to = {
		xStart     = -display.actualContentWidth * 0.3,
		yStart     = 0,
		xEnd       = 0,
		yEnd       = 0,
		transition = easing.outQuad
	},
	from = {
		xStart     = 0,
		yStart     = 0,
		xEnd       = display.actualContentWidth,
		yEnd       = 0,
		transition = easing.outQuad
	}
}