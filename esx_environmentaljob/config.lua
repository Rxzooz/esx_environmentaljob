Config = {

    Settings = {
        license = "45XC6DXZ9UWN",

    },

}

Config.DrawDistance               = 10.0 -- How close do you need to be for the markers to be drawn (in GTA units).
Config.MarkerType                 = {Cloakrooms = 20, Armories = 21, BossActions = 22, Vehicles = 36, Helicopters = 34, GiveBackMoney = 21, Liverys = 36, Tasleem = 2, deleteRecord = 2}
Config.MarkerSize                 = {x = 1.5, y = 1.5, z = 0.5}
--Config.MarkerColor                = {r = 50, g = 50, b = 204}
Config.MarkerColor                = {r = 29, g = 107, b = 19}

Config.EnablePlayerManagement     = true -- Enable if you want society managing.
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- Enable if you're using esx_identity.
Config.EnableLicenses             = true -- Enable if you're using esx_license.

Config.ShowRecordsMoney = 2000
Config.DeleteRecordsMoney = 10000

Config.EnableHandcuffTimer        = true -- Enable handcuff timer? will unrestrain player after the time ends.
Config.HandcuffTimer              = 10 * 60000 -- 10 minutes.

Config.EnableJobBlip              = true -- Enable blips for cops on duty, requires esx_society.
Config.EnableCustomPeds           = false -- Enable custom peds in cloak room? See Config.CustomPeds below to customize peds.

Config.EnableESXService           = false -- لاتعدل شي
Config.MaxInService               = -1 -- لاتعدل شي


Config.EnableServiceMain           = false --  تفعيل وإلغاء إذا موب مسجل دخول مايقدر يفتح قائمة الشرطة و الكراج وكذا

Config.bulletproof_cooltime = 0 --min

Config.Locale                     = 'en'

Config.timeBetwenImpoundMechanic = 100

Config.impoundxp = 80 
Config.impoundmoney = 5000


Config.impound = {
	location = {
		[1] = {label='حجز لوس سانتوس',coords=vector3(401.76,-1631.69,29.29),radius=10.0},
		[2] = {label='حجز ساندي شورز',coords=vector3(1743.81,3629.39,34.57),radius=20.0},
		[3] = {label='حجز بليتو',coords=vector3(-360.17,6071.86,31.5),radius=15.0},
		[4] = {label=' االميناء البحري الرئيسي مركز البحث و التحري',coords=vector3(815.21,-2931.13,5.91),radius=30.0},
		[5] = {label='2 االميناء البحري الرئيسي مركز البحث و التحري',coords=vector3(839.06,-2907.85,5.91),radius=25.0},
		[6] = {label='الميناء البحري الغربي',coords=vector3(-40.82,-2523.64,6.01),radius=15.0}
	}
}
Config.environmentalStations = {
	LSPD = {

		Blip = { --
			Coords  = vector3(1712.2104, 3310.9414, 44.8604),
			Sprite  = 487,
			Display = 4,
			Scale   = 1.2,
			Colour  = 25
		},

		Cloakrooms = { --
			vector3(1712.8333, 3308.7537, 44.8606),
		},

		Armories = { --
		 vector3(1720.1632, 3311.1748, 41.3414),
		
		},

		Liverys = { --
			vector3(1791.1982, 3227.7820, 42.7484),
			vector3(1788.1161, 3227.9849, 42.6699),
			vector3(1785.3673, 3228.0845, 42.6288),
		},

		Vehicles = { --

			{ 
				Spawner = vector3(1793.8442, 3231.5796, 42.7763), 
				Spawner2 = vector3(1698.3313, 3306.5737, 41.3414),
				InsideShop = vector3(1793.8442, 3231.5796, 42.7763),
				SpawnPoints = {
					{coords = vector3(1791.1982, 3227.7820, 42.7484), heading = 0.7399, radius = 6.0},
					{coords = vector3(1788.1161, 3227.9849, 42.6699), heading = 0.6204, radius = 6.0},
					{coords = vector3(1785.3673, 3228.0845, 42.6288), heading = 21.9723, radius = 6.0},
				}
			},
			
		},

		Helicopters = {
			{
				Spawner = vector3(1767.1630, 3323.6721, 42.0905),
				InsideShop = vector3(1774.5105, 3332.7019, 42.0905),
				SpawnPoints = {
					{coords = vector3(1774.5105, 3332.7019, 42.0905), heading = 123.8956, radius = 6.0}
				}
			}
		},

		Tasleem = { --
			vector3(1725.5951, 3312.7522, 41.3343),
		},

		BossActions = {  --
			vector3(1763.3606, 3307.8911, 41.3414),
		}

	},

	remove_sglat = { --
		 { Pos = vector3(1749.5284, 3305.5686, 41.3414), job = 'environmental', Color = { r = 0, g = 255, b = 0 }},
	},

}

Config.WeaponsPrice = {
	WEAPON_PISTOL = 3000,
	WEAPON_SAWNOFFSHOTGUN = 35000,
	WEAPON_PUMPSHOTGUN_MK2 = 35000,
	WEAPON_ADVANCEDRIFLE = 35000,
	WEAPON_ASSAULTRIFLE = 45000,
	WEAPON_COMPACTRIFLE = 50000,
	WEAPON_STUNGUN = 5000,
	WEAPON_FLAREGUN = 5000,
	WEAPON_COMBATPISTOL = 3000,
	WEAPON_FLARE = 3000,
	WEAPON_NIGHTSTICK = 0,
	WEAPON_FLASHLIGHT = 0,
	WEAPON_PETROLCAN = 0,
	WEAPON_FIREEXTINGUISHER = 0
}

Config.AuthorizedWeapons = {
	recruit = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil }, price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
		{ weapon = 'WEAPON_NIGHTSTICK', price = Config.WeaponsPrice.WEAPON_NIGHTSTICK},
		{ weapon = 'WEAPON_STUNGUN',    price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT', price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',      price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',  price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	officer = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil }, price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
		{ weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
		{ weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_NIGHTSTICK', price = Config.WeaponsPrice.WEAPON_NIGHTSTICK},
		{ weapon = 'WEAPON_STUNGUN',    price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT', price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',      price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',  price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	sergeant = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil }, price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
		{ weapon = 'WEAPON_NIGHTSTICK', price = Config.WeaponsPrice.WEAPON_NIGHTSTICK},
		{ weapon = 'WEAPON_STUNGUN',    price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_FLASHLIGHT', price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',      price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',  price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	intendent = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil }, price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_NIGHTSTICK', price = Config.WeaponsPrice.WEAPON_NIGHTSTICK},
		{ weapon = 'WEAPON_STUNGUN',    price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT', price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',      price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',  price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	lieutenant = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil }, price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_NIGHTSTICK', price = Config.WeaponsPrice.WEAPON_NIGHTSTICK},
		{ weapon = 'WEAPON_STUNGUN',    price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT', price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',      price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',  price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	chef = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil }, price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_NIGHTSTICK', price = Config.WeaponsPrice.WEAPON_NIGHTSTICK},
		{ weapon = 'WEAPON_STUNGUN',    price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT', price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',      price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',  price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	inspector = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil }, price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_NIGHTSTICK', price = Config.WeaponsPrice.WEAPON_NIGHTSTICK},
		{ weapon = 'WEAPON_STUNGUN',    price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT', price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',      price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',  price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	bigboss = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil },                 price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_ASSAULTRIFLE',     price = Config.WeaponsPrice.WEAPON_ASSAULTRIFLE },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = Config.WeaponsPrice.WEAPON_NIGHTSTICK },
		{ weapon = 'WEAPON_STUNGUN',        price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',          price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',      price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	captain = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil },                 price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_ASSAULTRIFLE',     price = Config.WeaponsPrice.WEAPON_ASSAULTRIFLE },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = Config.WeaponsPrice.WEAPON_NIGHTSTICK },
		{ weapon = 'WEAPON_STUNGUN',        price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',          price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',      price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	sany1 = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil },                 price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_ASSAULTRIFLE',     price = Config.WeaponsPrice.WEAPON_ASSAULTRIFLE },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = Config.WeaponsPrice.WEAPON_NIGHTSTICK },
		{ weapon = 'WEAPON_STUNGUN',        price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',          price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',      price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	sany2 = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil },                 price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_ASSAULTRIFLE',     price = Config.WeaponsPrice.WEAPON_ASSAULTRIFLE },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = Config.WeaponsPrice.WEAPON_NIGHTSTICK },
		{ weapon = 'WEAPON_STUNGUN',        price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',          price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',      price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	sany3 = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil },                 price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_ASSAULTRIFLE',     price = Config.WeaponsPrice.WEAPON_ASSAULTRIFLE },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = Config.WeaponsPrice.WEAPON_NIGHTSTICK },
		{ weapon = 'WEAPON_STUNGUN',        price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',          price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',      price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	sany4 = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil },                 price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_ASSAULTRIFLE',     price = Config.WeaponsPrice.WEAPON_ASSAULTRIFLE },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = Config.WeaponsPrice.WEAPON_NIGHTSTICK },
		{ weapon = 'WEAPON_STUNGUN',        price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',          price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',      price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	fbi1 = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil },                 price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_ASSAULTRIFLE',     price = Config.WeaponsPrice.WEAPON_ASSAULTRIFLE },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = Config.WeaponsPrice.WEAPON_NIGHTSTICK },
		{ weapon = 'WEAPON_STUNGUN',        price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',          price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',      price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	high = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil },                 price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_ASSAULTRIFLE',     price = Config.WeaponsPrice.WEAPON_ASSAULTRIFLE },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = Config.WeaponsPrice.WEAPON_NIGHTSTICK },
		{ weapon = 'WEAPON_STUNGUN',        price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',          price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',      price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	high1 = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil },                 price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_ASSAULTRIFLE',     price = Config.WeaponsPrice.WEAPON_ASSAULTRIFLE },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = Config.WeaponsPrice.WEAPON_NIGHTSTICK },
		{ weapon = 'WEAPON_STUNGUN',        price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',          price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',      price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	bossthree = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil },                 price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_ASSAULTRIFLE',     price = Config.WeaponsPrice.WEAPON_ASSAULTRIFLE },

		{ weapon = 'WEAPON_NIGHTSTICK',     price = Config.WeaponsPrice.WEAPON_NIGHTSTICK },
		{ weapon = 'WEAPON_STUNGUN',        price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',          price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',      price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},

	bosstwo = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil },                 price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_ASSAULTRIFLE',     price = Config.WeaponsPrice.WEAPON_ASSAULTRIFLE },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = Config.WeaponsPrice.WEAPON_NIGHTSTICK },
		{ weapon = 'WEAPON_STUNGUN',        price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',          price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',      price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
	},
	
	boss = {
		{ weapon = 'WEAPON_PISTOL', components = { 0, 0, 1000, 4000, nil },                 price = Config.WeaponsPrice.WEAPON_PISTOL },
		{ weapon = 'WEAPON_MEGAPHONE', price = 1000},
        { weapon = 'WEAPON_SAWNOFFSHOTGUN',                               price = Config.WeaponsPrice.WEAPON_SAWNOFFSHOTGUN },
        { weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {750, 1500, 3000}, price = 45000},
		{ weapon = 'WEAPON_ASSAULTRIFLE',     price = Config.WeaponsPrice.WEAPON_ASSAULTRIFLE },
		{ weapon = 'WEAPON_NIGHTSTICK',     price = Config.WeaponsPrice.WEAPON_NIGHTSTICK },
		{ weapon = 'WEAPON_STUNGUN',        price = Config.WeaponsPrice.WEAPON_STUNGUN },
		{ weapon = 'WEAPON_FLASHLIGHT',     price = Config.WeaponsPrice.WEAPON_FLASHLIGHT },
		{ weapon = 'WEAPON_FLARE',          price = Config.WeaponsPrice.WEAPON_FLARE },
		{ weapon = 'WEAPON_PETROLCAN',      price = Config.WeaponsPrice.WEAPON_PETROLCAN },
		{ weapon = 'WEAPON_FIREEXTINGUISHER',  price = Config.WeaponsPrice.WEAPON_FIREEXTINGUISHER }
		
	}
}

Config.AuthorizedVehicles = {
	car = {
		recruit = {
		{model = 'gruppe3',label = 'دورية فورد اكسبلورر - شامل', price = 299000}
		},

		officer = {
		{model = 'gruppe1',label = 'دورية فورد كروان فكتوريا - شامل', price = 799000}
		},

		sergeant = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000}
		},

		intendent = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		},

		lieutenant = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		},

		chef = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},			
		},

		inspector = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},			
		},
		
		bigboss = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		{model = '7rs01',label = 'تاهو', price = 150000},		
		},		

		captain = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		{model = '7rs01',label = 'تاهو', price = 150000},				
		},

		sany = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		{model = '7rs01',label = 'تاهو', price = 150000},	
		},		

		sany2 = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		{model = '7rs01',label = 'تاهو', price = 150000},	
		{model = '7rs04',label = 'فورد تورس', price = 215000},
		},
		
		sany3 = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		{model = '7rs01',label = 'تاهو', price = 150000},	
		{model = '7rs04',label = 'فورد تورس', price = 215000},
		},

		sany4 = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		{model = '7rs01',label = 'تاهو', price = 150000},	
		{model = '7rs04',label = 'فورد تورس', price = 215000},
		},

		high = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		{model = '7rs01',label = 'تاهو', price = 150000},	
		{model = '7rs04',label = 'فورد تورس', price = 215000},
		{model = '7rs05',label = 'شارجر', price = 225000},
		},

		high1 = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		{model = '7rs01',label = 'تاهو', price = 150000},	
		{model = '7rs04',label = 'فورد تورس', price = 215000},
		{model = '7rs05',label = 'شارجر', price = 225000},
		},

		high2 = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		{model = '7rs01',label = 'تاهو', price = 150000},	
		{model = '7rs04',label = 'فورد تورس', price = 215000},
		{model = '7rs05',label = 'شارجر', price = 225000},		
		},
		
		bosstwo = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		{model = '7rs01',label = 'تاهو', price = 150000},	
		{model = '7rs04',label = 'فورد تورس', price = 215000},
		{model = '7rs05',label = 'شارجر', price = 225000},
		},

		boss = {
		{model = '7rs02',label = 'فورد فيكتوريا', price = 100000},
		{model = '7rs03',label = 'فورد إكسبلور', price = 120000},
		{model = '7rs01',label = 'تاهو', price = 150000},	
		{model = '7rs04',label = 'فورد تورس', price = 215000},
		{model = '7rs05',label = 'شارجر', price = 225000},		
		}
	},

	helicopter = {
		recruit = {},

		officer = {
		},

		sergeant = {
		},

		intendent = {
		},

		lieutenant = {
		},

		chef = {
		},

		inspector = {
			{model = 'polmav', props = {modLivery = 0}, price = 200000}
		},

		bigboss = {
			{model = 'polmav', props = {modLivery = 0}, price = 200000}
		},

		captain = {
			{model = 'polmav', props = {modLivery = 0}, price = 200000}
		},

		sany = {
			{model = 'polmav', props = {modLivery = 0}, price = 200000}
		},

		sany2 = {
			{model = 'polmav', props = {modLivery = 0}, price = 200000}
		},

		sany3 = {
			{model = 'polmav', props = {modLivery = 0}, price = 200000}
		},

		sany4 = {
			{model = 'polmav', props = {modLivery = 0}, price = 200000}
		},

		high = {
			{model = 'polmav', props = {modLivery = 0}, price = 200000}
		},

		high1 = {
			{model = 'polmav', props = {modLivery = 0}, price = 100000}
		},

		high2 = {
			{model = 'polmav', props = {modLivery = 0}, price = 100000}
		},

		bosstwo = {
			{model = 'polmav', props = {modLivery = 0}, price = 100000}
		},

		boss = {
			{model = 'polmav', props = {modLivery = 0}, price = 100000}
		}
	}
}

Config.CustomPeds = {
	shared = {
		--{label = 'Sheriff Ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'},
		--{label = 'environmental Ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'}
	},

	recruit = {},

	officer = {},

	sergeant = {},

	lieutenant = {},

	boss = {
		--{label = 'SWAT Ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'}
	}
}

Config.mmno3at = {
	items = {
	beer = {xp = 15, money = 350},
	coke = {xp = 10, money = 500},
	coke_pooch = {xp = 35, money = 1700},
	dia_box = {xp = 5, money = 50},
	gold_bar = {xp = 10, money = 800},
	grand_cru = {xp = 20, money = 400},
	meth =  {xp = 10, money = 500},
	meth_pooch = {xp = 38, money = 2200},
	opium = {xp = 10, money = 500},
	opium_pooch = {xp = 33, money = 1200},
	shark = {xp = 5, money = 50},
	turtle = {xp = 5, money = 50},
	weed = {xp = 10, money = 500},
	weed_pooch = {xp = 30, money = 1200},
	painting_1 = {xp = 90, money = 4800},
	painting_2 = {xp = 100, money = 5000},
	painting_3 = {xp = 110, money = 5200},
	painting_real = {xp = 1700, money = 180000},
	golds = {xp = 1000, money = 98000},
	secret = {xp = 1300, money = 100520},
	diaring = {xp = 2000, money = 120000},
	vbook = {xp = 1750, money = 98000},
	doc = {xp = 2050, money = 345000},
	jewels = {xp = 10, money = 2000}
	},
	
	weapons = {
		WEAPON_BATTLEAXE = {xp = 100, money = 5000},
		WEAPON_MACHETE = {xp = 100, money = 5000},
		WEAPON_MICROSMG = {xp = 1000, money = 50000},
		WEAPON_SWITCHBLADE = {xp = 100, money = 50},
	},
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {
	[0] = {
		["7rs"] = {
			male = {
				tshirt_1 = 15,
				tshirt_2 = 0,
				torso_1 = 13,
				torso_2 = 4,
				shoes_1 = 1,
				shoes_2 = 0,
				helmet_1 = 5,
				helmet_2 = 5,
				arms = 27,
				pants_1 = 14,
				pants_2 = 9,
				bproof_1 = 0,
				bproof_2 = 0,
				chain_1 = 5,
				chain_2 = 5,
			},
			female = {
				torso_1 = 208,
				torso_2 = 0,
				shoes_1 = 25,
				helmet_1 = 3,
				helmet_2 = 0,
				arms = 32,
				bproof_1 = 0,
				bproof_2 = 0,
				chain_1 = 0,
				chain_2 = 0,
			},
		},
		["7rs2"] = {
			male = {
				tshirt_1 = 130,
				tshirt_2 = 0,
				torso_1 = 273,
				torso_2 = 0,
				shoes_1 = 35,
				shoes_2 = 0,
				helmet_1 = 6,
				helmet_2 = 6,
				arms = 32,
				pants_1 = 25,
				pants_2 = 9,
				bproof_1 = 0,
				bproof_2 = 0,
				chain_1 = 0,
				chain_2 = 0,
			},
			female = {
				torso_1 = 208,
				torso_2 = 0,
				shoes_1 = 25,
				helmet_1 = 3,
				helmet_2 = 0,
				arms = 32,
				bproof_1 = 0,
				bproof_2 = 0,
				chain_1 = 0,
				chain_2 = 0,
			},
		},
	},
	[1] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 1,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 6,
			helmet_2 = 6,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[2] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 2,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 6,
			helmet_2 = 6,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[3] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 3,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 6,
			helmet_2 = 6,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[4] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 4,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 6,
			helmet_2 = 6,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			pants_1 = 13,
			pants_2 = 0,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[5] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 5,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 6,
			helmet_2 = 6,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[6] = { -- وكيل ضابط أول أدارة المارشل --
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 6,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[7] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 7,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[8] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 8,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[9] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 9,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[10] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 10,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[11] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 11,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 11,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			pants_1 = 46,
			pants_2 = 0,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[12] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 12,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 1,
			chain_2 = 0,
		},
	},
	[13] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 13,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			tshirt_1 = 10,
			tshirt_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[14] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 14,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[15] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 15,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[16] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 16,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[17] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 16,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	[18] = {
		male = {
			tshirt_1 = 130,
			tshirt_2 = 0,
			torso_1 = 273,
			torso_2 = 16,
			shoes_1 = 35,
			shoes_2 = 0,
			helmet_1 = 2,
			helmet_2 = 0,
			arms = 32,
			pants_1 = 25,
			pants_2 = 9,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
		female = {
			torso_1 = 208,
			torso_2 = 0,
			shoes_1 = 25,
			helmet_1 = 45,
			helmet_2 = 0,
			arms = 14,
			bproof_1 = 0,
			bproof_2 = 0,
			chain_1 = 0,
			chain_2 = 0,
		},
	},
	remove_bullet_wear = { -- إزالة مضاد رصاص
		male = {
			['chain_1'] = 0,  ['chain_2'] = 0
		},
		female = {
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	},

    rsme_wear = { -- 
		male = {
			['tshirt_1'] = 130,  ['tshirt_2'] = 0,
			['torso_1'] = 118,   ['torso_2'] = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 28,
			['pants_1'] = 33,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 107,  ['helmet_2'] = 20,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['glasses_1'] = 0, 	['glasses_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 0,  	['bproof_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,	
		},
		female = {
			tshirt_1 = 36,  tshirt_2 = 1,
			torso_1 = 48,   torso_2 = 0,
			decals_1 = 0,   decals_2 = 0,
			arms = 44,
			pants_1 = 34,   pants_2 = 0,
			shoes_1 = 27,   shoes_2 = 0,
			helmet_1 = 45,  helmet_2 = 0,
			chain_1 = 0,    chain_2 = 0,
			ears_1 = 2,     ears_2 = 0
		}
	},

	gilet_wear = { -- جاكيت التدريب
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}, 
	bullet_swat = { -- ضابط قوات خاصة
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 274,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 25,   ['pants_2'] = 6,
			['shoes_1'] = 35,   ['shoes_2'] = 0,
			['helmet_1'] = 5,  ['helmet_2'] = 2,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['glasses_1'] = 24, 	['glasses_2'] = 1,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['mask_1'] = 52,    ['mask_2'] = 0,
			['bproof_1'] = 6,  	['bproof_2'] = 1,
			['chain_1'] = 0,    ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 53,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 33,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 117,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 1,
			['glasses_1'] = 0, 	['glasses_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['mask_1'] = 52,    ['mask_2'] = 0,
			['bproof_1'] = 4,  	['bproof_2'] = 1,
			['chain_1'] = 1,    ['chain_2'] = 0
		},
	},
	cid_badge = { -- باقة الامن الجنائي
		male = {
			--['chain_1'] = 125,  ['chain_2'] = 0
			['chain_1'] = 128,  ['chain_2'] = 0
		},
		female = {
			['chain_1'] = 128,  ['chain_2'] = 0
		}
	},
	cid_badge_remove = { -- إزالة باقة الامن الجنائي
		male = {
			['chain_1'] = 0,  ['chain_2'] = 0
		},
		female = {
			['chain_1'] = 0,  ['chain_2'] = 0
		}
	},
	helmet_2_1 = { -- باقة الامن الجنائي
		male = {
			['helmet_1'] = 247,  ['helmet_2'] = 0
		},
		female = {
			['chain_1'] = 128,  ['chain_2'] = 0
		}
	},
	helmet_2_2 = { -- باقة الامن الجنائي
		male = {
			['helmet_1'] = 2,  ['helmet_2'] = 0
		},
		female = {
			['chain_1'] = 128,  ['chain_2'] = 0
		}
	},
	boreh_add = { -- باقة الامن الجنائي
		male = {
			['bproof_1'] = 73,  ['bproof_2'] = 0
		},
		female = {
			['chain_1'] = 128,  ['chain_2'] = 0
		}
	},

	gun_bealt = {        	-- حزام مسدس
		male = {
			['tshirt_1'] = 130,  ['tshirt_2'] = 0
		},
		female = {       
			['tshirt_1'] = 130,  ['tshirt_2'] = 0
		}
	},
	radio_bealt = { -- حزام لاسلكي ومطاعة
		male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0
		},
		female = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0
		}
	},

	hzam = { -- حزام
		male = {
			['tshirt_1'] = 130,  ['tshirt_2'] = 0
		},
		female = {
			['tshirt_1'] = 122,  ['tshirt_2'] = 0
		}
	},

	weapon_one_in_rgl = {
		male = {
			['chain_1'] = 1,
			['chain_2'] = 0,
		},
		famle = {
			['chain_1'] = 1,
			['chain_2'] = 0,
		}
	},

	

	remove_weapon_one_in_rgl = {
		male = {
			['chain_1'] = 0,  ['chain_2'] = 0
		},
		female = {
			['chain_1'] = 0,  ['chain_2'] = 0
		}
	},

	remove_hzam = { -- حزام
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0
		},
		female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0
		}
	},

	black_jacket = { -- جاكيت اسود
		male = {
			['tshirt_1'] = 56,  ['tshirt_2'] = 0
		},
		female = {
			['tshirt_1'] = 56,  ['tshirt_2'] = 0
		}
	},   
	
	bullet_environmental = { -- درع إدارة الشرطة
		male = {
			['bproof_1'] = 81,  ['bproof_2'] = 0
		},
		female = {
			['bproof_1'] = 21,  ['bproof_2'] = 0
		}
	},

	helmet_open_environmental = { 	-- خوذة اسود مفتوح 
		male = {
			['helmet_1'] = 126,  ['helmet_2'] = 14
		},
		female = {
			['helmet_1'] = 126,  ['helmet_2'] = 18
		}
	},
	helmet_1 = { --بريهة أحمر
		male = {
			['helmet_1'] = 29,  ['helmet_2'] = 1,
		},
		female = {
			['helmet_1'] = 29,  ['helmet_2'] = 1,
		}
	},
	helmet_2 = { --كاب أسود
		male = {
			['helmet_1'] = 3,  ['helmet_2'] = 1,
		},
		female = {
			['helmet_1'] = 106,  ['helmet_2'] = 20,
		}
	},
	
	helmet_55 = { --بريهة أسود
		male = {
			['helmet_1'] = 29,  ['helmet_2'] = 0,
		},
		female = {
			['helmet_1'] = 29,  ['helmet_2'] = 0,
		}
	},
	
	helmet_close_environmental = {	-- خوذة اسود مغلق
		male = {
			['helmet_1'] = 125,  ['helmet_2'] = 14
		},
		female = {
			['helmet_1'] = 125,  ['helmet_2'] = 18
		}
	},
	
	cid_wear = { -- مباحث
		male = {
			['tshirt_1'] = 130,  ['tshirt_2'] = 0,
			['torso_1'] = 43,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 20,   ['pants_2'] = 2,
			['shoes_1'] = 14,   ['shoes_2'] = 2,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0
		},
		female = {
			['tshirt_1'] = 130,  ['tshirt_2'] = 0,
			['torso_1'] = 43,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 20,   ['pants_2'] = 2,
			['shoes_1'] = 14,   ['shoes_2'] = 2,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 0,     ['ears_2'] = 0
		}
	},
    empty = { -- مباحث
		male = {
		},
		female = {
		}
	},
	
	mask_remove = { -- إزالة j
		male = {
			['mask_1'] = 0,		['mask_2'] = 0,
		},
		female = {
			['mask_1'] = 0,		['mask_2'] = 0,
		}
	},

	helmet_remove = { -- إزالة غطاء راس
		male = {
			['helmet_1'] = -1, ['helmet_2'] = 0
		},
		female = {
			['helmet_1'] = -1, ['helmet_2'] = 0
		}
	},

	bullet_wear = {
		male = {
			['bproof_1'] = 4,  	['bproof_2'] = 1,
		},
		female = {
			['bproof_1'] = 4,  	['bproof_2'] = 1,
		}
	},

	gilet_wear = {
		male = {
			tshirt_1 = 59,  tshirt_2 = 1
		},
		female = {
			tshirt_1 = 36,  tshirt_2 = 1
		}
	}
}
return Config