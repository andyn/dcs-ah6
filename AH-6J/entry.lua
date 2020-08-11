local self_ID = "AH-6"
declare_plugin(self_ID,
{
dirName			= current_mod_path,
displayName		= _("AH-6J Little Bird"),
fileMenuName	= _("AH-6J"),
version 		= "0.2",
state			= "installed",
info			= _("The AH-6J Little Bird is the attack version of the MH-6J light helicopter, which is based on the MD500."),

binaries	 =
{ 
'AH6',
},
Skins =
{
	{
		name	= "AH-6",
		dir		= "Skins/1"
	},
},
Missions =
{
	{
		name	= _("AH-6"),
		dir		= "Missions",
	},
},
LogBook =
{
	{
		name	= _("AH-6"),
		type	= "AH-6",
	},
},
InputProfiles = 
{
	["AH-6"] = current_mod_path .. '/Input',	
},

})
-------------------------------------------------------------------------------
mount_vfs_model_path	(current_mod_path.."/Shapes")
--mount_vfs_model_path    (current_mod_path.."/Cockpit")
--mount_vfs_liveries_path (current_mod_path.."/Liveries")
mount_vfs_texture_path  (current_mod_path.."/Textures")
mount_vfs_texture_path  (current_mod_path.."/Textures/Avionics")
mount_vfs_texture_path	(current_mod_path .."/Skins/1/ME" )	

dofile(current_mod_path..'/AH-6.lua')
dofile(current_mod_path..'/Weapons/AH6_Weapons.lua')
dofile(current_mod_path..'/UnitPayloads/AH-6.lua')
dofile(current_mod_path.."/Views.lua")
make_view_settings('AH-6', ViewSettings, SnapViews)

local FM =
{
	[1] = self_ID,
	[2] = "AH6", -- name of dll
	center_of_mass = {0,0,0},  -- center of mass position relative to object 3d model center for empty aircraft
	moment_of_inertia = {446, 1219, 979, 50}, -- moment of inertia of empty (Ixx,Iyy,Izz,Ixz)	in kgm^2 --128
}

make_flyable('AH-6',current_mod_path..'/Cockpit/Scripts/', FM, current_mod_path..'/comm.lua')

plugin_done()