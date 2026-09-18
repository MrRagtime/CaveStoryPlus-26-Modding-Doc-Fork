local function ActMyChar_Normal(mc_no, bKey)
	if cs.gMC[1 + mc_no].cond & cs.COND_HIDE ~= 0 then
		return
	end

	local max_dash   = 512 + 300
	local gravity1   = 80
	local gravity2   = 32
	local jump       = cs.VS + cs.VS + cs.div(cs.VS, 2)
	local dash1      = cs.div(cs.VS,  6)--cs.div(cs.VS, 8)
	local dash2      = cs.div(cs.VS, 16)--cs.div(cs.VS, 24)
	local resist     = cs.div(cs.VS, 10)--cs.div(cs.VS, 12)
	local boost      = cs.div(cs.VS, 16)
	local vect_left  = cs.div(cs.VS, 4) + cs.div(cs.VS, 64)
	local vect_up    = cs.div(cs.VS, 4)
	local vect_right = cs.div(cs.VS, 4) + cs.div(cs.VS, 64)
	local vect_down  = cs.div(cs.VS, 6)

	if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_WATER ~= 0 then
		max_dash = cs.div(max_dash, 2)
		gravity1 = cs.div(gravity1, 2)
		gravity2 = cs.div(gravity2, 2)
		jump     = cs.div(jump    , 2)
		dash1    = cs.div(dash1   , 2)
		dash2    = cs.div(dash2   , 2)
		resist   = cs.div(resist  , 2)
	end

	cs.gMC[1 + mc_no].ques = false
	if not bKey then
		cs.gMC[1 + mc_no].boost_sw = 0
	end

	if bKey then
		if cs.gKeyMC[1 + mc_no] & cs.gKeyStrafe ~= 0 then
			if cs.gMC[1 + mc_no].strafe_direct == cs.DIR_CENTER then
				cs.gMC[1 + mc_no].strafe_direct = cs.gMC[1 + mc_no].direct
				if cs.gKeyMC[1 + mc_no] & cs.gKeyUp ~= 0 then
					cs.gMC[1 + mc_no].strafe_direct = cs.DIR_UP
				elseif cs.gKeyMC[1 + mc_no] & cs.gKeyDown ~= 0 then
					cs.gMC[1 + mc_no].strafe_direct = cs.DIR_DOWN
				end
			end
		else
			cs.gMC[1 + mc_no].strafe_direct = cs.DIR_CENTER
		end
	end

	local prevDirect = cs.gMC[1 + mc_no].direct
	--local prevXM = cs.gMC[1 + mc_no].xm
	if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_BOTTOM ~= 0 or cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_LDOWN ~= 0 or cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_RDOWN ~= 0 then
		cs.gMC[1 + mc_no].boost_sw = 0
		if cs.gMC[1 + mc_no].equip & cs.EQUIP_BOOST ~= 0 then
			cs.gMC[1 + mc_no].boost_cnt = 50
		elseif cs.gMC[1 + mc_no].equip & cs.EQUIP_BOOST2 ~= 0 then
			cs.gMC[1 + mc_no].boost_cnt = 50
		else
			cs.gMC[1 + mc_no].boost_cnt = 0
		end
		if bKey then
			--don't let us check things if we're offscreen
			if cs.gKeyMCTrg[1 + mc_no] == cs.gKeyDown and cs.gKeyMC[1 + mc_no] == cs.gKeyDown and cs.gMC[1 + mc_no].cond & cs.COND_CHECK == 0 and cs.g_GameFlags & cs.GAMEFLAG_TEXTSCRIPT == 0 and cs.gMC[1 + mc_no].outside_x == 0 and cs.gMC[1 + mc_no].outside_y == 0 then
				cs.gMC[1 + mc_no].cond = cs.gMC[1 + mc_no].cond | cs.COND_CHECK
				cs.gMC[1 + mc_no].ques = true
			else
				if cs.gKeyMC[1 + mc_no] & cs.gKeyLeft ~= 0 and cs.gMC[1 + mc_no].xm > -max_dash then
					cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm - dash1
				end
				if cs.gKeyMC[1 + mc_no] & cs.gKeyRight ~= 0 and cs.gMC[1 + mc_no].xm < max_dash then
					cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm + dash1
				end
				if cs.gKeyMC[1 + mc_no] & cs.gKeyLeft ~= 0 and cs.gMC[1 + mc_no].strafe_direct == cs.DIR_CENTER then
					cs.gMC[1 + mc_no].direct = cs.DIR_LEFT
				end
				if cs.gKeyMC[1 + mc_no] & cs.gKeyRight ~= 0 and cs.gMC[1 + mc_no].strafe_direct == cs.DIR_CENTER then
					cs.gMC[1 + mc_no].direct = cs.DIR_RIGHT
				end
			end
		end
		if cs.gMC[1 + mc_no].cond & cs.COND_FLOW == 0 then
			if cs.gMC[1 + mc_no].xm < 0 then
				if cs.gMC[1 + mc_no].xm > -resist then
					cs.gMC[1 + mc_no].xm = 0
				else
					cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm + resist
				end
			end
			if cs.gMC[1 + mc_no].xm > 0 then
				if cs.gMC[1 + mc_no].xm < resist then
					cs.gMC[1 + mc_no].xm = 0
				else
					cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm - resist
				end
			end
		end
	else
		if bKey then
			if cs.gMC[1 + mc_no].equip & (cs.EQUIP_BOOST | cs.EQUIP_BOOST2) ~= 0 and cs.gKeyMCTrg[1 + mc_no] & cs.gKeyJump ~= 0 and cs.gMC[1 + mc_no].boost_cnt ~= 0 then
				if cs.gMC[1 + mc_no].equip & cs.EQUIP_BOOST ~= 0 then
					cs.gMC[1 + mc_no].boost_sw = 1
					if cs.gMC[1 + mc_no].ym > cs.div(cs.VS, 2) then
						cs.gMC[1 + mc_no].ym = cs.div(cs.gMC[1 + mc_no].ym, 2)
					end
				end
				if cs.gMC[1 + mc_no].equip & cs.EQUIP_BOOST2 ~= 0 then
					if cs.gKeyMC[1 + mc_no] & cs.gKeyUp ~= 0 then
						cs.gMC[1 + mc_no].boost_sw =  2
						cs.gMC[1 + mc_no].xm       =  0
						cs.gMC[1 + mc_no].ym       = -cs.MAX_MOVE
					elseif cs.gKeyMC[1 + mc_no] & cs.gKeyLeft ~= 0 then
						cs.gMC[1 + mc_no].boost_sw =  4
						cs.gMC[1 + mc_no].ym       =  0
						cs.gMC[1 + mc_no].xm       = -cs.MAX_MOVE
					elseif cs.gKeyMC[1 + mc_no] & cs.gKeyRight ~= 0 then
						cs.gMC[1 + mc_no].boost_sw =  1
						cs.gMC[1 + mc_no].ym       =  0
						cs.gMC[1 + mc_no].xm       =  cs.MAX_MOVE
					elseif cs.gKeyMC[1 + mc_no] & cs.gKeyDown ~= 0 then
						cs.gMC[1 + mc_no].boost_sw =  3
						cs.gMC[1 + mc_no].xm       =  0
						cs.gMC[1 + mc_no].ym       =  cs.MAX_MOVE
					else
						cs.gMC[1 + mc_no].boost_sw =  2
						cs.gMC[1 + mc_no].xm       =  0
						cs.gMC[1 + mc_no].ym       = -cs.MAX_MOVE
					end
				end
			end

			if cs.gKeyMC[1 + mc_no] & cs.gKeyLeft  ~= 0 and cs.gMC[1 + mc_no].xm > -max_dash then
				cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm - dash2
			end
			if cs.gKeyMC[1 + mc_no] & cs.gKeyRight ~= 0 and cs.gMC[1 + mc_no].xm <  max_dash then
				cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm + dash2
			end

			if cs.gKeyMC[1 + mc_no] & cs.gKeyLeft  ~= 0 and cs.gMC[1 + mc_no].strafe_direct == cs.DIR_CENTER then
				cs.gMC[1 + mc_no].direct = cs.DIR_LEFT
			end
			if cs.gKeyMC[1 + mc_no] & cs.gKeyRight ~= 0 and cs.gMC[1 + mc_no].strafe_direct == cs.DIR_CENTER then
				cs.gMC[1 + mc_no].direct = cs.DIR_RIGHT
			end
		end
		if cs.gMC[1 + mc_no].equip & cs.EQUIP_BOOST2 ~= 0 and cs.gMC[1 + mc_no].boost_sw ~= 0 then
			if cs.gKeyMC[1 + mc_no] & cs.gKeyJump == 0 or cs.gMC[1 + mc_no].boost_cnt == 0 then
				if cs.gMC[1 + mc_no].boost_sw == 1 or cs.gMC[1 + mc_no].boost_sw == 4 then
					cs.gMC[1 + mc_no].xm = cs.div(cs.gMC[1 + mc_no].xm, 2)
				elseif cs.gMC[1 + mc_no].boost_sw == 2 then
					cs.gMC[1 + mc_no].ym = cs.div(cs.gMC[1 + mc_no].ym, 2)
				end
			end
		end

		if cs.gMC[1 + mc_no].boost_cnt == 0 or cs.gKeyMC[1 + mc_no] & cs.gKeyJump == 0 then
			cs.gMC[1 + mc_no].boost_sw = 0
		end
	end

	if bKey then
		if cs.gKeyMC[1 + mc_no] & cs.gKeyUp ~= 0 or cs.gMC[1 + mc_no].strafe_direct == cs.DIR_UP then
			cs.gMC[1 + mc_no].up = true
		else
			cs.gMC[1 + mc_no].up = false
		end

		if (cs.gKeyMC[1 + mc_no] & cs.gKeyDown ~= 0 or cs.gMC[1 + mc_no].strafe_direct == cs.DIR_DOWN) and cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_BOTTOM == 0 then
			cs.gMC[1 + mc_no].down = true
		else
			cs.gMC[1 + mc_no].down = false
		end

		--Jump
		if cs.gKeyMCTrg[1 + mc_no] & cs.gKeyJump ~= 0 then
			if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_BOTTOM ~= 0 or cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_LDOWN ~= 0 or cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_RDOWN ~= 0 then
				if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_VECT_UP ~= 0 then
					
				else
					cs.gMC[1 + mc_no].ym = -jump
					cs.PlaySoundObject(cs.WAVE_JUMP, 1)
				end
			end
		end
	end

	if bKey and cs.gKeyMC[1 + mc_no] & (cs.gKeyLeft | cs.gKeyRight | cs.gKeyUp | cs.gKeyJump | cs.gKeyShot) ~= 0 then
		cs.gMC[1 + mc_no].cond = cs.gMC[1 + mc_no].cond & ~cs.COND_CHECK
	end

	if cs.gMC[1 + mc_no].boost_sw ~= 0 and cs.gMC[1 + mc_no].boost_cnt ~= 0 then
		cs.gMC[1 + mc_no].boost_cnt = cs.gMC[1 + mc_no].boost_cnt - 1
	end

	if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_VECT_LEFT ~= 0 then
		cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm - vect_left
	end
	if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_VECT_UP ~= 0 then
		cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym - vect_up
	end
	if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_VECT_RIGHT ~= 0 then
		cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm + vect_right
	end
	if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_VECT_DOWN ~= 0 then
		cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym + vect_down
	end

	--Gravity ===================================================
	if cs.gMC[1 + mc_no].equip & cs.EQUIP_BOOST2 ~= 0 and cs.gMC[1 + mc_no].boost_sw ~= 0 then
		if cs.gMC[1 + mc_no].boost_sw == 1 or cs.gMC[1 + mc_no].boost_sw == 4 then
			if cs.gKeyMC[1 + mc_no] & cs.gKeyLeft ~= 0 then
				cs.gMC[1 + mc_no].boost_sw = 4
			end
			if cs.gKeyMC[1 + mc_no] & cs.gKeyRight ~= 0 then
				cs.gMC[1 + mc_no].boost_sw = 1
			end
			if cs.gMC[1 + mc_no].flag & (cs.FLAG_HIT_LEFT | cs.FLAG_HIT_RIGHT) ~= 0 then
				cs.gMC[1 + mc_no].ym = cs.div(-cs.VS, 2)
			end
			if cs.gMC[1 + mc_no].boost_sw == 4 then
				cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm - cs.div(cs.VS, 16)
			end
			if cs.gMC[1 + mc_no].boost_sw == 1 then
				cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm + cs.div(cs.VS, 16)
			end
			if cs.gKeyMCTrg[1 + mc_no] & cs.gKeyJump ~= 0 or cs.mod(cs.gMC[1 + mc_no].boost_cnt, 3) == 1 then
				if cs.gMC[1 + mc_no].boost_sw == 4 then
					-- Booster 2.0 Left
					cs.SetCaret(cs.gMC[1 + mc_no].x + 2 * cs.VS, cs.gMC[1 + mc_no].y + 2 * cs.VS, 17, cs.DIR_RIGHT)
				end
				if cs.gMC[1 + mc_no].boost_sw == 1 then
					-- Booster 2.0 Right
					cs.SetCaret(cs.gMC[1 + mc_no].x - 2 * cs.VS, cs.gMC[1 + mc_no].y + 2 * cs.VS, 17, cs.DIR_LEFT)
				end
				cs.PlaySoundObject(cs.WAVE_BOOST, 1)
			end
		elseif cs.gMC[1 + mc_no].boost_sw == 2 then
			cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym - cs.div(cs.VS, 16)
			if cs.gKeyMCTrg[1 + mc_no] & cs.gKeyJump ~= 0 or cs.mod(cs.gMC[1 + mc_no].boost_cnt, 3) == 1 then
				-- Booster 2.0 Up
				cs.SetCaret(cs.gMC[1 + mc_no].x, cs.gMC[1 + mc_no].y + 6 * cs.VS, 17, cs.DIR_DOWN)
				cs.PlaySoundObject(cs.WAVE_BOOST, 1)
			end
		elseif cs.gMC[1 + mc_no].boost_sw == 3 then
			if cs.gKeyMCTrg[1 + mc_no] & cs.gKeyJump ~= 0 or cs.mod(cs.gMC[1 + mc_no].boost_cnt, 3) == 1 then
				-- Booster 2.0 Down
				cs.SetCaret(cs.gMC[1 + mc_no].x, cs.gMC[1 + mc_no].y - 6 * cs.VS, 17, cs.DIR_UP)
				cs.PlaySoundObject(cs.WAVE_BOOST, 1)
			end
		end
	elseif cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_VECT_UP ~= 0 then
		cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym + gravity1
	elseif cs.gMC[1 + mc_no].equip & cs.EQUIP_BOOST ~= 0 and cs.gMC[1 + mc_no].boost_sw ~= 0 and cs.gMC[1 + mc_no].ym > -2 * cs.VS then
		cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym - boost
		if cs.mod(cs.gMC[1 + mc_no].boost_cnt, 3) == 0 then
			-- Booster 0.8
			cs.SetCaret(cs.gMC[1 + mc_no].x, cs.gMC[1 + mc_no].y + cs.div(cs.gMC[1 + mc_no].hit.bottom, 2), cs.CARET_MISSILE, cs.DIR_DOWN) -- cs.CARET_MISSILE here is 7 credits to periwinkle & Dr. Ragtime
			cs.PlaySoundObject(cs.WAVE_BOOST, 1)
		end
		if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_TOP ~= 0 then
			cs.gMC[1 + mc_no].ym = cs.VS
		end
	elseif cs.gMC[1 + mc_no].ym < 0 and bKey and cs.gKeyMC[1 + mc_no] & cs.gKeyJump ~= 0 then
		cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym + gravity2
	else
		cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym + gravity1
	end

	if not bKey or cs.gKeyMCTrg[1 + mc_no] & cs.gKeyJump == 0 then
		if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_LDOWN ~= 0 and cs.gMC[1 + mc_no].xm < 0 then
			cs.gMC[1 + mc_no].ym = -cs.gMC[1 + mc_no].xm
		end
		if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_RDOWN ~= 0 and cs.gMC[1 + mc_no].xm > 0 then
			cs.gMC[1 + mc_no].ym =  cs.gMC[1 + mc_no].xm
		end
		if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_BOTTOM ~= 0 and cs.gMC[1 + mc_no].flag & cs.FLAG_SET_TRI_H ~= 0 and cs.gMC[1 + mc_no].xm < 0 then
			cs.gMC[1 + mc_no].ym = cs.VS * 2
		end
		if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_BOTTOM ~= 0 and cs.gMC[1 + mc_no].flag & cs.FLAG_SET_TRI_E ~= 0 and cs.gMC[1 + mc_no].xm > 0 then
			cs.gMC[1 + mc_no].ym = cs.VS * 2
		end

		if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_BOTTOM ~= 0 and cs.gMC[1 + mc_no].flag & cs.FLAG_SET_TRI_F ~= 0 and cs.gMC[1 + mc_no].flag & cs.FLAG_SET_TRI_G ~= 0 then
			cs.gMC[1 + mc_no].ym = cs.VS * 2
		end
	end

	if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_WATER ~= 0 and cs.gMC[1 + mc_no].flag & (cs.FLAG_HIT_VECT_LEFT | cs.FLAG_HIT_VECT_RIGHT | cs.FLAG_HIT_VECT_UP | cs.FLAG_HIT_VECT_DOWN) == 0 then
		if cs.gMC[1 + mc_no].xm < cs.div(-cs.MAX_MOVE, 2) then
			cs.gMC[1 + mc_no].xm = cs.div(-cs.MAX_MOVE, 2)
		end
		if cs.gMC[1 + mc_no].xm > cs.div( cs.MAX_MOVE, 2) then
			cs.gMC[1 + mc_no].xm = cs.div( cs.MAX_MOVE, 2)
		end
		if cs.gMC[1 + mc_no].ym < cs.div(-cs.MAX_MOVE, 2) then
			cs.gMC[1 + mc_no].ym = cs.div(-cs.MAX_MOVE, 2)
		end
		if cs.gMC[1 + mc_no].ym > cs.div( cs.MAX_MOVE, 2) then
			cs.gMC[1 + mc_no].ym = cs.div( cs.MAX_MOVE, 2)
		end
	else
		if cs.gMC[1 + mc_no].xm < -cs.MAX_MOVE then
			cs.gMC[1 + mc_no].xm = -cs.MAX_MOVE
		end
		if cs.gMC[1 + mc_no].xm >  cs.MAX_MOVE then
			cs.gMC[1 + mc_no].xm =  cs.MAX_MOVE
		end
		if cs.gMC[1 + mc_no].ym < -cs.MAX_MOVE then
			cs.gMC[1 + mc_no].ym = -cs.MAX_MOVE
		end
		if cs.gMC[1 + mc_no].ym >  cs.MAX_MOVE then
			cs.gMC[1 + mc_no].ym =  cs.MAX_MOVE
		end
	end

	--Splash
	if not cs.gMC[1 + mc_no].sprash and cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_WATER ~= 0 then
		local dir
		if cs.gMC[1 + mc_no].flag & cs.FLAG_RED_WATER ~= 0 then
			dir = cs.DIR_RIGHT
		else
			dir = cs.DIR_LEFT
		end

		if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_BOTTOM == 0 and cs.gMC[1 + mc_no].ym > cs.VS then
			for a = 0, 7 do
				local x = cs.Random(-8, 8) * cs.VS + cs.gMC[1 + mc_no].x
				cs.SetNpChar(73, x, cs.gMC[1 + mc_no].y, cs.Random(-cs.VS, cs.VS) + cs.gMC[1 + mc_no].xm, cs.Random(-cs.VS, cs.div(cs.VS, 4)) * 1 - cs.div(math.abs(cs.gMC[1 + mc_no].ym), 2), dir, nil, 0)
			end
			cs.PlaySoundObject(cs.WAVE_SPLASH2, 1)
		elseif cs.gMC[1 + mc_no].xm > cs.VS or cs.gMC[1 + mc_no].xm < -cs.VS then
			for a = 0, 7 do
				local x = cs.Random(-8, 8) * cs.VS + cs.gMC[1 + mc_no].x
				cs.SetNpChar(73, x, cs.gMC[1 + mc_no].y, cs.Random(-cs.VS, cs.VS) + cs.gMC[1 + mc_no].xm, cs.Random(-cs.VS, cs.div(cs.VS, 4)), dir, nil, 0)
			end
			cs.PlaySoundObject(cs.WAVE_SPLASH2, 1)
		end
		cs.AddWaterCollision(cs.gMC[1 + mc_no])
		cs.gMC[1 + mc_no].sprash = true
	end
	if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_WATER == 0 then
		cs.gMC[1 + mc_no].sprash = false
	end

	--DamageBlock
	if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_DAMAGE ~= 0 then
		cs.DamageMyChar(mc_no, 10)
	end

	if cs.gMC[1 + mc_no].direct == cs.DIR_LEFT then
		cs.gMC[1 + mc_no].index_x = cs.gMC[1 + mc_no].index_x - cs.VS
		if cs.gMC[1 + mc_no].index_x < -32 * cs.VS then
			cs.gMC[1 + mc_no].index_x = -32 * cs.VS
		end
	else
		cs.gMC[1 + mc_no].index_x = cs.gMC[1 + mc_no].index_x + cs.VS
		if cs.gMC[1 + mc_no].index_x > 32 * cs.VS then
			cs.gMC[1 + mc_no].index_x = 32 * cs.VS
		end
	end

	if cs.gKeyMC[1 + mc_no] & cs.gKeyUp ~= 0 and bKey then
		cs.gMC[1 + mc_no].index_y = cs.gMC[1 + mc_no].index_y - cs.VS
		if cs.gMC[1 + mc_no].index_y < -64 * cs.VS then
			cs.gMC[1 + mc_no].index_y = -64 * cs.VS
		end
	elseif cs.gKeyMC[1 + mc_no] & cs.gKeyDown ~= 0 and bKey then
		cs.gMC[1 + mc_no].index_y = cs.gMC[1 + mc_no].index_y + cs.VS
		if cs.gMC[1 + mc_no].index_y > 64 * cs.VS then
			cs.gMC[1 + mc_no].index_y = 64 * cs.VS
		end
	else
		if cs.gMC[1 + mc_no].index_y > cs.VS then
			cs.gMC[1 + mc_no].index_y = cs.gMC[1 + mc_no].index_y - cs.VS
		end
		if cs.gMC[1 + mc_no].index_y < -cs.VS then
			cs.gMC[1 + mc_no].index_y = cs.gMC[1 + mc_no].index_y + cs.VS
		end
	end

	cs.gMC[1 + mc_no].tgt_x = cs.gMC[1 + mc_no].x + cs.gMC[1 + mc_no].index_x
	cs.gMC[1 + mc_no].tgt_y = cs.gMC[1 + mc_no].y + cs.gMC[1 + mc_no].index_y

	if not (cs.gMC[1 + mc_no].xm <= resist and cs.gMC[1 + mc_no].xm >= -resist) then
		cs.gMC[1 + mc_no].x = cs.gMC[1 + mc_no].x + cs.gMC[1 + mc_no].xm
	end
	cs.gMC[1 + mc_no].y = cs.gMC[1 + mc_no].y + cs.gMC[1 + mc_no].ym

	-- Dust update
	local OnSand = false
	if cs.gMC[1 + mc_no].dust > 0 then
		cs.gMC[1 + mc_no].dust = cs.gMC[1 + mc_no].dust - 1
	end
	if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_BOTTOM ~= 0 or cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_LDOWN ~= 0 or cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_RDOWN ~= 0 then
		local map_x = cs.div(cs.div(cs.gMC[1 + mc_no].x + 8 * cs.VS, cs.PARTSSIZE), cs.VS)
		local map_y = cs.div(cs.div(cs.gMC[1 + mc_no].y + cs.gMC[1 + mc_no].hit.bottom, cs.PARTSSIZE), cs.VS)
		if map_x < cs.GetMapWidth() and map_y < cs.GetMapHeight() then
			local atrb = cs.GetAttributeRaw(map_x, map_y)
			if atrb == cs.ATRB_DISABLE then	-- Too high (ramp), sample half down
				map_y = cs.div(cs.div(cs.gMC[1 + mc_no].y + cs.gMC[1 + mc_no].hit.bottom + 8 * cs.VS, cs.PARTSSIZE), cs.VS)
				if map_y < cs.GetMapHeight() then
					atrb = cs.GetAttributeRaw(map_x, map_y)
				end
			end
			if cs.IsSandAttribute(atrb) then
				OnSand = true
			end
		end
	end

	if OnSand == false then
		cs.gMC[1 + mc_no].dust = 0
	end
	if OnSand and (cs.gMC[1 + mc_no].xm ~= 0 and cs.gMC[1 + mc_no].dust == 0 or cs.gMC[1 + mc_no].direct ~= prevDirect) and cs.gKeyMC[1 + mc_no] & (cs.gKeyLeft | cs.gKeyRight) ~= 0 then
		cs.SetCaret(cs.gMC[1 + mc_no].x, cs.gMC[1 + mc_no].y, cs.CARET_SANDDUST, cs.gMC[1 + mc_no].direct)
		cs.gMC[1 + mc_no].dust = cs.Random(40, 69)
	end
end

local function ActMyChar_Stream(mc_no, bKey)
	cs.gMC[1 + mc_no].up = false
	cs.gMC[1 + mc_no].down = false
	if bKey then
		if cs.gKeyMC[1 + mc_no] & (cs.gKeyLeft | cs.gKeyRight) ~= 0 then
			if cs.gKeyMC[1 + mc_no] & cs.gKeyLeft ~= 0 then
				cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm - cs.div(cs.VS, 2)
			end
			if cs.gKeyMC[1 + mc_no] & cs.gKeyRight ~= 0 then
				cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm + cs.div(cs.VS, 2)
			end
		else
			if cs.gMC[1 + mc_no].xm < cs.div(cs.VS, 4) and cs.gMC[1 + mc_no].xm > cs.div(-cs.VS, 4) then
				cs.gMC[1 + mc_no].xm = 0
			elseif cs.gMC[1 + mc_no].xm > 0 then
				cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm - cs.div(cs.VS, 4)
			elseif cs.gMC[1 + mc_no].xm < 0 then
				cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm + cs.div(cs.VS, 4)
			end
		end
		if cs.gKeyMC[1 + mc_no] & (cs.gKeyUp | cs.gKeyDown) ~= 0 then
			if cs.gKeyMC[1 + mc_no] & cs.gKeyUp ~= 0 then
				cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym - cs.div(cs.VS, 2)
			end
			if cs.gKeyMC[1 + mc_no] & cs.gKeyDown ~= 0 then
				cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym + cs.div(cs.VS, 2)
			end
		else
			if cs.gMC[1 + mc_no].ym < cs.div(cs.VS, 4) and cs.gMC[1 + mc_no].ym > cs.div(-cs.VS, 4) then
				cs.gMC[1 + mc_no].ym = 0
			elseif cs.gMC[1 + mc_no].ym > 0 then
				cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym - cs.div(cs.VS, 4)
			elseif cs.gMC[1 + mc_no].ym < 0 then
				cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym + cs.div(cs.VS, 4)
			end
		end
	else
		if cs.gMC[1 + mc_no].xm < cs.div(cs.VS, 4) and cs.gMC[1 + mc_no].xm > cs.div(-cs.VS, 8) then
			cs.gMC[1 + mc_no].xm = 0
		elseif cs.gMC[1 + mc_no].xm > 0 then
			cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm - cs.div(cs.VS, 4)
		elseif cs.gMC[1 + mc_no].xm < 0 then
			cs.gMC[1 + mc_no].xm = cs.gMC[1 + mc_no].xm + cs.div(cs.VS, 4)
		end
		if cs.gMC[1 + mc_no].ym < cs.div(cs.VS, 4) and cs.gMC[1 + mc_no].ym > cs.div(-cs.VS, 8) then
			cs.gMC[1 + mc_no].ym = 0
		elseif cs.gMC[1 + mc_no].ym > 0 then
			cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym - cs.div(cs.VS, 4)
		elseif cs.gMC[1 + mc_no].ym < 0 then
			cs.gMC[1 + mc_no].ym = cs.gMC[1 + mc_no].ym + cs.div(cs.VS, 4)
		end
	end

	if cs.gMC[1 + mc_no].ym < -cs.VS and cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_TOP ~= 0 then
		cs.SetCaret(cs.gMC[1 + mc_no].x, cs.gMC[1 + mc_no].y - cs.gMC[1 + mc_no].hit.top, cs.CARET_SMALLSTAR, 5)
	end
	if cs.gMC[1 + mc_no].ym > cs.VS and cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_BOTTOM ~= 0 then
		cs.SetCaret(cs.gMC[1 + mc_no].x, cs.gMC[1 + mc_no].y + cs.gMC[1 + mc_no].hit.bottom, cs.CARET_SMALLSTAR, 5)
	end

	if cs.gMC[1 + mc_no].xm > cs.VS * 2 then
		cs.gMC[1 + mc_no].xm = cs.VS * 2
	end
	if cs.gMC[1 + mc_no].xm < -cs.VS * 2 then
		cs.gMC[1 + mc_no].xm = -cs.VS * 2
	end
	if cs.gMC[1 + mc_no].ym > cs.VS * 2 then
		cs.gMC[1 + mc_no].ym = cs.VS * 2
	end
	if cs.gMC[1 + mc_no].ym < -cs.VS * 2 then
		cs.gMC[1 + mc_no].ym = -cs.VS * 2
	end

	if cs.gKeyMC[1 + mc_no] & (cs.gKeyLeft | cs.gKeyUp) == cs.gKeyLeft | cs.gKeyUp then
		if cs.gMC[1 + mc_no].xm < -780 then
			cs.gMC[1 + mc_no].xm = -780
		end
		if cs.gMC[1 + mc_no].ym < -780 then
			cs.gMC[1 + mc_no].ym = -780
		end
	end
	if cs.gKeyMC[1 + mc_no] & (cs.gKeyRight | cs.gKeyUp) == cs.gKeyRight | cs.gKeyUp then
		if cs.gMC[1 + mc_no].xm >  780 then
			cs.gMC[1 + mc_no].xm =  780
		end
		if cs.gMC[1 + mc_no].ym < -780 then
			cs.gMC[1 + mc_no].ym = -780
		end
	end
	if cs.gKeyMC[1 + mc_no] & (cs.gKeyLeft | cs.gKeyDown) == cs.gKeyLeft | cs.gKeyDown then
		if cs.gMC[1 + mc_no].xm < -780 then
			cs.gMC[1 + mc_no].xm = -780
		end
		if cs.gMC[1 + mc_no].ym >  780 then
			cs.gMC[1 + mc_no].ym =  780
		end
	end
	if cs.gKeyMC[1 + mc_no] & (cs.gKeyRight | cs.gKeyDown) == cs.gKeyRight | cs.gKeyDown then
		if cs.gMC[1 + mc_no].xm >  780 then
			cs.gMC[1 + mc_no].xm =  780
		end
		if cs.gMC[1 + mc_no].ym >  780 then
			cs.gMC[1 + mc_no].ym =  780
		end
	end

	cs.gMC[1 + mc_no].x = cs.gMC[1 + mc_no].x + cs.gMC[1 + mc_no].xm
	cs.gMC[1 + mc_no].y = cs.gMC[1 + mc_no].y + cs.gMC[1 + mc_no].ym
end

local function AirProcess(mc_no)
	if cs.gMC[1 + mc_no].equip & cs.EQUIP_AIR ~= 0 then
		cs.gMC[1 + mc_no].air     = cs.MAX_AIR
		cs.gMC[1 + mc_no].air_get = 0
		return
	end
	if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_WATER == 0 then
		cs.gMC[1 + mc_no].air = cs.MAX_AIR
	else
		cs.gMC[1 + mc_no].air = cs.gMC[1 + mc_no].air - 1
		if cs.gMC[1 + mc_no].air <= 0 then
			if cs.GetNPCFlag(4000) then
				cs.StartTextScript(mc_no, 1100)
			else
				cs.StartTextScript(mc_no, 41)
				cs.gMC[1 + mc_no].cond = cs.gMC[1 + mc_no].cond | cs.COND_DROWNED
			end
		end
	end
	if cs.gMC[1 + mc_no].flag & cs.FLAG_HIT_WATER ~= 0 then
		cs.gMC[1 + mc_no].air_get = 60
	else
		if cs.gMC[1 + mc_no].air_get ~= 0 then
			cs.gMC[1 + mc_no].air_get = cs.gMC[1 + mc_no].air_get - 1
		end
	end
end

local function ActMyChar(mc_no, bKey)
	if cs.gMC[1 + mc_no].unit == cs.MYUNIT_NORMAL then
		if cs.g_GameFlags & cs.GAMEFLAG_TEXTSCRIPT == 0 and bKey then
			AirProcess(mc_no)
		end
		ActMyChar_Normal(mc_no, bKey)
	elseif cs.gMC[1 + mc_no].unit == cs.MYUNIT_STREAM then
		ActMyChar_Stream(mc_no, bKey)
	end
end

return ActMyChar
