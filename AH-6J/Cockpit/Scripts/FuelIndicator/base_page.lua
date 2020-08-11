dofile(LockOn_Options.common_script_path.."elements_defs.lua")

SetScale(METERS) 

local font7segment = MakeFont({used_DXUnicodeFontData = "font7segment"},{250,40,20,255})
local center = {0.063,-0.575,0.364}  --- {L/R,U/D,forward/back}

verts = {}
dx=.0145
dy=.0084
verts [1]= {-dx,-dy}
verts [2]= {-dx,dy}
verts [3]= {dx,dy}
verts [4]= {dx,-dy}

local base 			 = CreateElement "ceMeshPoly"
base.name 			 = "base"
base.vertices 		 = verts
base.indices 		 = {0,1,2,2,3,0}
base.init_pos		 = center  
base.material		 = MakeMaterial(nil,{3,3,3,255})
base.h_clip_relation = h_clip_relations.REWRITE_LEVEL 
base.level			 = 5
base.isdraw			 = true
base.change_opacity  = false
base.isvisible		 = false
base.element_params  = {"DC_POWER_AVAIL"}  
base.controllers     = {{"parameter_in_range",0,0.9,1.1}} 
Add(base)

local FuelAmount           = CreateElement "ceStringPoly"
FuelAmount.name            = create_guid_string()
FuelAmount.material        = font7segment
FuelAmount.alignment       = "CenterCenter"
FuelAmount.stringdefs      = {0.0125,0.75 * 0.0125, 0, 0}  -- {size vertical, horizontal, 0, 0}
FuelAmount.formats         = {"%.0f"} 
FuelAmount.element_params  = {"CURRENT_FUELT"}
FuelAmount.controllers     = {{"text_using_parameter",0,0}}  
FuelAmount.h_clip_relation  = h_clip_relations.compare
FuelAmount.level			= 6
FuelAmount.parent_element  = "base"
Add(FuelAmount)

