-- 雲配置
-- CloudSym Generator
local function ActNpc385(npc)
	local x
	local y
	local dir
	local pri

	npc.act_wait = npc.act_wait + 1
	if npc.act_wait > 16 then
		npc.act_wait = cs.Random(0, 16)
		dir = cs.mod(cs.Random(0, 100), 4)

		if npc.direct == cs.DIR_LEFT then
			if dir == 0 then
				pri = cs.div(cs.MAX_NPC, 4) * 3
			elseif dir == 1 then
				pri = cs.div(cs.MAX_NPC, 4)
			elseif dir == 2 then
				pri = cs.div(cs.MAX_NPC, 8)
			elseif dir == 3 then
				pri =                        0
			end
			x = npc.x + cs.Random(-10, 10) * cs.VS * cs.PARTSSIZE
			y = npc.y
			cs.SetNpChar(384, x, y, 0, 0, dir, nil, pri) -- cloudsym
		else
			if dir == 0 then
				pri = cs.div(cs.MAX_NPC, 4)
			elseif dir == 1 then
				pri = cs.div(cs.MAX_NPC, 6)
			elseif dir == 2 then
				pri = cs.div(cs.MAX_NPC, 8)
			elseif dir == 3 then
				pri =                        0
			end
			-- Widescreen hack to make clouds not visibly pop in on the edge of the screen - added X offset. -TSR 2017-03-29
			x = npc.x + 7 * cs.VS * cs.PARTSSIZE
			y = npc.y + cs.Random(-7, 7) * cs.VS * cs.PARTSSIZE
			cs.SetNpChar(384, x, y, 0, 0, dir + 4, nil, pri)
		end
	end
end

return ActNpc385
