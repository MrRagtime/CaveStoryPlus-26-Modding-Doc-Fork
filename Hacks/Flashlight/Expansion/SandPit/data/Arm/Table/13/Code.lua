local _spur_charge = {}
for mc_no = 1, cs.MAX_MYCHAR do
	_spur_charge[mc_no] = 0
end

local function ResetSpurCharge(mc_no)
	_spur_charge[1 + mc_no] = 0
	cs.ZeroExpMyChar(mc_no)
end

local _bMax = {}
for mc_no = 1, cs.MAX_MYCHAR do
	_bMax[mc_no] = false
end

-- Spur
local function ShootBullet_Spur(mc_no, level)
	local bul_no
	local bShot = false

	if cs.gKeyMC[1 + mc_no] & cs.gKeyShot ~= 0 then
		if cs.gMC[1 + mc_no].equip & cs.EQUIP_TURBOCHARGE ~= 0 then
			cs.AddExpMyChar(mc_no, 3)
		else
			cs.AddExpMyChar(mc_no, 2)
		end
		_spur_charge[1 + mc_no] = _spur_charge[1 + mc_no] + 1
		if math.modf(_spur_charge[1 + mc_no] / 2) % 2 ~= 0 then
			if level == 1 then
				cs.PlaySoundObject(cs.WAVE_CHARGE_LV1, 1)
			elseif level == 2 then
				cs.PlaySoundObject(cs.WAVE_CHARGE_LV2, 1)
			elseif level == 3 then
				if not cs.IsMaxExpMyChar(mc_no) then
					cs.PlaySoundObject(cs.WAVE_CHARGE_LV3, 1)
				end
			end
		end
	else
		if _spur_charge[1 + mc_no] ~= 0 then
			bShot = true
		end
		_spur_charge[1 + mc_no] = 0
	end

	if cs.IsMaxExpMyChar(mc_no) then
		if not _bMax[1 + mc_no] then
			_bMax[1 + mc_no] = true
			cs.PlaySoundObject(cs.WAVE_CHARGE_MAX, 1)
		end
	else
		_bMax[1 + mc_no] = false
	end

	if cs.gKeyMC[1 + mc_no] & cs.gKeyShot == 0 then
		cs.ZeroExpMyChar(mc_no)
	end

	if level == 1 then
		bul_no = cs.BULLET_POLESTAR3
		bShot = false
	elseif level == 2 then
		bul_no = cs.BULLET_SPUR1
	elseif level == 3 then
		if _bMax[1 + mc_no] then
			bul_no = cs.BULLET_SPUR3
		else
			bul_no = cs.BULLET_SPUR2
		end
	end

	if cs.CountArmsBullet(mc_no, 13) > 0 or cs.CountArmsBullet(mc_no, 14) > 0 then
		return
	end
	cs.gMC[1 + mc_no].muzzle = cs.MUZZLE_FLASH_DURATION -- flashlight on
	if cs.gKeyMCTrg[1 + mc_no] & cs.gKeyShot ~= 0 or bShot then
		if cs.UseArmsEnergy(mc_no, 1) == false then
			cs.PlaySoundObject(cs.WAVE_ARMS_EMPTY, 1)
			return
		end
		if cs.gMC[1 + mc_no].up then
			if cs.gMC[1 + mc_no].direct == cs.DIR_LEFT then
				cs.SetBullet(mc_no, bul_no, cs.gMC[1 + mc_no].x - 1 * cs.VS, cs.gMC[1 + mc_no].y - 8 * cs.VS, cs.DIR_UP)
				cs.SetCaret(                cs.gMC[1 + mc_no].x - 1 * cs.VS, cs.gMC[1 + mc_no].y - 8 * cs.VS, cs.CARET_FLASH, cs.DIR_LEFT)
			else
				cs.SetBullet(mc_no, bul_no, cs.gMC[1 + mc_no].x + 1 * cs.VS, cs.gMC[1 + mc_no].y - 8 * cs.VS, cs.DIR_UP)
				cs.SetCaret(                cs.gMC[1 + mc_no].x + 1 * cs.VS, cs.gMC[1 + mc_no].y - 8 * cs.VS, cs.CARET_FLASH, cs.DIR_LEFT)
			end
		elseif cs.gMC[1 + mc_no].down then
			if cs.gMC[1 + mc_no].direct == cs.DIR_LEFT then
				cs.SetBullet(mc_no, bul_no, cs.gMC[1 + mc_no].x - 1 * cs.VS, cs.gMC[1 + mc_no].y + 8 * cs.VS, cs.DIR_DOWN)
				cs.SetCaret(                cs.gMC[1 + mc_no].x - 1 * cs.VS, cs.gMC[1 + mc_no].y + 8 * cs.VS, cs.CARET_FLASH, cs.DIR_LEFT)
			else
				cs.SetBullet(mc_no, bul_no, cs.gMC[1 + mc_no].x + 1 * cs.VS, cs.gMC[1 + mc_no].y + 8 * cs.VS, cs.DIR_DOWN)
				cs.SetCaret(                cs.gMC[1 + mc_no].x + 1 * cs.VS, cs.gMC[1 + mc_no].y + 8 * cs.VS, cs.CARET_FLASH, cs.DIR_LEFT)
			end
		else
			if cs.gMC[1 + mc_no].direct == cs.DIR_LEFT then
				cs.SetBullet(mc_no, bul_no, cs.gMC[1 + mc_no].x -  6 * cs.VS, cs.gMC[1 + mc_no].y + 3 * cs.VS, cs.DIR_LEFT)
				cs.SetCaret(                cs.gMC[1 + mc_no].x - 12 * cs.VS, cs.gMC[1 + mc_no].y + 3 * cs.VS, cs.CARET_FLASH, cs.DIR_LEFT)
			else
				cs.SetBullet(mc_no, bul_no, cs.gMC[1 + mc_no].x +  6 * cs.VS, cs.gMC[1 + mc_no].y + 3 * cs.VS, cs.DIR_RIGHT)
				cs.SetCaret(                cs.gMC[1 + mc_no].x + 12 * cs.VS, cs.gMC[1 + mc_no].y + 3 * cs.VS, cs.CARET_FLASH, cs.DIR_LEFT)
			end
		end
		if bul_no == cs.BULLET_POLESTAR3 then
			cs.PlaySoundObject(cs.WAVE_POLEST2,  1)
		elseif bul_no == cs.BULLET_SPUR1 then
			cs.PlaySoundObject(cs.WAVE_SPUR_LV1, 1)
		elseif bul_no == cs.BULLET_SPUR2 then
			cs.PlaySoundObject(cs.WAVE_SPUR_LV2, 1)
		elseif bul_no == cs.BULLET_SPUR3 then
			cs.PlaySoundObject(cs.WAVE_SPUR_LV3, 1)
		end
		cs.gMC[1 + mc_no].muzzle = cs.MUZZLE_FLASH_DURATION
	end
end

return {
	weapon_fired = ShootBullet_Spur,
	weapon_switched = ResetSpurCharge,
	weapon_idle = nil
}
