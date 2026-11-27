-- 仔犬コロ
-- Puppy (small)
local function ActNpc305(npc)
	local rcLeft = {
		{left = 160, top = 354, right = 176, bottom = 370},
		{left = 176, top = 354, right = 192, bottom = 370},
	}
	local rcRight = {
		{left = 160, top = 370, right = 176, bottom = 386},
		{left = 176, top = 370, right = 192, bottom = 386},
	}
	-- og values
	-- 	local rcLeft = {
		--{left = 160, top = 144, right = 176, bottom = 160},
		--{left = 176, top = 144, right = 192, bottom = 160},
	--}
	--local rcRight = {
		--{left = 160, top = 160, right = 176, bottom = 176},
		--{left = 176, top = 160, right = 192, bottom = 176},
	--}

	if npc.act_no == 0 or npc.act_no == 1 then
		if npc.act_no == 0 then
			npc.act_no = 1
			npc.y = npc.y - 16 * cs.VS
			npc.ani_wait = cs.Random(0, 6)
		end

		npc.ani_wait = npc.ani_wait + 1
		if npc.ani_wait > 6 then
			npc.ani_wait = 0
			npc.ani_no = npc.ani_no + 1
		end
		if npc.ani_no > 1 then
			npc.ani_no = 0
		end
	end

	if npc.direct == cs.DIR_LEFT then
		npc.rect = rcLeft[ 1 + npc.ani_no]
	else
		npc.rect = rcRight[1 + npc.ani_no]
	end
end

return ActNpc305
