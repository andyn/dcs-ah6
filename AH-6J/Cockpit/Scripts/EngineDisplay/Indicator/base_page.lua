dofile(LockOn_Options.common_script_path.."elements_defs.lua")
--dofile(LockOn_Options.script_path.."../../Textures/Avionics/font_DigitClock")
SetScale(METERS) 

DEFAULT_LEVEL = 6
NOCLIP_LEVEL  = DEFAULT_LEVEL - 1
local FONT         = MakeFont({used_DXUnicodeFontData = "font7segment"},{255,50,10,255})
center={0.257,-0.336,-0.138}  --- {L/R,U/D,forward/back}
RPMPos={center[1],center[2]+0.0552,center[3]}
FFPos={center[1],center[2]-0.0276,center[3]-0.002}

function AddElement(object)
	object.use_mipfilter    = true
	object.additive_alpha   = true
	object.h_clip_relation  = h_clip_relations.compare
	object.level			= DEFAULT_LEVEL
    Add(object)
end

verts = {}
dx=.018 
dy=.065
verts [1]= {-dx,-dy}
verts [2]= {-dx,dy}
verts [3]= {dx,dy}
verts [4]= {dx,-dy}

base 			 	 = CreateElement "ceMeshPoly"
base.name 			 = "base"
base.vertices 		 = verts
base.indices 		 = {0,1,2,2,3,0}
base.init_pos		 = center  
base.init_rot		 = {0,0,3.8}  
base.material		 = MakeMaterial(nil,{3,3,3,255})
base.h_clip_relation = h_clip_relations.REWRITE_LEVEL 
base.level			 = NOCLIP_LEVEL
base.isdraw			 = true
base.change_opacity  = false
base.isvisible		 = false
base.element_params  = {"ELEC_DC_OK"}  
base.controllers     = {{"opacity_using_parameter",0}} 
Add(base)


--------------------------- Display numbers ------------------------------
local RPMNumb           = CreateElement "ceStringPoly"
RPMNumb.name            = create_guid_string()
RPMNumb.material        = FONT
RPMNumb.init_pos        = RPMPos			
RPMNumb.alignment       = "CenterCenter"
RPMNumb.stringdefs      = {0.01,0.75 * 0.01, 0, 0}  -- {size vertical, horizontal, 0, 0}
RPMNumb.formats         = {"%.0f","%s"} 
RPMNumb.element_params  = {"CURRENT_RPM","ELEC_DC_OK"}
RPMNumb.controllers     = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}  
AddElement(RPMNumb)

local nozzle           = CreateElement "ceStringPoly"
nozzle.name            = create_guid_string()
nozzle.material        = FONT
nozzle.init_pos        = center			
nozzle.alignment       = "CenterCenter"
nozzle.stringdefs      = {0.01,0.75 * 0.01, 0, 0}  -- {size vertical, horizontal, 0, 0}
nozzle.formats         = {"%.0f","%s"} 
nozzle.element_params  = {"CURRENT_NOZZLE","ELEC_DC_OK"}
nozzle.controllers     = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}  
AddElement(nozzle)

local FF           = CreateElement "ceStringPoly"
FF.name            = create_guid_string()
FF.material        = FONT
FF.init_pos        = FFPos			
FF.alignment       = "CenterCenter"
FF.stringdefs      = {0.01,0.75 * 0.01, 0, 0}  -- {size vertical, horizontal, 0, 0}
FF.formats         = {"%.0f","%s"} 
FF.element_params  = {"CURRENT_FF","ELEC_DC_OK"}
FF.controllers     = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}  
AddElement(FF)



local FuelTotal           = CreateElement "ceStringPoly"
FuelTotal.name            = create_guid_string()
FuelTotal.material        = MakeFont({used_DXUnicodeFontData = "font8segment"},{255,255,255,255})
FuelTotal.init_pos        = {center[1]+.052,center[2]-0.0989,center[3]-0.001}			
FuelTotal.alignment       = "CenterCenter"
FuelTotal.stringdefs      = {0.007,0.75 * 0.007, 0, 0}  -- {size vertical, horizontal, 0, 0}
FuelTotal.formats         = {"%.0f","%s"} 
FuelTotal.element_params  = {"CURRENT_FUELT","ELEC_DC_OK"}
FuelTotal.controllers     = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}  
AddElement(FuelTotal)