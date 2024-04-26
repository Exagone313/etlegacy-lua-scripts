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

local modname = "Alternative Main Weapon"
local version = "1.0"

function et_InitGame(levelTime, randomSeed, restart)
	et.RegisterModname(modname .. " v" .. version)
end

function et_ClientSpawn(clientNum, revived, teamChange, restoreHealth)
	if revived ~= 0 then
		return
	end
	team = et.gentity_get(clientNum, "sess.sessionTeam")
	class = et.gentity_get(clientNum, "sess.playerType")
	if class == 4 then -- PC_COVERTOPS
		return
	end
	if team == et.TEAM_AXIS then
		et.AddWeaponToPlayer(clientNum, et.WP_THOMPSON, 60, 30, 0)
	elseif team == et.TEAM_ALLIES then
		et.AddWeaponToPlayer(clientNum, et.WP_MP40, 60, 30, 0)
	end
end
