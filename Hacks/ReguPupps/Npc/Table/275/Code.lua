-- ゴン太(大農園へおとどけ)
-- Puppy (with items) (sitting)
local function ActNpc275(npc)
	local rcRight = {
		{left = 272, top =  354, right = 288, bottom =  370},
		{left = 288, top =  354, right = 304, bottom =  370}, -- まばたき
		{left = 272, top =  354, right = 288, bottom =  370}, -- シッポフリフリ
		{left = 304, top =  354, right = 320, bottom =  370},
	}
	-- og values
	-- note by Dr. Ragtime: I think these values may be a bug as 80 is the croc and 96 is nothing?
	-- 	local rcRight = {
		--{left = 272, top =  80, right = 288, bottom =  96},
		--{left = 288, top =  80, right = 304, bottom =  96}, -- まばたき
		--{left = 272, top =  80, right = 288, bottom =  96}, -- シッポフリフリ
		--{left = 304, top =  80, right = 320, bottom =  96},
	--}

	if npc.act_no == 0 or npc.act_no == 1 then
		if npc.act_no == 0 then
			npc.act_no   = 1
			npc.ani_no   = 0
			npc.ani_wait = 0
		end

		-- 待機 ---
		if cs.Random(0, 120) == 10 then
			npc.act_no   = 2
			npc.act_wait = 0
			npc.ani_no   = 1
		end
		-- 近づくとフリフリ
		for mc_no = 0, cs.gNumMyChar - 1 do
			if npc.x - cs.PARTSSIZE * 4 * cs.VS < cs.gMC[1 + mc_no].x and npc.x + cs.PARTSSIZE * 4 * cs.VS > cs.gMC[1 + mc_no].x and npc.y - cs.PARTSSIZE * 2 * cs.VS < cs.gMC[1 + mc_no].y and npc.y + cs.PARTSSIZE * 1 * cs.VS > cs.gMC[1 + mc_no].y then
				npc.ani_wait = npc.ani_wait + 1
				if npc.ani_wait > 3 then
					npc.ani_wait = 0
					npc.ani_no = npc.ani_no + 1
				end
				if npc.ani_no > 3 then
					npc.ani_no = 2
				end
				break
			end
		end
	elseif npc.act_no == 2 then
		-- 瞬く
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 8 then
			npc.act_no = 1
			npc.ani_no = 0
		end
	end

	npc.ym = npc.ym + cs.div(cs.VS, 8)
	if npc.ym > cs.MAX_MOVE then
		npc.ym = cs.MAX_MOVE
	end

	npc.x = npc.x + npc.xm
	npc.y = npc.y + npc.ym
	npc.rect = rcRight[1 + npc.ani_no]
end

return ActNpc275
