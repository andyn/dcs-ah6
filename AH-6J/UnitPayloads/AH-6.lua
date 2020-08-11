local unitPayloads = {
	["name"] = "AH-6",
	["payloads"] = {
		[1] = {
			["name"] = "M134 minigun *2, FFAR *14",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{FC85D2ED-501A-48ce-9863-49D468DDD5FC}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{M134 Minigun}",
					["num"] = 2,
				},
				[4] = {
					["CLSID"] = "{M134 Minigun}",
					["num"] = 4,
				},
				[5] = {
					["CLSID"] = "{FC85D2ED-501A-48ce-9863-49D468DDD5FC}",
					["num"] = 5,
				},
			},
			["tasks"] = {
				[1] = 31,
				[2] = 32,
			},
		},

		[2] = {
			["name"] = "M134 minigun, FFAR *7, GAU-19 .50 Cal",
			["pylons"] = {
				[1] = {
					["CLSID"] = "{FC85D2ED-501A-48ce-9863-49D468DDD5FC}",
					["num"] = 1,
				},
				[2] = {
					["CLSID"] = "{M134 Minigun}",
					["num"] = 2,
				},
				[5] = {
					["CLSID"] = "{AH6_GAU-19}",
					["num"] = 5,
				},
			},
			["tasks"] = {
				[1] = 31,
				[2] = 32,
			},
		},

	},
	["tasks"] = {
	},
	["unitType"] = "AH-6",
}
return unitPayloads
