-- マルコ
local function ActNpc107(npc)
	if npc.act_no == 0 or npc.act_no == 1 then
		-- 座り
		if npc.act_no == 0 then
			npc.act_no = 1
			if npc.direct == cs.DIR_RIGHT then
				npc.ani_no = 5
			end
		end
		
	elseif npc.act_no == 10 or npc.act_no == 11 then
		-- 起動 -----------------
		if npc.act_no == 10 then
			-- 点滅
			npc.act_no   = 11
			npc.act_wait =  0
			npc.ani_wait =  0
			for i = 0, 3 do
				cs.SetNpChar(4, npc.x, npc.y, cs.Random(cs.div(-cs.VS * 2, 3), cs.div(cs.VS * 2, 3)), cs.Random(-3 * cs.VS, 0), cs.DIR_LEFT, nil, cs.div(cs.MAX_NPC, 2))
			end
		end
		npc.ani_wait = npc.ani_wait + 1
		if npc.ani_wait > 1 then
			cs.PlaySoundObject(cs.WAVE_ON, 1)
			npc.ani_wait = 0
			npc.ani_no = npc.ani_no + 1
		end
		if npc.ani_no > 1 then
			npc.ani_no = 0
		end

		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 50 * 2 then
			npc.act_no = 12
		end
	elseif npc.act_no == 12 or npc.act_no == 13 then
		-- 点灯
		if npc.act_no == 12 then
			npc.act_no   = 13
			npc.act_wait =  0
			npc.ani_no   =  1
		end
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 50 then
			npc.act_no = 14
		end
	elseif npc.act_no == 14 or npc.act_no == 15 then
		--がたがた
		if npc.act_no == 14 then
			npc.act_no   = 15
			npc.act_wait =  0
		end
		if cs.mod(cs.div(npc.act_wait, 2), 2) ~= 0 then
			npc.x = npc.x + cs.VS
			cs.PlaySoundObject(cs.WAVE_DOOR, 1)
		else
			npc.x = npc.x - cs.VS
		end
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 50 then
			npc.act_no = 16
		end
	elseif npc.act_no == 16 or npc.act_no == 17 then
		-- 起立
		if npc.act_no == 16 then
			npc.act_no   = 17
			npc.act_wait =  0
			npc.ani_no   =  2
			cs.PlaySoundObject(cs.WAVE_BREAK1, 1)
			for i = 0, 7 do
				cs.SetNpChar(4, npc.x, npc.y, cs.Random(cs.div(-cs.VS * 2, 3), cs.div(cs.VS * 2, 3)), cs.Random(-3 * cs.VS, 0), cs.DIR_LEFT, nil, cs.div(cs.MAX_NPC, 2))
			end
		end
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 50 * 3 then
			npc.act_no = 18
		end
	elseif npc.act_no == 18 or npc.act_no == 19 then
		-- 屈伸
		if npc.act_no == 18 then
			npc.act_no   = 19
			npc.act_wait =  0
			npc.ani_no   =  3
			npc.ani_wait =  0
		end
		npc.ani_wait = npc.ani_wait + 1
		if npc.ani_wait > 3 then
			npc.ani_wait = 0
			npc.ani_no = npc.ani_no + 1
		end
		if npc.ani_no > 4 then
			cs.PlaySoundObject(cs.WAVE_DOOR, 1)
			npc.ani_no = 3
		end

		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 50 * 2 then
			npc.act_no = 20
			cs.PlaySoundObject(cs.WAVE_BREAK1, 1)
			for i = 0, 3 do
				cs.SetNpChar(4, npc.x, npc.y, cs.Random(cs.div(-cs.VS * 2, 3), cs.div(cs.VS * 2, 3)), cs.Random(-3 * cs.VS, 0), cs.DIR_LEFT, nil, cs.div(cs.MAX_NPC, 2))
			end
		end
	elseif npc.act_no == 20 then
		-- ポーズ
		npc.ani_no = 4
	elseif npc.act_no == 21 or npc.act_no == 22 then
		-- クシャ
		if npc.act_no == 21 then
			npc.act_no = 22
			npc.ani_no = 5
			cs.PlaySoundObject(cs.WAVE_NPC_MIDDLE, 1)
		end
	elseif npc.act_no == 100 or npc.act_no == 101 then
		-- ダンス
		if npc.act_no == 100 then
			npc.act_no   = 101
			npc.ani_no   = 6
			npc.ani_wait = 0
		end
		npc.ani_wait = npc.ani_wait + 1
		if npc.ani_wait > 4 then
			npc.ani_wait = 0
			npc.ani_no = npc.ani_no + 1
		end
		if npc.ani_no > 9 then
			npc.ani_no = 6
		end
	elseif npc.act_no == 110 then
		-- 爆破
		cs.SetDestroyNpChar(npc.x, npc.y, 16 * cs.VS, 16)
		npc.cond = 0
	end
	local rcPoweron = {
		{left = 144, top =   0, right = 160, bottom =  24},
		{left = 160, top =   0, right = 176, bottom =  24},
		{left = 176, top =   0, right = 192, bottom =  24},
		{left = 192, top =   0, right = 208, bottom =  24},
		{left = 208, top =   0, right = 224, bottom =  24},
		{left = 224, top =   0, right = 240, bottom =  24}, -- クシャ

		{left = 176, top =   0, right = 192, bottom =  24}, -- 6 ダンス
		{left = 192, top =   0, right = 208, bottom =  24},
		{left = 208, top =   0, right = 224, bottom =  24},
		{left = 192, top =   0, right = 208, bottom =  24},
	}

--	if npc.act_no < 30 then
		npc.rect = rcPoweron[1 + npc.ani_no]
--	end
end

return ActNpc107
