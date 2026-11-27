-- ゴン太(おんぶ)
-- Puppy (carried) (hat)
local function ActNpc136(npc)
	local rcLeft = {
		{left = 192, top = 354, right = 208, bottom = 370},
		{left = 208, top = 354, right = 224, bottom = 370}, -- まばたき
	}

	local rcRight = {
		{left = 192, top = 370, right = 208, bottom = 386},
		{left = 208, top = 370, right = 224, bottom = 386}, -- まばたき
	}
	-- og values
	-- 	local rcLeft = {
		--{left = 192, top = 144, right = 208, bottom = 160},
		--{left = 208, top = 144, right = 224, bottom = 160}, -- まばたき
	--}

	--local rcRight = {
		--{left = 192, top = 160, right = 208, bottom = 176},
		--{left = 208, top = 160, right = 224, bottom = 176}, -- まばたき
	--}

	if npc.act_no == 0 or npc.act_no == 1 then
		if npc.act_no == 0 then
			npc.bits = npc.bits & ~cs.BITS_EVENT_CHECK
			npc.act_no   = 1
			npc.ani_no   = 0
			npc.xm       = 0
			npc.ym       = 0
		end

		-- 待機 ---
		if cs.Random(0, 120) == 10 then
			npc.act_no   = 2
			npc.act_wait = 0
			npc.ani_no   = 1
		end
	elseif npc.act_no == 2 then
		-- 瞬く
		npc.act_wait = npc.act_wait + 1
		if npc.act_wait > 8 then
			npc.act_no = 1
			npc.ani_no = 0
		end
	end
	local old_tgt_mc = npc.tgt_mc
	-- count1 stores our puppy flag
	if cs.gNumMyChar > 1 then
		npc.tgt_mc = cs.GetNPCFlag(npc.count1 + 100) and 1 or 0
	else
		npc.tgt_mc = 0
	end
	-- to prevent issues when changing targets
	-- reset inertia and our position to player 0
	-- we always do player 0 for a few reasons
	-- 1 - if player 1 is dropping out, then player 0 is the new target
	-- 2 - if player 1 is dropping in, then they are spawning at player 0
	-- but they don't have their x and y set yet so we can't target them right away
	if old_tgt_mc ~= npc.tgt_mc then
		npc.xm2 = 0
		npc.ym2 = 0
		npc.xm = 0
		npc.ym = 0
		npc.y = cs.gMC[1].y - cs.VS * 10 -- - puppiesBelow * cs.VS * 10
		if cs.gMC[1 + npc.tgt_mc].direct == cs.DIR_LEFT then
			npc.direct = cs.DIR_LEFT
		else
			npc.direct = cs.DIR_RIGHT
		end

		if npc.direct == cs.DIR_LEFT then
			npc.x = cs.gMC[1].x + 4 * cs.VS -- + puppiesBelow * cs.VS * 1
		else
			npc.x = cs.gMC[1].x - 4 * cs.VS -- - puppiesBelow * cs.VS * 1
		end
		return
	end

	local puppyNpcCode = 136

	local n = cs.GetNpCharIndex(npc) + 1
	local puppiesBelow = 0
	local nextPuppy = cs.MAX_NPC
	while n < cs.MAX_NPC do
		if cs.gNPC[1 + n].cond & cs.COND_ALIVE ~= 0 and cs.gNPC[1 + n].code_char == puppyNpcCode and cs.gNPC[1 + n].tgt_mc == npc.tgt_mc then
			puppiesBelow = puppiesBelow + 1
			if nextPuppy == cs.MAX_NPC then
				nextPuppy = n -- We found the first puppy that's below us in the pile
			end
		end
		n = n + 1
	end

	--using ani_wait to store puppiesBelow, to check for puppy stack changes
	if puppiesBelow ~= npc.ani_wait then
		--reset stack
		npc.ani_wait = puppiesBelow
		npc.xm2 = 0
		npc.ym2 = 0
		npc.xm = 0
		npc.ym = 0
		npc.y = cs.gMC[1].y - cs.VS * 10 -- - puppiesBelow * cs.VS * 10
		if cs.gMC[1 + npc.tgt_mc].direct == cs.DIR_LEFT then
			npc.direct = cs.DIR_LEFT
		else
			npc.direct = cs.DIR_RIGHT
		end

		if npc.direct == cs.DIR_LEFT then
			npc.x = cs.gMC[1].x + 4 * cs.VS -- + puppiesBelow * cs.VS * 1
		else
			npc.x = cs.gMC[1].x - 4 * cs.VS -- - puppiesBelow * cs.VS * 1
		end
		return
	end
	npc.ani_wait = puppiesBelow

	if npc.count1 == 0 or cs.GetNPCFlag(npc.count1) == false then
		npc.cond = 0 -- Remove self if the puppy ownership flag was cleared.
		cs.PlaySoundObject(cs.WAVE_BOWWOW, 1) -- Bark!
	end

	if nextPuppy == cs.MAX_NPC then
		-- This is the bottom dog in the pile, which just copies the player character's position
		npc.y = cs.gMC[1 + npc.tgt_mc].y - cs.VS * 10 -- - puppiesBelow * cs.VS * 10
		if cs.gMC[1 + npc.tgt_mc].direct == cs.DIR_LEFT then
			npc.direct = cs.DIR_LEFT
		else
			npc.direct = cs.DIR_RIGHT
		end

		if npc.direct == cs.DIR_LEFT then
			npc.x = cs.gMC[1 + npc.tgt_mc].x + 4 * cs.VS -- + puppiesBelow * cs.VS * 1
		else
			npc.x = cs.gMC[1 + npc.tgt_mc].x - 4 * cs.VS -- - puppiesBelow * cs.VS * 1
		end

		-- calculate the player's de facto velocity from their movement from the previous frame rather than using .xm and .ym,
		-- to fix issues with pushing against walls
		if npc.xm2 ~= 0 then
			npc.xm = cs.gMC[1 + npc.tgt_mc].x - npc.xm2
		end
		if npc.ym2 ~= 0 then
			npc.ym = cs.gMC[1 + npc.tgt_mc].y - npc.ym2
		end
		npc.xm2 = cs.gMC[1 + npc.tgt_mc].x
		npc.ym2 = cs.gMC[1 + npc.tgt_mc].y

		-- Bounce along with player walk animation
		if cs.mod(cs.gMC[1 + npc.tgt_mc].ani_no, 2) ~= 0 then
			npc.y = npc.y - 1 * cs.VS
--			npc.rect.top = npc.rect.top + 1
		end
	else
		if npc.direct ~= cs.gNPC[1 + nextPuppy].direct then
			npc.direct = cs.gNPC[1 + nextPuppy].direct
			local xOff = 8 * cs.VS + cs.VS * 2 * puppiesBelow
			if npc.direct == cs.DIR_RIGHT then
				xOff = -xOff
			end
			npc.x = npc.x + xOff
		end
		--npc.y = cs.gMC[1 + npc.tgt_mc].y - cs.VS * 10 - puppiesBelow * cs.VS * 10

		npc.x = npc.x + npc.xm
		npc.y = npc.y + npc.ym
		-- lerp velocity toward parent puppy's velocity
		local xNum = 3
		local xDen = 16
		local yNum = 16
		local yDen = 16

		npc.xm = npc.xm + cs.div((cs.gNPC[1 + nextPuppy].xm - npc.xm) * 3, 16)
		npc.ym = npc.ym + cs.div((cs.gNPC[1 + nextPuppy].ym - npc.ym) * 3, 16)
		if npc.xm > 0 and npc.xm * xNum < xDen then
			npc.xm = 0
		elseif npc.xm < 0 and npc.xm * xNum > xDen then
			npc.xm = 0
		end
		if npc.ym > 0 and npc.ym * yNum < yDen then
			npc.ym = 0
		elseif npc.ym < 0 and npc.ym * yNum > yDen then
			npc.ym = 0
		end

		-- Higher puppies in the pile have a bit of motion relative to the puppy immediately below to make the tower wobbly
		local targetX = cs.gNPC[1 + nextPuppy].x + cs.gNPC[1 + nextPuppy].xm -- imply the puppy below's new position based on their velocity
		local targetY = cs.gNPC[1 + nextPuppy].y + cs.gNPC[1 + nextPuppy].ym
		if npc.direct == cs.DIR_LEFT then
			targetX = targetX + cs.VS * 1
		else
			targetX = targetX - cs.VS * 1
		end
		--targetY = targetY - cs.VS * 10

		-- lerp position toward target
		npc.x = npc.x + cs.div((targetX - npc.x) * 2, 8)

		local swayY = math.abs(npc.x - targetX)
		local pivotRadius = 5 * cs.VS
		if pivotRadius > swayY then
			swayY = math.floor(math.sqrt(pivotRadius * pivotRadius - swayY * swayY))
		else
			swayY = 0
		end
		targetY = targetY - swayY
		targetY = targetY - (10 * cs.VS - pivotRadius)

		npc.y = targetY

		if npc.x < targetX - cs.VS * 2 then
			npc.x = targetX - cs.VS * 2
			if npc.xm < -400 and cs.Random(0, 5) == 1 then
				-- Sudden stop, blink
				npc.act_no   = 2
				npc.act_wait = 0
				npc.ani_no   = 1
			end
		end
		if npc.x > targetX + cs.VS * 2 then
			npc.x = targetX + cs.VS * 2
			if npc.xm > 400 and cs.Random(0, 5) == 1 then
				-- Sudden stop, blink
				npc.act_no   = 2
				npc.act_wait = 0
				npc.ani_no   = 1
			end
		end
		if npc.y < targetY - cs.VS * 0 then
			npc.y = targetY - cs.VS * 0
		end
		if npc.y > targetY + cs.VS * 0 then
			npc.y = targetY + cs.VS * 0
		end
	end

	if npc.direct == cs.DIR_LEFT then
		npc.rect = rcLeft[1 + npc.ani_no]
	else
		npc.rect = rcRight[1 + npc.ani_no]
	end
end

return ActNpc136
