module(..., package.seeall)

local json = require "json"

_G.lobal = {}
_G.prefsFile = "savedItems.json"

--JSON FUNCTIONS 
function ifBlankSetDefaultSavedItems()
 
   --in this function, set up the defaults for all saved items if they do not exist
 
   print ("Setting Defaults for blanks")
  
	if _G.lobal.mode == nil then
		_G.lobal.mode = "add"
	end
	
	if _G.lobal.soundOn == nil then
		_G.lobal.soundOn = true
	end


	if _G.lobal.currentLevel == nil then
		_G.lobal.currentLevel = 0
	end
	
	if _G.lobal.currentLevelGroup == nil then
		_G.lobal.currentLevelGroup = 1
	end
	
	if _G.lobal.highScores == nil then
		
		_G.lobal.highScores = {}
			for i = 1,50 do
				
				_G.lobal.highScores[i] = 0
				
			end
			
		
	end
	
 
end
 
function addSavedItem(itemName, theValue)
   --this function allows you to add a new saved item
   print ("Adding Saved Item")
   _G.lobal[itemName] = theValue
end
 
function saveSavedItems()
   --call this on application suspend or application exit
   print ("saving persistent items")
   local path = system.pathForFile( _G.prefsFile, system.DocumentsDirectory )
   local file = io.open( path, "w" )
   local contents = json.encode(_G.lobal)
   file:write(contents)
   io.close( file )
end
 
function loadSavedItems()
   --reload saved file
   print ("loading saved items")
 
   local path = system.pathForFile( _G.prefsFile, system.DocumentsDirectory )
 
   local file = io.open( path, "r" )
   --will be nil if it does not exist
 
   if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        _G.lobal = json.decode(contents)
        io.close( file )
   else
     print ("file not found")
   end
 
end
 

--test the system
-- to make use of this system, there is a truly global table called lobal
-- it contains as many elements as you want
-- you can initialise them en masse in the setDefaults() function
-- or one by one with the addDefaultItem(itemName, theValue)  function
 
--when the app suspends or exits, save the file with saveDefaults()
--when the app starts or resumes, use loadDefaults()
 
--using the variables is simple using the syntactic sugar version
 
--   _G.lobal.myVariable = 6 

return utilities