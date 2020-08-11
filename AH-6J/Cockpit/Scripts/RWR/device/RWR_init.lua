dofile(LockOn_Options.common_script_path..'wsTypes_SAM.lua')
dofile(LockOn_Options.common_script_path..'wsTypes_Airplane.lua')
dofile(LockOn_Options.common_script_path..'wsTypes_Ship.lua')
dofile(LockOn_Options.common_script_path..'wsTypes_Missile.lua')
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

render_debug_info = true

rwrPower = get_param_handle("RWR_POWER")
rwrBrightness = get_param_handle("RWR_BRIGHTNESS")
elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")
rwrPower:set(0)
rwrBrightness:set(1)

local gettext = require("i_18n")
_ = gettext.translate

update_time_step = 0.025
make_default_activity(update_time_step) 
local dev 	    = GetSelf()

MaxThreats          = 16
EmitterLiveTime     = 7.0
EmitterSoundTime    = 0.5
LaunchSoundDelay    = 15.0

DefaultType          = 100

RWR_detection_coeff = 0.85


eyes ={}	-- sensor locations
eyes[1] =
	{
		position      = {x = 1.479,y = -0.472,z =  0.674}, --{Forward/Back,U/D,L/R}
		orientation   = {azimuth  = math.rad(45),elevation = math.rad(0.0)},
		field_of_view = math.rad(120) 
	}
eyes[2] =
	{
		position      = {x = 1.479,y = -0.472,z = -0.674},
		orientation   = {azimuth  = math.rad(-45),elevation = math.rad(0.0)},
		field_of_view = math.rad(120) 
	}
eyes[3] =
	{
		position      = {x = -1.196,y = 0.519,z =  0.21},
		orientation   = {azimuth  = math.rad(135),elevation = math.rad(0.0)},
		field_of_view = math.rad(120) 
	}
eyes[4] =
	{
		position      = {x = -1.196,y = 0.519,z =  -0.21},
		orientation   = {azimuth  = math.rad(-135),elevation = math.rad(0.0)},
		field_of_view = math.rad(120) 
	}


	--[[
		RWR_CONTACT_01_ELEVATION:-0.000844
		RWR_CONTACT_01_SOURCE:16778240.000000
		RWR_CONTACT_01_TIME:3.200000
		RWR_CONTACT_01_UNIT_TYPE:"MiG-29S"
		RWR_CONTACT_01_GENERAL_TYPE:1.000000
		RWR_CONTACT_01_PRIORITY:160.910660
		RWR_CONTACT_01_AZIMUTH:1.671934
		RWR_CONTACT_01_SIGNAL:1.000000
		RWR_CONTACT_01_POWER:0.910663
	]]--
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

rwr = 	{}
	--i = #rwr+1
for i = 1,20 do	
	rwr[i] = 	{
					elevation_h 	= get_param_handle("RWR_CONTACT_0" .. i .. "_ELEVATION"),
					azimuth_h 		= get_param_handle("RWR_CONTACT_0" .. i .. "_AZIMUTH"),
					power_h 		= get_param_handle("RWR_CONTACT_0" .. i .. "_POWER"),
					unit_type_h		= get_param_handle("RWR_CONTACT_0" .. i .. "_UNIT_TYPE"),
					
					general_type_h	= get_param_handle("RWR_CONTACT_0" .. i .. "_GENERAL_TYPE"),
					priority_h		= get_param_handle("RWR_CONTACT_0" .. i .. "_PRIORITY"),
					signal_h		= get_param_handle("RWR_CONTACT_0" .. i .. "_SIGNAL"),
					time_h			= get_param_handle("RWR_CONTACT_0" .. i .. "_TIME"),
					source_h		= get_param_handle("RWR_CONTACT_0" .. i .. "_SOURCE"),
					
					unit_type_sym_h	= get_param_handle("RWR_CONTACT_0" .. i .. "_UNIT_TYPE_SYM"),
					power_sym_h 	= get_param_handle("RWR_CONTACT_0" .. i .. "_POWER_SYM"),
					lock_sym_h 		= get_param_handle("RWR_CONTACT_0" .. i .. "_LOCK_SYM"),
				}
end


function post_initialize()
	--GetDevice(devices.RWR):set_power(true)	
	dev:performClickableAction(device_commands.RWRBrightness,1,true)
	local birth = LockOn_Options.init_conditions.birth_place	--"GROUND_COLD","GROUND_HOT","AIR_HOT"
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then 	-- set battery and generator on when starting hot   
        dev:performClickableAction(device_commands.RWRpower,1,true) --true or false do action	 	
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.RWRpower,0,true)	
    end
end

dev:listen_command(device_commands.RWRpower)
dev:listen_command(device_commands.RWRBrightness)

function SetCommand(command,value)
    if command == device_commands.RWRpower then
		RWR_Power = (value==1) and true or false
		GetDevice(devices.RWR):set_power(RWR_Power) -- actives the RWR script internally
		
	elseif command == device_commands.RWRBrightness then
		rwrBrightness:set(value)
	end
end

function update()
	local tmp_type,tmp_signal,tmp_gen_type
	for i = 1,20 do
	
		tmp_type 		= rwr[i].unit_type_h:get()
		tmp_gen_type 	= rwr[i].general_type_h:get()
		
		if  tmp_type and tmp_type ~= "" then

		----
			tmp_signal = rwr[i].signal_h:get()
			if tmp_signal == 2 then				-- 2 Lock
				--tmp_type = "(".. tmp_type .. ")"
				rwr[i].lock_sym_h:set(1)
			elseif tmp_signal == 3 then			-- 3 Launch
				
				if rwr[i].lock_sym_h:get() == 1 then
					rwr[i].lock_sym_h:set(0)
				else
					rwr[i].lock_sym_h:set(1)
				end
			else								--else 1 - Search
				rwr[i].lock_sym_h:set(0)
			end
			--rwr[i].unit_type_sym_h:set(tostring(tmp_type))
		----	
			if tmp_gen_type == 1 then			--Plane
			
				tmp_type = string.gsub(tmp_type,'%W','')
				tmp_type = string.gsub(tmp_type,'%a','')
				rwr[i].unit_type_sym_h:set(tonumber(tmp_type))
			
			elseif tmp_gen_type == 2 then		--SearchRadar
				
				tmp_type = string.gsub(tmp_type,'%W','')
				tmp_type = string.gsub(tmp_type,'%a','')
				rwr[i].unit_type_sym_h:set(tonumber(tmp_type))
			
			elseif tmp_gen_type == 0 then		--EWR
			
				tmp_type = string.gsub(tmp_type,'%W','')
				tmp_type = string.gsub(tmp_type,'%a','')
				rwr[i].unit_type_sym_h:set(tonumber(tmp_type))
			
			else
			
			end
		----	
			
		end
	
	
		tmp = 1-rwr[i].power_h:get() + 0.1
		rwr[i].power_sym_h:set(tmp)
	end
	
	
	if elec_dc_ok:get()==1 and RWR_Power then
		rwrPower:set(1) -- used for the indicator/display
	else
		rwrPower:set(0)
	end
end

