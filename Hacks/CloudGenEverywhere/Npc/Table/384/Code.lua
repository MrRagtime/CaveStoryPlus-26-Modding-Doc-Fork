-- 雲(Fall)
-- Cloud
local function ActNpc384(npc)
	local rc = {
		{left =   320, top =   0, right = 528, bottom =  64}, --208  default: left =   0, top =   0, right = 208, bottom =  64
		{left =  352, top =  64, right = 464, bottom =  96}, --112  default: left =  32, top =  64, right = 144, bottom =  96
		{left =  352, top =  96, right = 424, bottom = 128}, -- 72  default: left =  32, top =  96, right = 104, bottom = 128
		{left = 424, top =  96, right = 464, bottom = 128}, -- 40  default: left = 104, top =  96, right = 144, bottom = 128
	}
	if npc.act_no == 0 then
		npc.act_no = 1
		npc.ani_no = cs.mod(npc.direct, 4)
		-- 上へ
		if npc.direct == 0 then
			npc.ym = -8 * cs.VS
			npc.view.back = 104 * cs.VS
			npc.view.front = 104 * cs.VS
		elseif npc.direct == 1 then
			npc.ym = -4 * cs.VS
			npc.view.back = 56 * cs.VS
			npc.view.front = 56 * cs.VS
		elseif npc.direct == 2 then
			npc.ym = -2 * cs.VS
			npc.view.back = 32 * cs.VS
			npc.view.front = 32 * cs.VS
		elseif npc.direct == 3 then
			npc.ym = -1 * cs.VS
			npc.view.back = 20 * cs.VS
			npc.view.front = 20 * cs.VS
		-- 左へ
		elseif npc.direct == 4 then
			npc.xm = -2 * cs.VS
			npc.view.back = 104 * cs.VS
			npc.view.front = 104 * cs.VS
		elseif npc.direct == 5 then
			npc.xm = -1 * cs.VS
			npc.view.back = 56 * cs.VS
			npc.view.front = 56 * cs.VS
		elseif npc.direct == 6 then
			npc.xm = cs.div(-cs.VS, 2)
			npc.view.back = 32 * cs.VS
			npc.view.front = 32 * cs.VS
		elseif npc.direct == 7 then
			npc.xm = cs.div(-cs.VS, 4)
			npc.view.back = 20 * cs.VS
			npc.view.front = 20 * cs.VS
		end
	elseif npc.act_no == 1 then
		npc.x = npc.x + npc.xm
		npc.y = npc.y + npc.ym
		if npc.x < -64 * cs.VS then
			npc.cond = 0
		end
		if npc.y < -32 * cs.VS then
			npc.cond = 0
		end
	end
	npc.rect = rc[1 + npc.ani_no]
end

return ActNpc384
