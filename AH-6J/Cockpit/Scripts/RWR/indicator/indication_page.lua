dofile(LockOn_Options.script_path.."RWR/Indicator/definitions.lua")

RS = RWR_SCALE

contact_scale = 0.065

	
mfd_base_rwr            	= CreateElement "ceSimple"
mfd_base_rwr.name			= "mfd_base_rwr"
mfd_base_rwr.init_pos		= center
mfd_base_rwr.element_params = {"RWR_POWER"}
mfd_base_rwr.controllers 	= {{"parameter_in_range",0,0.9,1.1}}
Add(mfd_base_rwr)	
	

for ia = 1,20 do
	if ia  < 10 then
		i = "_0".. ia .."_"
	else
		i = "_".. ia .."_"
	end
		
			local	RWR_contact			   			= CreateElement "ceSimple"
					RWR_contact.name		   		= "RWR_contact_" .. i .. "_name"
					RWR_contact.primitivetype		= "triangles"
					RWR_contact.h_clip_relation 	= h_clip_relations.COMPARE
					RWR_contact.level 				= RWR_DEFAULT_LEVEL
			
					RWR_contact.controllers     	= {
														{"rotate_using_parameter",0,1},
														{"move_up_down_using_parameter"	,1,contact_scale},
														{"parameter_in_range",1,0.1,1.09},
													  } 
					RWR_contact.element_params  	= {	
														"RWR_CONTACT"..i.."AZIMUTH",
														"RWR_CONTACT"..i.."POWER_SYM",
													  }
					RWR_contact.parent_element 		= "mfd_base_rwr"
				Add(RWR_contact)
			

			local 	RWR_type	 				= CreateElement "ceStringPoly"
					RWR_type.name			  	= "RWR_type_" .. i .. "_name"
					RWR_type.material        	= HUD_FONT
					RWR_type.stringdefs      	= txt_s_stringdefs
					RWR_type.alignment       	= "CenterCenter"
					RWR_type.formats		  	= {"%.0f"}
					RWR_type.UseBackground		= false
					RWR_type.use_mipfilter 		= true
					RWR_type.h_clip_relation 	= h_clip_relations.COMPARE
					RWR_type.level 				= RWR_DEFAULT_LEVEL
					RWR_type.element_params  	= {	
													"RWR_CONTACT" .. i .. "UNIT_TYPE_SYM",
													"RWR_CONTACT" .. i .. "AZIMUTH",
												  }
					RWR_type.controllers     	= {	
													{"text_using_parameter",0,0},
													{"rotate_using_parameter",1,-1},
												  }		
					RWR_type.parent_element 	= "RWR_contact_" .. i .. "_name"
				Add(RWR_type)	


				x_size 	= 0.065	* RS	
				y_size  = x_size
				wmul = 0.88 
				
			local 	RWR_lock	 				= CreateElement "ceStringPoly"
					RWR_lock.name			  	= "RWR_"..i.."_lock"
					RWR_lock.init_pos		  	= {0.0,0.0,0}
					RWR_lock.init_rot		  	= {0.0,0.0,0.0}
					RWR_lock.material    		= MFCD_GREEN	
					RWR_lock.vertices	   		= {	{-x_size 		,0				},
													{0 				, y_size 		},
													{0				, y_size * wmul	},
													{-x_size * wmul	,0				},	
													
													{ x_size 		,0				},
													{0 				, y_size 		},
													{0				, y_size * wmul	},
													{ x_size * wmul	,0				},	
													
													{-x_size 		,0				},
													{0 				, -y_size 		},
													{0				, -y_size * wmul},
													{-x_size * wmul	,0				},	
													
													{ x_size 		,0				},
													{0 				, -y_size 		},
													{0				, -y_size * wmul},
													{ x_size * wmul	,0				},	}		
					RWR_lock.indices	   		= 	{ 	0,1,2,	0,2,3,
														4,5,6,	4,6,7,
														8,9,10,	8,10,11,
														12,13,14,	12,14,15,}--{0, 1, 2, 0, 2, 3} 
					RWR_lock.element_params  	= {	"RWR_CONTACT" .. i .. "LOCK_SYM",
													"RWR_CONTACT" .. i .. "AZIMUTH",}
					RWR_lock.controllers     	= {	{"parameter_in_range",0,0.9,1.1},
													{"rotate_using_parameter",1,-1},} 
					RWR_lock.parent_element 	=  "RWR_contact_" .. i .. "_name"
					RWR_lock.use_mipfilter 		= true
					RWR_lock.h_clip_relation 	= h_clip_relations.COMPARE
					RWR_lock.level 				= RWR_DEFAULT_LEVEL
				
				Add(RWR_lock)				
	

				x_size 	= 0.051	* RS	
				y_size  = x_size
				wmul = 0.76 
				
			local 	RWR_plane	 				= CreateElement "ceStringPoly"
					RWR_plane.name			  	= "RWR_"..i.."_plane"
					RWR_plane.init_pos		  	= {0.0,0.0,0}--{0.0,-0.89,0} --{0.0,0.12,0} 
					RWR_plane.init_rot		  	= {0.0,0.0,0.0}
					RWR_plane.material    		= MFCD_GREEN	
					RWR_plane.vertices	   		= {	{-x_size/2 		, y_size/2		},
													{0 				, y_size 		},
													{0				, y_size * wmul	},
													{-(x_size*wmul)/2, y_size/2		},	
													
													{ x_size/2 		, y_size/2		},
													{0 				, y_size 		},
													{0				, y_size * wmul	},
													{ (x_size*wmul)/2, y_size/2		},	
												 }		
					RWR_plane.indices	   		= 	{ 	0,1,2,	0,2,3,
														4,5,6,	4,6,7,}--{0, 1, 2, 0, 2, 3} 
					RWR_plane.element_params  	= {	"RWR_CONTACT" .. i .. "GENERAL_TYPE",
													"RWR_CONTACT" .. i .. "AZIMUTH",}
					RWR_plane.controllers     	= {	{"parameter_in_range",0,0.9,1.1},
													{"rotate_using_parameter",1,-1},} 
					RWR_plane.parent_element 	=  "RWR_contact_" .. i .. "_name"
					RWR_plane.use_mipfilter 	= true
					RWR_plane.h_clip_relation 	= h_clip_relations.COMPARE
					RWR_plane.level 			= RWR_DEFAULT_LEVEL
				Add(RWR_plane)				
end


    radius = 0.05 * RS	
	local   RWR_grid_i 					= CreateElement "ceMeshPoly"
			RWR_grid_i.name 			= "RWR_grid_i"
			RWR_grid_i.primitivetype 	= "triangles"
			set_circle	(RWR_grid_i, radius + 0.0020, radius - 0.0020, 360, 32)
			RWR_grid_i.material 		= MFCD_GREEN_SOFT
			RWR_grid_i.h_clip_relation= h_clip_relations.COMPARE
			RWR_grid_i.level			= RWR_DEFAULT_LEVEL
			RWR_grid_i.isdraw		 	= true
			RWR_grid_i.parent_element 	= "mfd_base_rwr"
			RWR_grid_i.element_params	= {"RWR_BRIGHTNESS"}
			RWR_grid_i.controllers 		= {{"opacity_using_parameter",0}}
		Add(RWR_grid_i)
	

	radius = 0.25 * RS	
	local   RWR_grid_m 					= CreateElement "ceMeshPoly"
			RWR_grid_m.name 			= "RWR_grid_m"
			RWR_grid_m.primitivetype 	= "triangles"
			set_circle	(RWR_grid_m, radius + 0.0020, radius - 0.0020, 360, 32)
			RWR_grid_m.material 		= MFCD_GREEN_SOFT
			RWR_grid_m.h_clip_relation= h_clip_relations.COMPARE
			RWR_grid_m.level			= RWR_DEFAULT_LEVEL
			RWR_grid_m.isdraw		 	= true
			RWR_grid_m.parent_element 	= "mfd_base_rwr"
			RWR_grid_m.element_params	= {"RWR_BRIGHTNESS"}
			RWR_grid_m.controllers 		= {{"opacity_using_parameter",0}}
		Add(RWR_grid_m)	
		
	radius = 0.7 * RS	
	local   RWR_grid_o 					= CreateElement "ceMeshPoly"
			RWR_grid_o.name 			= "RWR_grid_o"
			RWR_grid_o.primitivetype 	= "triangles"
			set_circle	(RWR_grid_o, radius + 0.0020, radius - 0.0020, 360, 48)
			RWR_grid_o.material 		= MFCD_GREEN_SOFT
			RWR_grid_o.h_clip_relation= h_clip_relations.COMPARE
			RWR_grid_o.level			= RWR_DEFAULT_LEVEL
			RWR_grid_o.isdraw		 	= true
			RWR_grid_o.parent_element 	= "mfd_base_rwr"
			RWR_grid_o.element_params	= {"RWR_BRIGHTNESS"}
			RWR_grid_o.controllers 		= {{"opacity_using_parameter",0}}
		Add(RWR_grid_o)