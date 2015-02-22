-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()
--physics.setDrawMode("hybrid")
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- create a grey rectangle as the backdrop
	local background = display.newImageRect( "images/background.png", 960, 640 )
	background.anchorX = 0
	background.anchorY = 0

	
	-- make a crate (off-screen), position it, and rotate slightly
	-- local crate = display.newImageRect( "images/crate.png", 90, 90 )
	-- crate.x, crate.y = 160, -100
	-- crate.rotation = 15
	
	-- -- add physics to the crate
	-- physics.addBody( crate, { density=1.0, friction=0.3, bounce=0.3 } )
	
	-- create a grass object and add physics (with custom shape)
	-- local grass = display.newImageRect( "images/grass.png", screenW, 82 )
	-- grass.anchorX = 0
	-- grass.anchorY = 1
	-- grass.x, grass.y = 0, display.contentHeight

	local commandCenter = display.newImageRect('images/command.png', 170, 144)
	commandCenter.x, commandCenter.y = 100, 300
	physics.addBody(commandCenter, 'static', {radius = 70, density = 1.0})


local sheetData = { width=109, height = 129, numFrames =7}

local imageSheet = graphics.newImageSheet ( "images/soldiers.png", sheetData )

local sequenceData = { { name = "run", start =1, count =7, time = 650 }}



local spawnTimer
local spawnedUnits = {}

local spawnParams = {
	xMin = 100,
	xMax = 150,
	yMin = 100,
	yMax = 550,
	spawnTime = 400,
	spawnOnTimer = 5,
	spawnInitial = 0
}

--spawn an item
local function spawnUnit(bounds)

	 --create soldier unit
	local soldier = display.newSprite( imageSheet, sequenceData )
	soldier.x = math.random( bounds.xMin, bounds.xMax)
	soldier.y = math.random( bounds.yMin, bounds.yMax)

	--add soldier to spawnedUnits table for tracking purposes
	spawnedUnits[#spawnedUnits+1] = soldier
	-- soldier.x = 100
	-- soldier.y = display.contentHeight - 100
	physics.addBody( soldier, "static" )
	soldier:setSequence("run")
	soldier:play()
	      transition.to( soldier, { time=10000, x = 900});

end

-- Spawn Controller
local function spawnController(action, params)
	-- cancel timer on "start" or "stop"
	if(spawnTimer and (action == "start" or action == "stop")) then
		timer.cancel(spawnTimer)
	end

	-- Start spawning
	if ( action == "start" ) then
    -- gather/set spawning bounds
    local spawnBounds = {}
    spawnBounds.xMin = params.xMin or 0
    spawnBounds.xMax = params.xMax or display.contentWidth
    spawnBounds.yMin = params.yMin or 0
    spawnBounds.yMax = params.yMax or display.contentHeight
    -- gather/set other spawning params
    local spawnTime = params.spawnTime or 1000
    local spawnOnTimer = params.spawnOnTimer or 50
    local spawnInitial = params.spawnInitial or 0

    --if spawnInitial > 0, spawn n item(s) instantly
    if (spawnInitial > 0 ) then
    	for n = 1, spawnInitial do
    		spawnUnit(spawnBounds)
    	end
    end

    -- start repeating timer to spawn items
    if ( spawnOnTimer > 0 ) then
      spawnTimer = timer.performWithDelay( spawnTime,
        function() spawnUnit( spawnBounds );end,
      spawnOnTimer )
    end

    -- Pause spawning
    elseif ( action == "pause" ) then
        timer.pause( spawnTimer )
    -- Resume spawning
    elseif ( action == "resume" ) then
        timer.resume( spawnTimer )
    end

end

spawnController("start", spawnParams)

-- local function spawnUnit ()
-- 	local soldier = display.newSprite( imageSheet, sequenceData )
-- 	soldier.x = 100
-- 	soldier.y = display.contentHeight - 100
-- 	physics.addBody( soldier, { density=10.0, radius = 62, friction=10.5 } )
-- 	soldier:setSequence("run")
-- 	soldier:play()
-- end
-- timer.performWithDelay( 2000, spawnUnit, 2 )
-- transition.to( soldier, { time=10000, x = 1000})

	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	-- local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	-- physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	group:insert( background )
	--group:insert( grass)
	group:insert(commandCenter)
	-- group:insert( crate )
	--group:insert( soldier )
end



-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene