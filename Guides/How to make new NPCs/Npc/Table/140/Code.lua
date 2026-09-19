-- トロ子（狂暴化）
-- Rabid Toroko (Malco Boss Fight)
local function ActNpc140(npc)
	local rcLeft = {
		{left =   0, top =   0, right =  32, bottom =  32},
		{left =  32, top =   0, right =  64, bottom =  32},
		{left =  64, top =   0, right =  96, bottom =  32}, -- かがみ
		{left =  96, top =   0, right = 128, bottom =  32}, -- ジャンプ
		{left = 128, top =   0, right = 160, bottom =  32}, -- 構え
		{left = 160, top =   0, right = 192, bottom =  32}, -- 投げ
		{left = 192, top =   0, right = 224, bottom =  32}, -- 構え（空中）
		{left = 224, top =   0, right = 256, bottom =  32}, -- 投げ（空中）

		{left =   0, top =  64, right =  32, bottom =  96}, --トロ子
		{left =  32, top =  64, right =  64, bottom =  96}, --変か
		{left =  64, top =  64, right =  96, bottom =  96},

		{left =  96, top =  64, right = 128, bottom =  96}, --ガク
		{left = 128, top =  64, right = 160, bottom =  96}, --バタ
		{left =   0, top =   0, right =   0, bottom =   0},
	}
	local rcRight = {
		{left =   0, top =  32, right =  32, bottom =  64},
		{left =  32, top =  32, right =  64, bottom =  64},
		{left =  64, top =  32, right =  96, bottom =  64}, --2 かがみ
		{left =  96, top =  32, right = 128, bottom =  64}, --3 ジャンプ
		{left = 128, top =  32, right = 160, bottom =  64}, --4 構え
		{left = 160, top =  32, right = 192, bottom =  64}, --5 投げ
		{left = 192, top =  32, right = 224, bottom =  64}, --6 構え（空中）
		{left = 224, top =  32, right = 256, bottom =  64}, -- 投げ（空中）

		{left =   0, top =  96, right =  32, bottom = 128}, --8トロ子
		{left =  32, top =  96, right =  64, bottom = 128}, --9変か
		{left =  64, top =  96, right =  96, bottom = 128},

		{left =  96, top =  96, right = 128, bottom = 128}, --11ガク
		{left = 128, top =  96, right = 160, bottom = 128}, --12バタ
		{left =   0, top =   0, right =   0, bottom =   0},
	}

	if npc.act_no == 0 or npc.act_no == 1 then
		if npc.act_no == 0 then
			npc.act_no   = 1
			npc.ani_no   = 9
			npc.act_wait = 0
			npc.bits = npc.bits & ~cs.BITS_EVENT_CHECK
		end
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 50 then
			npc.act_no   = 2
			npc.act_wait = 0
			npc.ani_no   = 8
		end
	elseif npc.act_no == 2 then
		-- 変化
		npc.ani_no = npc.ani_no + 1
		if npc.ani_no > 10 then
			npc.ani_no = 9
		end

		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 50 then
			npc.act_no   = 3
			npc.act_wait = 0
			npc.ani_no   = 0
		end
	elseif npc.act_no == 3 then
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 50 then
			npc.act_no = 10
			npc.bits = npc.bits | cs.BITS_BANISH_DAMAGE
		end
	elseif npc.act_no == 10 or npc.act_no == 11 then
		--直立 ---
		if npc.act_no == 10 then
			npc.bits = npc.bits
			npc.act_no   = 11
			npc.ani_no   = 0
			npc.ani_wait = 0
			npc.act_wait = cs.Random(20, 130)
			npc.xm       = 0
			cs.NpCharSetNearestXTargetMC(npc)
		end

		if npc.x > cs.gMC[1 + npc.tgt_mc].x then
			npc.direct = cs.DIR_LEFT
		else
			npc.direct = cs.DIR_RIGHT
		end
		npc.ani_wait = npc.ani_wait + 1
		if npc.ani_wait > 4 then
			npc.ani_wait = 0
			npc.ani_no = npc.ani_no + 1
		end
		if npc.ani_no > 1 then
			npc.ani_no = 0
		end

		if cs.CountArmsBulletAll(6) ~= 0 or cs.CountArmsBulletAll(3) > 3 * cs.gNumMyChar then
			npc.act_no = 20
		end

		if npc.act_wait ~= 0 then
			npc.act_wait = npc.act_wait - 1
		else
			if cs.mod(cs.Random(0, 99), 2) ~= 0 then
				npc.act_no = 20
			else
				npc.act_no = 50
			end
		end
	elseif npc.act_no == 20 or npc.act_no == 21 then
		--かがみ → ジャンプ → 投げ → 着陸 ---
		if npc.act_no == 20 then
			npc.act_no   = 21
			npc.ani_no   = 2
			npc.act_wait = 0
			cs.NpCharSetNearestXTargetMC(npc)
		end

		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 10 then
			npc.act_no   = 22
			npc.act_wait = 0
			npc.ani_no   = 3
			npc.ym       = -cs.MAX_MOVE
			if npc.direct == cs.DIR_LEFT then
				npc.xm = -cs.VS
			else
				npc.xm = cs.VS
			end
		end
	elseif npc.act_no == 22 then
		--滞空
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 10 then
			npc.act_no   = 23
			npc.act_wait = 0
			npc.ani_no   = 6
			cs.SetNpChar(141, 0, 0, 0, 0, cs.DIR_LEFT, npc, 0)
		end
	elseif npc.act_no == 23 then
		--かまえ
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 30 then
			npc.act_no   = 24
			npc.act_wait = 0
			npc.ani_no   = 7
		end
		if npc.x > cs.gMC[1 + npc.tgt_mc].x then
			npc.direct = cs.DIR_LEFT
		else
			npc.direct = cs.DIR_RIGHT
		end
	elseif npc.act_no == 24 then
		--なげ		
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 3 then
			npc.act_no   = 25
			npc.ani_no   = 3
		end
	elseif npc.act_no == 25 then
		if npc.flag & cs.FLAG_HIT_BOTTOM ~= 0 then
			npc.act_no   = 26
			npc.act_wait = 0
			npc.ani_no   = 2
			cs.PlaySoundObject(cs.WAVE_QUAKE, 1)
			cs.SetQuake(20)
		end
	elseif npc.act_no == 26 then
		--着陸
		npc.xm = cs.div(npc.xm * 8, 9)
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 20 then
			npc.act_no = 10
			npc.ani_no = 0
		end
	elseif npc.act_no == 50 or npc.act_no == 51 then
		--かまえ
		if npc.act_no == 50 then
			npc.act_no   = 51
			npc.act_wait = 0
			npc.ani_no   = 4
			cs.SetNpChar(141, 0, 0, 0, 0, cs.DIR_LEFT, npc, 0)
			cs.NpCharSetNearestXTargetMC(npc)
		end

		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 30 then
			npc.act_no   = 52
			npc.act_wait = 0
			npc.ani_no   = 5
		end
		if npc.x > cs.gMC[1 + npc.tgt_mc].x then
			npc.direct = cs.DIR_LEFT
		else
			npc.direct = cs.DIR_RIGHT
		end
	elseif npc.act_no == 52 then
		--なげ
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 3 then
			npc.act_no   = 10
			npc.ani_no   = 0
		end
	elseif npc.act_no == 100 then
		-- やられ -----------
		npc.ani_no = 3
		npc.act_no = 101
		npc.bits = npc.bits & ~cs.BITS_BANISH_DAMAGE
		npc.damage = 0
		for i = 0, 7 do
			cs.SetNpChar(4, npc.x + cs.Random(-12, 12) * cs.VS, npc.y + cs.Random(-12, 12) * cs.VS, cs.Random(cs.div(-cs.VS * 2, 3), cs.div(cs.VS * 2, 3)), cs.Random(-3 * cs.VS, 0), cs.DIR_LEFT, nil, cs.div(cs.MAX_NPC, 2))
		end
	elseif npc.act_no == 101 then
		if npc.flag & cs.FLAG_HIT_BOTTOM ~= 0 then
			npc.act_no   = 102
			npc.act_wait = 0
			npc.ani_no   = 2
			cs.PlaySoundObject(cs.WAVE_QUAKE, 1)
			cs.SetQuake(20)
		end
	elseif npc.act_no == 102 then
		--着陸
		npc.xm = cs.div(npc.xm * 8, 9)
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 50 then
			npc.act_no   = 103
			npc.act_wait = 0
			npc.ani_no   = 10
		end
	elseif npc.act_no == 103 then
		--うがあ･･
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 50 then
			npc.ani_no   = 9
			npc.act_no = 104
			npc.act_wait = 0
		end
	elseif npc.act_no == 104 then
		-- 変化
		npc.ani_no = npc.ani_no + 1
		if npc.ani_no > 10 then
			npc.ani_no =  9
		end

		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 100 then
			npc.act_wait =   0
			npc.ani_no   =   9
			npc.act_no   = 105
		end
	elseif npc.act_no == 105 then
		-- ああ…
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 50 then
			npc.ani_wait =   0
			npc.act_no   = 106
			npc.ani_no   =  11
		end
	elseif npc.act_no == 106 then
		-- ガク…バタ
		npc.ani_wait = npc.ani_wait + 1
		if npc.ani_wait > 50 then
			npc.ani_wait = 0
			npc.ani_no = npc.ani_no + 1
		end
		if npc.ani_no > 12 then
			npc.ani_no = 12
		end
	elseif npc.act_no == 140 or npc.act_no == 141 then
		-- 消滅 ====
		if npc.act_no == 140 then
			npc.act_no   = 141
			npc.act_wait =  0
			npc.ani_no   = 12
			cs.PlaySoundObject(cs.WAVE_WARP, 1)
		end

		npc.ani_no = npc.ani_no + 1
		if npc.ani_no > 13 then
			npc.ani_no = 12
		end
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 100 then
			for i = 0, 3 do
				cs.SetNpChar(4, npc.x + cs.Random(-12, 12) * cs.VS, npc.y + cs.Random(-12, 12) * cs.VS, cs.Random(cs.div(-cs.VS * 2, 3), cs.div(cs.VS * 2, 3)), cs.Random(-3 * cs.VS, 0), cs.DIR_LEFT, nil, cs.div(cs.MAX_NPC, 2))
			end
			npc.cond = 0
		end
	end

	if npc.act_no > 100 and npc.act_no < 105 then
		if cs.mod(npc.act_wait, 9) == 0 then
			cs.SetNpChar(4, npc.x + cs.Random(-12, 12) * cs.VS, npc.y + cs.Random(-12, 12) * cs.VS, cs.Random(cs.div(-cs.VS * 2, 3), cs.div(cs.VS * 2, 3)), cs.Random(-3 * cs.VS, 0), cs.DIR_LEFT, nil, cs.div(cs.MAX_NPC, 2))
		end
	end

	npc.ym = npc.ym + cs.div(cs.VS, 16)

	if npc.ym > cs.MAX_MOVE then
		npc.ym =  cs.MAX_MOVE
	end
	if npc.ym < -cs.MAX_MOVE then
		npc.ym = -cs.MAX_MOVE
	end

	npc.x = npc.x + npc.xm
	npc.y = npc.y + npc.ym

	if npc.direct == cs.DIR_LEFT then
		npc.rect = rcLeft[1 + npc.ani_no]
	else
		npc.rect = rcRight[1 + npc.ani_no]
	end
end

return ActNpc140
