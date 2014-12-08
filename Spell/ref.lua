The display object in the first display group in scene will be auto hide and show when the composer call hide() and show()

+=====================
With physics.pause() there will be a slight jitter in the physics object.
Another way is to capture the screen when paused and put it over the scene.
After that you put on top of the screen the paused screen GUI objects.
Remove the paused screen objects and the screen capture when resume.

local gameScene= display.newGroup()
local myObject1 = display.newRect(50,50,100,150 )
gameScene:insert(myObject1)
function onPause(event)
    local screenCap = display.captureScreen(false) --dont save to album
    gameScene:insert(screenCap)
    --insert pause buttons and etc here
end
Runtime:addEventListener("touch",onPause)


===============

scene:createScene(event) is the same as
 
scene.createScene(scene, event)
 
The variable 'self' refers to the 'scene' object that is passed in automatically when using the colon operator (check out PiL for more information).
 
The 'view' property of 'self' is a display group created on the scene object.


=================



Overlays
Like Storyboard, Composer allows you to have one overlay scene. This is a scene that gets loaded on top of the active scene (the parent scene). An overlay scene is constructed like any other Composer scene and it receives the same core events as any other scene.

Because an overlay scene may not cover the entire screen, users may potentially interact with the parent scene underneath. To prevent this, set the isModal parameter to true in the options table of composer.showOverlay(). This prevents touch/tap events from passing through the overlay scene to the parent scene.