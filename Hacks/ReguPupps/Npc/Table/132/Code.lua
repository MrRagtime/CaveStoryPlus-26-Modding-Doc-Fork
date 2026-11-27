-- ゴン太(ワンワン)
-- Puppy (bark)
local function ActNpc132(npc)
	local rcLeft = {
		{left =  48, top = 354, right =  64, bottom = 370},
		{left =  64, top = 354, right =  80, bottom = 370}, -- まばたき

		{left =  96, top = 354, right = 112, bottom = 370},
		{left =  96, top = 354, right = 112, bottom = 370},
		{left = 128, top = 354, right = 144, bottom = 370}, -- ワンワン！
	}
	local rcRight = {
		{left =  48, top = 370, right =  64, bottom = 386},
		{left =  64, top = 370, right =  80, bottom = 386}, -- まばたき

		{left =  96, top = 370, right = 112, bottom = 386},
		{left =  96, top = 370, right = 112, bottom = 386},
		{left = 128, top = 370, right = 144, bottom = 386}, -- ワンワン！
	}
	-- og values
	--	local rcLeft = {
		--{left =  48, top = 144, right =  64, bottom = 160},
		--{left =  64, top = 144, right =  80, bottom = 160}, -- まばたき

		--{left =  96, top = 144, right = 112, bottom = 160},
		--{left =  96, top = 144, right = 112, bottom = 160},
		--{left = 128, top = 144, right = 144, bottom = 160}, -- ワンワン！
	--}
	--local rcRight = {
		--{left =  48, top = 160, right =  64, bottom = 176},
		--{left =  64, top = 160, right =  80, bottom = 176}, -- まばたき

		--{left =  96, top = 160, right = 112, bottom = 176},
		--{left =  96, top = 160, right = 112, bottom = 176},
		--{left = 128, top = 160, right = 144, bottom = 176}, -- ワンワン！
	--}

	if npc.act_no < 100 then
		if cs.gMC[1 + npc.tgt_mc].x < npc.x then
			npc.direct = cs.DIR_LEFT
		else
			npc.direct = cs.DIR_RIGHT
		end
	end

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
		-- さらに近づくとワンワン
		local mc_no
		mc_no = 0
		while mc_no < cs.gNumMyChar do
			if npc.x - cs.PARTSSIZE * 4 * cs.VS < cs.gMC[1 + mc_no].x and npc.x + cs.PARTSSIZE * 4 * cs.VS > cs.gMC[1 + mc_no].x and npc.y - cs.PARTSSIZE * 1 * cs.VS < cs.gMC[1 + mc_no].y and npc.y + cs.PARTSSIZE * 1 * cs.VS > cs.gMC[1 + mc_no].y then
				npc.ani_wait = npc.ani_wait + 1
				if npc.ani_wait > 4 then
					npc.ani_wait = 0
					npc.ani_no = npc.ani_no + 1
				end
				if npc.ani_no > 4 then
					npc.ani_no = 2
				end
				if npc.ani_no == 4 and npc.ani_wait == 0 then
					cs.PlaySoundObject(cs.WAVE_BOWWOW, 1)
				end
				break
			end
			mc_no = mc_no + 1
		end
		if mc_no >= cs.gNumMyChar and npc.ani_no == 4 then
			npc.ani_no = 2
		end
	elseif npc.act_no == 2 then
		-- 瞬く
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 8 then
			npc.act_no = 1
			npc.ani_no = 0
		end
	elseif npc.act_no == 10 or npc.act_no == 11 then
		if npc.act_no == 10 then
			npc.act_no   = 11
			npc.ani_no   = 0
			npc.ani_wait = 0
		end

		-- 待機 ---
		if cs.Random(0, 120) == 10 then
			npc.act_no   = 12
			npc.act_wait = 0
			npc.ani_no   = 1
		end
	elseif npc.act_no == 12 then
		-- 瞬く
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 8 then
			npc.act_no = 11
			npc.ani_no = 0
		end
	elseif npc.act_no == 100 or npc.act_no == 101 then
		--固定ワンワン
		if npc.act_no == 100 then
			npc.act_no = 101
			npc.count1 = 0
		end

		npc.ani_wait = npc.ani_wait + 1
		if npc.ani_wait > 4 then
			npc.ani_wait = 0
			npc.ani_no = npc.ani_no + 1
		end
		if npc.ani_no > 4 then
			if npc.count1 < 3 then
				npc.ani_no = 2
				npc.count1 = npc.count1 + 1
			else
				npc.ani_no = 0
				npc.count1 = 0
			end
		end
		if npc.ani_no == 4 and npc.ani_wait == 0 then
			cs.PlaySoundObject(cs.WAVE_BOWWOW, 1)
		end
	elseif npc.act_no == 120 then
		--固定お座り
		npc.ani_no = 0
	end

	npc.ym = npc.ym + cs.div(cs.VS, 8)
	if npc.ym > cs.MAX_MOVE then
		npc.ym = cs.MAX_MOVE
	end

	npc.x = npc.x + npc.xm
	npc.y = npc.y + npc.ym

	if npc.direct == cs.DIR_LEFT then
		npc.rect = rcLeft[1 + npc.ani_no]
	else
		npc.rect = rcRight[1 + npc.ani_no]
	end
end

return ActNpc132
