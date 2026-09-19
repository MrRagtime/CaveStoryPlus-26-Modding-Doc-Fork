-- ガウディ やられ -- (Starved Gaudi)
local function ActNpc371(npc)
	local rcLeft = {
		{left =   0, top =  96, right =  16, bottom =  118}, --停止
		{left =  16, top =  96, right =  32, bottom =  118}, -- 64, 80 | Default Values for top, & bottom
		
		{left =  32, top =  96, right =  48, bottom =  118},
		{left =  16, top =  96, right =  32, bottom =  118},
		{left =  48, top =  96, right =  64, bottom =  118},
		{left =  16, top =  96, right =  32, bottom =  118},

		{left = 112, top =  96, right = 128, bottom =  118}, --6ふっとび
		{left = 128, top =  96, right = 144, bottom =  118}, --7つぶれ
	}

	local rcRight = {
		{left =   0, top =  96, right =  16, bottom =  118}, --停止
		{left =  16, top =  96, right =  32, bottom =  118}, -- 80, 96 | Default Values for top, & bottom
		
		{left =  32, top =  96, right =  48, bottom =  118},
		{left =  16, top =  96, right =  32, bottom =  118},
		{left =  48, top =  96, right =  64, bottom =  118},
		{left =  16, top =  96, right =  32, bottom =  118},

		{left = 112, top =  96, right = 128, bottom =  118}, --6ふっとび
		{left = 128, top =  96, right = 144, bottom =  118}, --7つぶれ
	}

	if npc.act_no == 0 or npc.act_no == 1 then
		if npc.act_no == 0 then
			npc.act_no   = 1
			npc.ani_no   = 0
			npc.ani_wait = 0
			npc.xm       = 0
		end
		--待機 =============
		if cs.Random(0, 120) == 10 then
			npc.act_no   = 2
			npc.act_wait = 0
			npc.ani_no   = 1
		end
		--近づくとふり向く…。
		for mc_no = 0, cs.gNumMyChar - 1 do
			if npc.x - cs.PARTSSIZE * cs.VS < cs.gMC[1 + mc_no].x and npc.x + cs.PARTSSIZE * cs.VS > cs.gMC[1 + mc_no].x and npc.y - cs.PARTSSIZE * cs.VS < cs.gMC[1 + mc_no].y and npc.y + cs.PARTSSIZE * cs.VS > cs.gMC[1 + mc_no].y then
				if npc.x > cs.gMC[1 + mc_no].x then
					npc.direct = cs.DIR_LEFT
				else
					npc.direct = cs.DIR_RIGHT
				end
			end
		end
	elseif npc.act_no == 2 then
		--瞬く
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 8 then
			npc.act_no = 1
			npc.ani_no = 0
		end
	elseif npc.act_no == 3 or npc.act_no == 4 then
		--走る =============
		if npc.act_no == 3 then
			npc.act_no   = 4
			npc.ani_no   = 1
			npc.ani_wait = 0
		end
		npc.ani_wait = npc.ani_wait + 1
		if npc.ani_wait > 2 then
			npc.ani_wait = 0
			npc.ani_no = npc.ani_no + 1
		end
		if npc.ani_no > 4 then
			npc.ani_no = 1
		end
		if npc.flag & cs.FLAG_HIT_LEFT ~= 0 then
			npc.direct = cs.DIR_RIGHT
			npc.xm = cs.VS
		end
		if npc.flag & cs.FLAG_HIT_RIGHT ~= 0 then
			npc.direct = cs.DIR_LEFT
			npc.xm = -cs.VS
		end
		if npc.direct == cs.DIR_LEFT then
			npc.xm = -2 * cs.VS
		else
			npc.xm = 2 * cs.VS
		end
	elseif npc.act_no == 6 or npc.act_no == 7 then
		--逃げ =============
		if npc.act_no == 6 then
			npc.act_no   = 7
			npc.act_wait = 0
			npc.ani_no   = 1
			npc.ani_wait = 0
			npc.ym = -2 * cs.VS
		end
		npc.ani_wait = npc.ani_wait + 1
		if npc.ani_wait > 2 then
			npc.ani_wait = 0
			npc.ani_no = npc.ani_no + 1
		end
		if npc.ani_no > 4 then
			npc.ani_no = 1
		end
		if npc.direct == cs.DIR_LEFT then
			npc.xm = cs.div(-cs.VS, 2)
		else
			npc.xm = cs.div(cs.VS, 2)
		end

		-- 走る
		if npc.act_wait ~= 0 and npc.flag & cs.FLAG_HIT_BOTTOM ~= 0 then
			npc.act_no = 3
		end
		npc.act_wait = npc.act_wait + 1
	elseif npc.act_no == 8 or npc.act_no == 9 then
		--びっくり =============
		if npc.act_no == 8 then
			npc.ani_no   = 1
			npc.act_wait = 0
			npc.act_no   = 9
			npc.ym       = -1 * cs.VS
		end
		if npc.act_wait ~= 0 and npc.flag & cs.FLAG_HIT_BOTTOM ~= 0 then
			npc.act_no = 0
		end
		npc.act_wait = npc.act_wait + 1
	elseif npc.act_no == 10 then
		npc.act_no = 11
		npc.ani_no = 6
		npc.ym     = -2 * cs.VS
		cs.PlaySoundObject(cs.WAVE_NPC_SMALL, 1)
		if npc.direct == cs.DIR_LEFT then
			npc.xm = cs.div(-cs.VS, 2)
		else
			npc.xm = cs.div(cs.VS, 2)
		end
	elseif npc.act_no == 11 then
		-- こける
		-- ばったり
		if npc.act_wait ~= 0 and npc.flag & cs.FLAG_HIT_BOTTOM ~= 0 then
			npc.act_no = 12
			npc.ani_no =  7
			npc.bits = npc.bits | cs.BITS_EVENT_CHECK
		end
		npc.act_wait = npc.act_wait + 1
	elseif npc.act_no == 12 then
		npc.xm     = 0
	end

	npc.ym = npc.ym + cs.div(cs.VS, 8)

	if npc.xm > 2 * cs.VS then
		npc.xm = 2 * cs.VS
	end
	if npc.xm < -2 * cs.VS then
		npc.xm = -2 * cs.VS
	end
	if npc.ym > cs.MAX_MOVE then
		npc.ym =  cs.MAX_MOVE
	end

	npc.x = npc.x + npc.xm
	npc.y = npc.y + npc.ym

	if npc.direct == cs.DIR_LEFT then
		npc.rect = rcLeft[1 + npc.ani_no]
	else
		npc.rect = rcRight[1 + npc.ani_no]
	end
end

return ActNpc371