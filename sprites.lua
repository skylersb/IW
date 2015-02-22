
display.setStatusBar(display.HiddenStatusBar)

centerX = display.contentWidth * .5
centerY = display.contentHeight * .5

local sheetData = { width=109, height = 129, numFrames =7}

local imageSheet = graphics.newImageSheet ( "/images/soldiers.png", sheetData )

local sequenceData = { { name = "run", start =1, count =7, time = 650 }}

local soldier = display.newSprite( imageSheet, sequenceData )
soldier.x = -200
soldier.y = display.contentHeight - 100
soldier:setSequence("run")
soldier:play()

transition.to( soldier, { time=5000, x = 1000})