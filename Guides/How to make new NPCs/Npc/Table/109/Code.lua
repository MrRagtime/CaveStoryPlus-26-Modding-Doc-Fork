-- ひしゃげマルコ
-- Malco (damaged)
local function ActNpc109(npc)
	local rcLeft = {
		{left = 240, top =   0, right = 256, bottom =  24}, -- 停止
		{left = 256, top =   0, right = 272, bottom =  24},
	}

	local rcRight = {
		{left = 240, top =  24, right = 256, bottom =  48}, -- 停止
		{left = 256, top =  24, right = 272, bottom =  48},
	}

	if npc.act_no == 0 or npc.act_no == 1 then
		if npc.act_no == 0 then
			npc.act_wait = npc.act_wait - 1
			if npc.act_wait ~= 0 then
				npc.act_no   = 1
			end
			npc.ani_no   = 0
			npc.ani_wait = 0
		end

		--待機
		if cs.Random(0, 120) == 10 then
			npc.act_no   = 2
			npc.act_wait = 0
			npc.ani_no   = 1
		end
		--近づくとふり向く…。
		for mc_no = 0, cs.gNumMyChar - 1 do
			if npc.x - cs.PARTSSIZE * 2 * cs.VS < cs.gMC[1 + mc_no].x and npc.x + cs.PARTSSIZE * 2 * cs.VS > cs.gMC[1 + mc_no].x and npc.y - cs.PARTSSIZE * 2 * cs.VS < cs.gMC[1 + mc_no].y and npc.y + cs.PARTSSIZE * 1 * cs.VS > cs.gMC[1 + mc_no].y then
				if npc.x > cs.gMC[1 + mc_no].x then
					npc.direct = cs.DIR_LEFT
				else
					npc.direct = cs.DIR_RIGHT
				end
				break
			end
		end
	elseif npc.act_no == 2 then
		--瞬く
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 8 then
			npc.act_no = 1
			npc.ani_no = 0
		end
	elseif npc.act_no == 10 then
		-- 起立
		npc.act_no   = 0
		cs.PlaySoundObject(cs.WAVE_BREAK1, 1)
		for i = 0, 7 do
			cs.SetNpChar(4, npc.x, npc.y, cs.Random(cs.div(-cs.VS * 2, 3), cs.div(cs.VS * 2, 3)), cs.Random(-3 * cs.VS, 0), cs.DIR_LEFT, nil, cs.div(cs.MAX_NPC, 2))
		end
	end

	npc.ym = npc.ym + cs.div(cs.VS, 8)

	if npc.ym > cs.MAX_MOVE then
		npc.ym = cs.MAX_MOVE
	end

	npc.y = npc.y + npc.ym

	if npc.direct == cs.DIR_LEFT then
		npc.rect = rcLeft[1 + npc.ani_no]
	else
		npc.rect = rcRight[1 + npc.ani_no]
	end
end

return ActNpc109
