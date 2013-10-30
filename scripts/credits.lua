-----------------------------------------------------------------------------------------
--
-- credits.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"


--------------------------------------------

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

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
		
	creditsItems = loadCreditsItems()
	group:insert(creditsItems)	
		
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	clearCreditsStage()

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

function goToWeb()
	system.openURL("http://www.jonaapps.com")
end

function loadCreditsItems()

		local fadeTime = 500
		local btn1x = halfW + 70
		local btn2x = halfW - 70
		local navGroup = display.newGroup()
			
		local creditsInstructionsBtn = widget.newButton{
			defaultFile="images/LSInstructionsBtn.png",
			overFile="images/LSInstructionsBtnOver.png",
			width = 375,
			height = 33,
			onRelease = goToInstructions
		}
		creditsInstructionsBtn:setReferencePoint( display.TopLeftReferencePoint )
		creditsInstructionsBtn.x = 540
		creditsInstructionsBtn.y = 10
		transition.to(creditsInstructionsBtn,{time=fadeTime,x=btn1x})
		navGroup:insert(creditsInstructionsBtn)	
		
		local creditsMenuBtn = widget.newButton{
			defaultFile="images/LSMenuBtn.png",
			overFile="images/LSMenuBtnOver.png",
			width = 375,
			height = 33,
			onRelease = goToMenu
		}
		creditsMenuBtn:setReferencePoint( display.TopRightReferencePoint )
		creditsMenuBtn.x = -45
		creditsMenuBtn.y = 10
		transition.to(creditsMenuBtn,{time=fadeTime,x=btn2x})
		navGroup:insert(creditsMenuBtn)	
			
		local creditsTitle = display.newImageRect("images/creditsTitle.png",104,33)
		creditsTitle:setReferencePoint( display.TopCenterReferencePoint )
		creditsTitle.x = halfW
		creditsTitle.y = 10
		creditsTitle.alpha = 0
		transition.to(creditsTitle,{time=fadeTime,alpha=1})
		navGroup:insert(creditsTitle)
		
		local webBtn = widget.newButton{
			defaultFile="images/webBtn.png",
			overFile="images/webBtnOver.png",
			width = 118,
			height = 33,
			onRelease = goToWeb
		}
		webBtn:setReferencePoint( display.BottomCenterReferencePoint )
		webBtn.x = halfW
		webBtn.y = 400
		transition.to(webBtn,{time=fadeTime,y=225})
		navGroup:insert(webBtn)
		
		local creditsOverlay = display.newImageRect("images/creditsOverlay.png", 570, 380 )
		creditsOverlay:setReferencePoint( display.CenterReferencePoint )
		creditsOverlay.x = display.contentWidth/2
		creditsOverlay.y = display.contentHeight/2
		creditsOverlay.alpha=0
		transition.to(creditsOverlay,{time=fadeTime,alpha=1})
		navGroup:insert(creditsOverlay)
	
		return navGroup
end


function removeAllCreditsItems()
	if creditsItems then
		creditsItems:removeSelf()
		creditsItems = nil
	end
end	

function clearCreditsStage()
	local fadeTime = 200
	transition.to(creditsItems,{time=fadeTime,alpha=0,onComplete=removeAllCreditsItems})
end	




return scene