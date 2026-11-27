-- ゴン太(フリフリ)
-- Puppy (tail wag)
local function ActNpc130(npc)
	cs.NpCharSetNearestXYTargetMC(npc)
	local rcLeft = {
		{left =  48, top = 354, right =  64, bottom = 370},
		{left =  64, top = 354, right =  80, bottom = 370}, -- まばたき
		{left =  48, top = 354, right =  64, bottom = 370}, -- シッポフリフリ
		{left =  80, top = 354, right =  96, bottom = 370},
	}
	local rcRight = {
		{left =  48, top = 370, right =  64, bottom = 386},
		{left =  64, top = 370, right =  80, bottom = 386}, -- まばたき
		{left =  48, top = 370, right =  64, bottom = 386}, -- シッポフリフリ
		{left =  80, top = 370, right =  96, bottom = 386},
	}
	-- og values
	--	local rcLeft = {
		--{left =  48, top = 144, right =  64, bottom = 160},
		--{left =  64, top = 144, right =  80, bottom = 160}, -- まばたき
		--{left =  48, top = 144, right =  64, bottom = 160}, -- シッポフリフリ
		--{left =  80, top = 144, right =  96, bottom = 160},
	--}
	--local rcRight = {
		--{left =  48, top = 160, right =  64, bottom = 176},
		--{left =  64, top = 160, right =  80, bottom = 176}, -- まばたき
		--{left =  48, top = 160, right =  64, bottom = 176}, -- シッポフリフリ
		--{left =  80, top = 160, right =  96, bottom = 176},
	--}
	if npc.act_no == 0 or npc.act_no == 1 then
		if npc.act_no == 0 then
			npc.act_no   = 1
			npc.ani_no   = 0
			npc.ani_wait = 0
			npc.bits = npc.bits | cs.BITS_EVENT_CHECK
		end

		-- 待機 ---
		if cs.Random(0, 120) == 10 then
			npc.act_no   = 2
			npc.act_wait = 0
			npc.ani_no   = 1
		end
		-- さらに近づくとフリフリ
		if npc.x - cs.PARTSSIZE * 4 * cs.VS < cs.gMC[1 + npc.tgt_mc].x and npc.x + cs.PARTSSIZE * 4 * cs.VS > cs.gMC[1 + npc.tgt_mc].x and npc.y - cs.PARTSSIZE * 2 * cs.VS < cs.gMC[1 + npc.tgt_mc].y and npc.y + cs.PARTSSIZE * 1 * cs.VS > cs.gMC[1 + npc.tgt_mc].y then
			npc.ani_wait = npc.ani_wait + 1
			if npc.ani_wait > 3 then
				npc.ani_wait = 0
				npc.ani_no = npc.ani_no + 1
			end
			if npc.ani_no > 3 then
				npc.ani_no = 2
			end
		end
		-- 近づくとふり向く…。
		if npc.x - cs.PARTSSIZE * 6 * cs.VS < cs.gMC[1 + npc.tgt_mc].x and npc.x + cs.PARTSSIZE * 6 * cs.VS > cs.gMC[1 + npc.tgt_mc].x and npc.y - cs.PARTSSIZE * 2 * cs.VS < cs.gMC[1 + npc.tgt_mc].y and npc.y + cs.PARTSSIZE * 1 * cs.VS > cs.gMC[1 + npc.tgt_mc].y then
			if npc.x > cs.gMC[1 + npc.tgt_mc].x then
				npc.direct = cs.DIR_LEFT
			else
				npc.direct = cs.DIR_RIGHT
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

	if npc.direct == cs.DIR_LEFT then
		npc.rect = rcLeft[1 + npc.ani_no]
	else
		npc.rect = rcRight[1 + npc.ani_no]
	end
end

return ActNpc130
