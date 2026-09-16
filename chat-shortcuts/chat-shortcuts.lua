-- This is free and unencumbered software released into the public domain.
--
-- Anyone is free to copy, modify, publish, use, compile, sell, or
-- distribute this software, either in source code form or as a compiled
-- binary, for any purpose, commercial or non-commercial, and by any
-- means.
--
-- In jurisdictions that recognize copyright laws, the author or authors
-- of this software dedicate any and all copyright interest in the
-- software to the public domain. We make this dedication for the benefit
-- of the public at large and to the detriment of our heirs and
-- successors. We intend this dedication to be an overt act of
-- relinquishment in perpetuity of all present and future rights to this
-- software under copyright law.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
-- OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
-- ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.
--
-- For more information, please refer to <http://unlicense.org/>

local modname = "Chat Shortcuts"
local version = "1.0"

local ENTITYNUM_NONE = (1 << 10) - 1
local ENTITYNUM_WORLD = (1 << 10) - 2

local et_weapons = {
	-- [et.WP_NONE] = "", -- 0
	[et.WP_KNIFE] = "Knife", -- 1
	[et.WP_LUGER] = "Luger 9mm", -- 2 (Luger)
	[et.WP_MP40] = "MP 40", -- 3
	[et.WP_GRENADE_LAUNCHER] = "Grenade", -- 4
	[et.WP_PANZERFAUST] = "Panzerfaust", -- 5
	[et.WP_FLAMETHROWER] = "Flamethrower", -- 6
	[et.WP_COLT] = ".45ACP 1911", -- 7 (Colt)
	[et.WP_THOMPSON] = "Thompson", -- 8
	[et.WP_GRENADE_PINEAPPLE] = "Grenade", -- 9 (Pineapple)
	[et.WP_STEN] = "Sten", -- 10 (Sten gun)
	[et.WP_MEDIC_SYRINGE] = "Syringe", -- 11
	[et.WP_AMMO] = "Ammo Pack", -- 12
	[et.WP_ARTY] = "Artillery", -- 13
	[et.WP_SILENCER] = "Luger 9mm", -- 14 (Silenced Luger)
	[et.WP_DYNAMITE] = "Dynamite", -- 15 (Dynamite Weapon)
	-- [et.WP_SMOKETRAIL] = "", -- 16
	-- [et.WP_MAPMORTAR] = "", -- 17
	-- [et.VERYBIGEXPLOSION] = "", -- 18
	[et.WP_MEDKIT] = "Medic Pack", -- 19
	[et.WP_BINOCULARS] = "Binoculars", -- 20
	[et.WP_PLIERS] = "Pliers", -- 21 (Special)
	[et.WP_SMOKE_MARKER] = "Airstrike Marker", -- 22 (smokeGrenade)
	[et.WP_KAR98] = "K43", -- 23 (K43 Rifle)
	[et.WP_CARBINE] = "Garand", -- 24 (M1 Garand)
	[et.WP_GARAND] = "Garand", -- 25 (Scoped M1 Garand)
	[et.WP_LANDMINE] = "Landmine", -- 26
	[et.WP_SATCHEL] = "Satchel Charge", -- 27
	[et.WP_SATCHEL_DET] = "Satchel Charge Detonator", -- 28
	[et.WP_SMOKE_BOMB] = "Smoke Bomb", -- 29
	[et.WP_MOBILE_MG42] = "Mobile MG 42", -- 30
	[et.WP_K43] = "K43", -- 31 (Scoped K43 Rifle)
	[et.WP_FG42] = "FG 42", -- 32 (FG 42 Paratroop Rifle)
	[et.WP_DUMMY_MG42] = "MG", -- 33 (BLANK)
	[et.WP_MORTAR] = "Mortar", -- 34
	[et.WP_AKIMBO_COLT] = "Akimbo .45ACP 1911s", -- 35 (Akimbo Colt)
	[et.WP_AKIMBO_LUGER] = "Akimbo Luger 9mms", -- 36 (Akimbo Luger)
	[et.WP_GPG40] = "Rifle Grenade", -- 37 (GPG40)
	[et.WP_M7] = "Rifle Grenade", -- 38 (M7)
	[et.WP_SILENCED_COLT] = ".45ACP 1911", -- 39 (Silenced Colt)
	[et.WP_GARAND_SCOPE] = "Garand", -- 40 (M1 Garand Scope)
	[et.WP_K43_SCOPE] = "K43", -- 41 (K43 Rifle Scope)
	[et.WP_FG42_SCOPE] = "FG 42", -- 42 (FG 42 Paratroop Rifle Scope)
	[et.WP_MORTAR_SET] = "Mortar", -- 43 (Mounted Mortar)
	[et.WP_MEDIC_ADRENALINE] = "Adrenaline Syringe", -- 44
	[et.WP_AKIMBO_SILENCEDCOLT] = "Akimbo .45ACP 1911s", -- 45 (Silenced Akimbo Colt)
	[et.WP_AKIMBO_SILENCEDLUGER] = "Akimbo Luger 9mms", -- 46 (Silenced Akimbo Luger)
	[et.WP_MOBILE_MG42_SET] = "Mobile MG 42 Bipod", -- 47
	[et.WP_KNIFE_KABAR] = "Ka-Bar", -- 48
	[et.WP_MOBILE_BROWNING] = "Mobile Browning", -- 49
	[et.WP_MOBILE_BROWNING_SET] = "Mobile Browning Bipod", -- 50
	[et.WP_MORTAR2] = "Granatwerfer", -- 51
	[et.WP_MORTAR2_SET] = "Granatwerfer", -- 52 (Mounted Granatwerfer)
	[et.WP_BAZOOKA] = "Bazooka", -- 53
	[et.WP_MP34] = "MP 34", -- 54 (MP34)
	[et.WP_AIRSTRIKE] = "Airstrike", -- 55
}

local et_classes = {
	[0] = "Soldier",
	[1] = "Medic",
	[2] = "Engineer",
	[3] = "Field Ops",
	[4] = "Covert Ops",
}

local last_killer = {}

function formatUsername(clientNum)
	if clientNum == nil or clientNum < 0 or clientNum == ENTITYNUM_NONE then
		return "^7*unknown*"
	elseif clientNum == ENTITYNUM_WORLD then
		return "^7*world*"
	else
		return "^7" .. et.gentity_get(clientNum, "pers.netname")
	end
end

local shortcuts = {
	["a"] = function (sender, receiver) -- last player who gave you ammo
		return formatUsername(et.gentity_get(sender, "pers.lastammo_client"))
	end,
	["d"] = function (sender, receiver) -- last player who killed you
		return formatUsername(last_killer[sender])
	end,
	["g"] = function (sender, receiver) -- the first 8 characters of your GUID
		local userinfo = et.trap_GetUserinfo(sender, receiver)
		local guid = et.Info_ValueForKey(userinfo, "cl_guid")
		return guid:sub(1, 8)
	end,
	["h"] = function (sender, receiver) -- last player who gave you health
		return formatUsername(et.gentity_get(sender, "pers.lasthealth_client"))
	end,
	["k"] = function (sender, receiver) -- last player you killed
		return formatUsername(et.gentity_get(sender, "pers.lastkilled_client"))
	end,
	["n"] = function (sender, receiver) -- your name
		return formatUsername(sender)
	end,
	["r"] = function (sender, receiver) -- last player who revived you
		return formatUsername(et.gentity_get(sender, "pers.lastrevive_client"))
	end,
	["s"] = function (sender, receiver) -- remaining health
		return et.gentity_get(sender, "health")
	end,
	["w"] = function (sender, receiver) -- name of current weapon
		local weapon = et.gentity_get(sender, "ps.weapon")
		if et_weapons[weapon] ~= nil then
			return et_weapons[weapon]
		end
		return "weapon"
	end,
	["t"] = function (sender, receiver) -- ammo for current weapon
		local weapon = et.gentity_get(sender, "ps.weapon")
		local ammo = et.gentity_get(sender, "ps.ammo", weapon)
		local clip = et.gentity_get(sender, "ps.ammoclip", weapon)
		return ammo + clip
	end,
	["c"] = function (sender, receiver) -- name of current class
		local class = et.gentity_get(sender, "sess.playerType")
		return et_classes[class]
	end,
	["o"] = function (sender, receiver) -- other player receiving the message
		return formatUsername(receiver)
	end,
}

function et_InitGame(levelTime, randomSeed, restart)
	et.RegisterModname(modname .. " v" .. version)
end

function et_Chat(sender, receiver, message)
	local cache = {}
	return 1, message:gsub("%[([adghknrswtco])%]", function(shortcut)
		if cache[shortcut] == nil then
			cache[shortcut] = shortcuts[shortcut](sender, receiver)
		end
		return cache[shortcut]
	end)
end

function et_ClientConnect(clientNum, firstTime, isBot)
	last_killer[clientNum] = ENTITYNUM_NONE
end

function et_ClientDisconnect(clientNum)
	last_killer[clientNum] = nil
end

function et_Obituary(target, attacker, meansOfDeath)
	-- only save obituary when a client is known
	if last_killer[target] ~= nil then
		last_killer[target] = attacker
	end
end
