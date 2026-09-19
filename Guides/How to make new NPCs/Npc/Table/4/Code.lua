--爆風
local function ActNpc004(npc)
	local rcLeft = {
		{left =  16, top =   0, right =  17, bottom =   1},
		{left =  16, top =   0, right =  32, bottom =  16},
		{left =  32, top =   0, right =  48, bottom =  16},

		{left =  48, top =   0, right =  64, bottom =  16},
		{left =  64, top =   0, right =  80, bottom =  16},
		{left =  80, top =   0, right =  96, bottom =  16},
		{left =  96, top =   0, right = 112, bottom =  16},
		{left = 112, top =   0, right = 128, bottom =  16},
	}
	local rcUp = {
		{left =  16, top =   0, right =  17, bottom =   1},
		{left =  80, top =  48, right =  96, bottom =  64},
		{left =   0, top = 128, right =  16, bottom = 144},

		{left =  16, top = 128, right =  32, bottom = 144},
		{left =  32, top = 128, right =  48, bottom = 144},
		{left =  48, top = 128, right =  64, bottom = 144},
		{left =  64, top = 128, right =  80, bottom = 144},
		{left =  80, top = 128, right =  96, bottom = 144},
	}

	local deg

	if npc.act_no == 0 then
		if npc.direct == cs.DIR_LEFT or npc.direct == cs.DIR_UP then
			deg = cs.Random(0, 255)
			npc.xm = cs.div(cs.GetCos(deg) * cs.Random(cs.VS, cs.MAX_MOVE), cs.VS)
			npc.ym = cs.div(cs.GetSin(deg) * cs.Random(cs.VS, cs.MAX_MOVE), cs.VS)
		end
		npc.ani_no   = cs.Random(0, 4)
		npc.ani_wait = cs.Random(0, 3)
		npc.act_no = 1
	else
		npc.xm = cs.div(npc.xm * 20, 21)
		npc.ym = cs.div(npc.ym * 20, 21)
		npc.x = npc.x + npc.xm
		npc.y = npc.y + npc.ym
	end

	npc.ani_wait = npc.ani_wait + 1
	if npc.ani_wait > 4 then
		npc.ani_wait = 0
		npc.ani_no = npc.ani_no + 1
	end
	if npc.ani_no > 7 then
		npc.cond = 0
	else
		if npc.direct == cs.DIR_UP then
			npc.rect = rcUp[1 + npc.ani_no]
		end
		if npc.direct == cs.DIR_LEFT then
			npc.rect = rcLeft[1 + npc.ani_no]
		end
		if npc.direct == cs.DIR_RIGHT then
			npc.rect = rcLeft[1 + npc.ani_no]
		end
	end
end

return ActNpc004
