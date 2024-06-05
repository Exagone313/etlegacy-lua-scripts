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
	["l"] = function (sender, receiver) -- your location
		--local origin = et.gentity_get(sender, "ps.origin")
		-- TODO BG_GetLocationString(origin[0], origin[1])
		return "?,?"
	end,
	["n"] = function (sender, receiver) -- your name
		return formatUsername(sender)
	end,
	["r"] = function (sender, receiver) -- last player who revived you
		return formatUsername(et.gentity_get(sender, "pers.lastrevive_client"))
	end,
	["p"] = function (sender, receiver) -- last player you looked at
		-- TODO and make sure disguised player name is returned if opposite team
		-- idea: get closest player instead (with a distance limit?)
		return "^7Buddy"
	end,
	["s"] = function (sender, receiver) -- remaining health
		return et.gentity_get(sender, "health")
	end,
	["w"] = function (sender, receiver) -- name of current weapon
		local weapon = et.gentity_get(sender, "ps.weapon")
		if weapon == 1 then
			return "Knife"
		elseif weapon == 2 then
			return "Luger"
		elseif weapon == 3 then
			return "MP 40"
		elseif weapon == 4 then
			return "Grenade"
		elseif weapon == 5 then
			return "Panzerfaust"
		elseif weapon == 6 then
			return "Flamethrower"
		elseif weapon == 7 then
			return "Colt"
		elseif weapon == 8 then
			return "Thompson"
		elseif weapon == 9 then
			return "Pineapple"
		elseif weapon == 10 then
			return "Sten gun"
		elseif weapon == 11 then
			return "Syringe"
		elseif weapon == 12 then
			return "Ammo Pack"
		elseif weapon == 13 then
			return "Artillery"
		elseif weapon == 14 then
			return "Silenced Luger"
		elseif weapon == 15 then
			return "Dynamite Weapon"
		elseif weapon == 20 then
			return "Binoculars"
		elseif weapon == 21 then
			return "Special"
		elseif weapon == 23 then
			return "K43 Rifle"
		elseif weapon == 24 then
			return "M1 Garand"
		elseif weapon == 25 then
			return "Scoped M1 Garand"
		elseif weapon == 26 then
			return "Landmine"
		elseif weapon == 27 then
			return "Satchel Charge"
		elseif weapon == 28 then
			return "Satchel Charge Detonator"
		elseif weapon == 29 then
			return "Smoke Bomb"
		elseif weapon == 30 then
			return "Mobile MG 42"
		elseif weapon == 31 then
			return "Scoped K43 Rifle"
		elseif weapon == 32 then
			return "FG 42 Paratroop Rifle"
		elseif weapon == 34 then
			return "Mortar"
		elseif weapon == 35 then
			return "Akimbo Colt"
		elseif weapon == 36 then
			return "Akimbo Luger"
		elseif weapon == 37 then
			return "GPG40"
		elseif weapon == 38 then
			return "M7"
		elseif weapon == 39 then
			return "Silenced Colt"
		elseif weapon == 40 then
			return "M1 Garand Scope"
		elseif weapon == 41 then
			return "K43 Rifle Scope"
		elseif weapon == 42 then
			return "FG 42 Paratroop Rifle Scope"
		elseif weapon == 43 then
			return "Mounted Mortar"
		elseif weapon == 44 then
			return "Adrenaline Syringe"
		elseif weapon == 45 then
			return "Silenced Akimbo Colt"
		elseif weapon == 46 then
			return "Silenced Akimbo Luger"
		elseif weapon == 47 then
			return "Mobile MG 42 Bipod"
		elseif weapon == 48 then
			return "Ka-Bar"
		elseif weapon == 49 then
			return "Mobile Browning"
		elseif weapon == 50 then
			return "Mobile Browning Bipod"
		elseif weapon == 51 then
			return "Granatwerfer"
		elseif weapon == 52 then
			return "Mounted Granatwerfer"
		elseif weapon == 53 then
			return "Bazooka"
		elseif weapon == 54 then
			return "MP34"
		elseif weapon == 55 then
			return "Airstrike"
		else
			return "Nothing"
		end
	end,
	["t"] = function (sender, receiver) -- ammo for current weapon
		local weapon = et.gentity_get(sender, "ps.weapon")
		local ammo = et.gentity_get(sender, "ps.ammo", weapon)
		local clip = et.gentity_get(sender, "ps.ammoclip", weapon)
		return ammo + clip
	end,
	["c"] = function (sender, receiver) -- name of current class
		local class = et.gentity_get(sender, "sess.playerType")
		if class == 1 then
			return "Medic"
		elseif class == 2 then
			return "Engineer"
		elseif class == 3 then
			return "Field Ops"
		elseif class == 4 then
			return "Covert Ops"
		else
			return "Soldier"
		end
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
	return 1, message:gsub("%[([adghklnrpswtco])%]", function(shortcut)
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
