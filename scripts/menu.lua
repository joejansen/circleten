-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"
local utilities = require ("scripts.utilities")


--------------------------------------------

-- forward declarations and other locals


-- 'onRelease' event listener 
local function onPlayBtnRelease()
	
	timer.performWithDelay(300,goToLevelSelect)
	
	return true	-- indicates successful touch
end

function onShareRelease()
	system.openURL("mailto:who@email.com?subject=Try%20circleTEN&body=Check%20out%20this%20math%20game:%20www.jonaapps.com/circleten.html")
end

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
	utilities.loadSavedItems()
	utilities.ifBlankSetDefaultSavedItems()
	utilities.saveSavedItems()
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	local logo = loadMenuStage()
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	clearMenuStage()

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)


	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
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



-------------------------------------------------------------------
----CREATE MENU ITEMS
-----------------------------------------------------------

function loadMenuItems()

		local btnSpacingX = -25
		local btnSpacingY = 50
		local fadeTime = 250
		local delayTime = 250
		local btn1x = 370
		local btn2x = btn1x + 1*btnSpacingX
		local btn3x = btn1x + 2*btnSpacingX
		local btn4x = btn1x + 3*btnSpacingX
		local btn5x = btn1x + 4*btnSpacingX
	
		playBtn = widget.newButton{
			defaultFile="images/menuPlayBtn.png",
			overFile="images/menuPlayBtnOver.png",
			width = 375,
			height = 33,
			onRelease = onPlayBtnRelease
		}
		playBtn:setReferencePoint( display.TopLeftReferencePoint )
		playBtn.x = 540
		playBtn.y =55

		menuInstBtn = widget.newButton{
			defaultFile="images/menuInstBtn.png",
			overFile="images/menuInstBtnOver.png",
			width = 375,
			height = 33,
			onRelease = goToInstructions
		}
		menuInstBtn:setReferencePoint( display.TopLeftReferencePoint )
		menuInstBtn.x = 540
		menuInstBtn.y = playBtn.y + 1*btnSpacingY	
	
		rateBtn = widget.newButton{
			defaultFile="images/rateBtn.png",
			overFile="images/rateBtnOver.png",
			width = 375,
			height = 33,
			onRelease = ratingPrompt	
		}
		rateBtn:setReferencePoint( display.TopLeftReferencePoint )
		rateBtn.x = 540
		rateBtn.y = playBtn.y + 2*btnSpacingY
	
		shareBtn = widget.newButton{
			defaultFile="images/shareBtn.png",
			overFile="images/shareBtnOver.png",
			width = 375,
			height = 33,
			onRelease = onShareRelease	-- event listener function
		}
		shareBtn:setReferencePoint( display.TopLeftReferencePoint )
		shareBtn.x = 540
		shareBtn.y = playBtn.y + 3*btnSpacingY
	
		creditsBtn = widget.newButton{
			defaultFile="images/creditsBtn.png",
			overFile="images/creditsBtnOver.png",
			width = 375,
			height = 33,
			onRelease = goToCredits	
		}
		creditsBtn:setReferencePoint( display.TopLeftReferencePoint )
		creditsBtn.x = 540
		creditsBtn.y = playBtn.y + 4*btnSpacingY
	
		transition.to(playBtn,{time=fadeTime,x=btn1x,onComplete=playCueCollision})
		transition.to(menuInstBtn,{time=fadeTime,delay=1*delayTime,x=btn2x,onComplete=playAdd})
		transition.to(rateBtn,{time=fadeTime,delay=2*delayTime,x=btn3x,onComplete=playSub})
		transition.to(shareBtn,{time=fadeTime,delay=3*delayTime,x=btn4x,onComplete=playCueCollision})
		transition.to(creditsBtn,{time=fadeTime,delay=4*delayTime,x=btn5x,onComplete=playTen})
end

function loadMenuStage()

	if circleTEN then
		circleTEN:removeSelf()
		circleTEN = nil
	end

	local transitionX = display.contentWidth/2
	
	circleTEN = display.newImageRect("images/logo.png",570,380)
	circleTEN.x = -50
	circleTEN.y = display.contentHeight/2
	transition.to(circleTEN,{time=300,x=240,onComplete=loadMenuItems})

	return circleTEN
	
	
end

function removeAllMenuItems()
	if playBtn then
		playBtn:removeSelf()
		playBtn = nil
	end
	if purchaseBtn then
		purchaseBtn:removeSelf()
		purchaseBtn = nil
	end
	if scoresBtn then
		scoresBtn:removeSelf()
		scoresBtn = nil
	end
	if shareBtn then
		shareBtn:removeSelf()
		shareBtn = nil
	end
	if creditsBtn then
		creditsBtn:removeSelf()
		creditsBtn = nil
	end
	if menuInstBtn then
		menuInstBtn:removeSelf()
		menuInstBtn = nil
	end
	if rateBtn then
		rateBtn:removeSelf()
		rateBtn = nil
	end
end	

function clearMenuStage()
	local fadeTime = 250
	transition.to(playBtn,{time=fadeTime,x=540})
	transition.to(menuInstBtn,{time=fadeTime,x=540})
	transition.to(rateBtn,{time=fadeTime,x=540})
	transition.to(shareBtn,{time=fadeTime,x=540})
	transition.to(creditsBtn,{time=fadeTime,x=540})
	transition.to(circleTEN,{time=fadeTime,x=-50,onComplete=removeAllMenuItems})
end	




return scene