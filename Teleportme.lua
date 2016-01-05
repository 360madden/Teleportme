			--			by 360madden! Orginally modified from devmonitor.lua

			--	1.01 	Added the ability to remember a location, then teleport to it. 
			--	1.02 	Removed the toggle bar(finally!). Streamlined some of the code. Added more notes!
			--	1.03 	Revamped the tool. Can now recall two seperate locations. Whole numbers being used now!
			--	1.03 	Coming Soon! Will try to add teleporting by mouse! 
			
TeleportMe = { }
TeleportMe.lastticks = 0
TeleportMe.running = false
TeleportMe.initialized = false

--------------------------------------------------------------------
function TeleportMe.ModuleInit()
	GUI_NewWindow("TeleportMe",300,300,220,250)
	GUI_WindowVisible("TeleportMe",false)
	
	GUI_NewButton("TeleportMe","Teleport to Highlighted Target","TeleportMe.tptarget") 						-- setup button to activate player teleport

	GUI_NewField("TeleportMe","[Location 1]   X:","ax","Navigation") -- display x
	GUI_NewField("TeleportMe","[Location 1]   Y:","ay","Navigation") -- display y
	GUI_NewField("TeleportMe","[Location 1]   Z:","az","Navigation") -- display z
	GUI_NewButton("TeleportMe","Mark Location 1","TeleportMe.location01","Navigation") 						-- button retrieves xyz coords
	GUI_NewButton("TeleportMe","Teleport to Location 1","TeleportMe.location01Teleport","Navigation")		-- button activates player teleport
	
	GUI_NewField("TeleportMe","[Location 2]   X:","bx","Navigation") -- display x
	GUI_NewField("TeleportMe","[Location 2]   Y:","by","Navigation") -- display y
	GUI_NewField("TeleportMe","[Location 2]   Z:","bz","Navigation") -- display z
	GUI_NewButton("TeleportMe","Mark Location 2","TeleportMe.location02","Navigation") 						-- button retrieves xyz coords
	GUI_NewButton("TeleportMe","Teleport to Location 2","TeleportMe.location02Teleport","Navigation")		-- button activates mouse teleport	

	RegisterEventHandler("TeleportMe.tptarget", TeleportMe.Func)		-- perform target teleport below
	
	RegisterEventHandler("TeleportMe.location01", TeleportMe.Move) 			-- get xyz coords below
	RegisterEventHandler("TeleportMe.location01Teleport", TeleportMe.Func)	-- for location01 Teleport
	
	RegisterEventHandler("TeleportMe.location02", TeleportMe.Move) 			-- get xyz coords below
	RegisterEventHandler("TeleportMe.location02Teleport", TeleportMe.Func)	-- for location02 Teleport
	
	TeleportMe.initialized = true
	
	d(TeleportMe.running)
	
	end
--------------------------------------------------------------------
function TeleportMe.Func ( arg ) -- actual TELEPORT for both player and target happen in this function
	if ( arg == "TeleportMe.location01Teleport") then			-- (Player Teleport)
		
		if (tonumber(ax) ~= nil ) then								-- Teleport player marked location01
		d(Player:Teleport(tonumber(ax),tonumber(ay),tonumber(az)))
		Player:Resync()
		end
		
		elseif ( arg == "TeleportMe.tptarget" ) then				-- (Highlighted Target Teleport)
		local t = Player:GetTarget()
		if ( t ) then
		Player:Teleport(tonumber(t.pos.x),tonumber(t.pos.y),tonumber(t.pos.z))
		Player:Resync()
		end
		
		elseif ( arg == "TeleportMe.location02Teleport" ) then 		-- Teleport player marked location02
		if (tonumber(bx) ~= nil ) then								
		d(Player:Teleport(tonumber(bx),tonumber(by),tonumber(bz)))
		Player:Resync()
		end
	end
end
--------------------------------------------------------------------
function TeleportMe.Move ( arg )					-- This function gets the xyz coordinates then sends it to .func
		if ( arg == "TeleportMe.location01") then
			local pp = Player.pos
				ax = tostring(math.floor(pp.x))
				ay = tostring(math.floor(pp.y))
				az = tostring(math.floor(pp.z))
			end
		if ( arg == "TeleportMe.location02") then
			local pp = Player.pos
				bx = tostring(math.floor(pp.x))
				by = tostring(math.floor(pp.y))
				bz = tostring(math.floor(pp.z))
			end
end

--------------------------------------------------------------------
function TeleportMe.OnUpdateHandler( Event, ticks ) 	
	if ( TeleportMe.running and TeleportMe.initialized ) then
		if ( ticks - TeleportMe.lastticks > 500 ) then
			if ( TeleportMe.lastticks == 0 ) then
				TeleportMe.lastticks = ticks + 2000
				return
			end			
			TeleportMe.lastticks = ticks
		end
	end
end
--------------------------------------------------------------------




RegisterEventHandler("Module.Initalize",TeleportMe.ModuleInit)
RegisterEventHandler("Gameloop.Update", TeleportMe.OnUpdateHandler)
RegisterEventHandler("GUI.Update",TeleportMe.GUIVarUpdate)
