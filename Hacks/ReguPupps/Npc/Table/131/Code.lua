--ゴン太（眠り）
--Puppy (sleep)
local function ActNpc131(npc)
	local rcLeft = {
		{left = 144, top = 354, right = 160, bottom = 370}, -- 眠り
	}
	local rcRight = {
		{left = 144, top = 370, right = 160, bottom = 386}, -- 眠り
	}
	-- og values
	--	local rcLeft = {
		--{left = 144, top = 144, right = 160, bottom = 160}, -- 眠り
	--}
	--local rcRight = {
		--{left = 144, top = 160, right = 160, bottom = 176}, -- 眠り
	--}
	npc.act_wait = npc.act_wait + 1
	if npc.act_wait > 100 then
		npc.act_wait = 0
		cs.SetCaret(npc.x, npc.y, cs.CARET_ZZZ, cs.DIR_LEFT)
	end
	if npc.direct == cs.DIR_LEFT then
		npc.rect = rcLeft[1 + npc.ani_no]
	else
		npc.rect = rcRight[1 + npc.ani_no]
	end
end

return ActNpc131
