--small smoke (Don't listen to Google Translate!!! It is NOT "Missile smoke")

--For the Booster 2.0 Only but I could be wrong... So far each change effects the Booster 2.0 though. - Dr. Ragtime

	--Play Testing were done with the Booster 2.0, not the 0.8! - Dr. Ragtime



local function ActCaret17(crt)
	local rcLeft = { -- white --No idea what "white means.
		{left =  56, top =   312, right =  64, bottom =   319},
		{left =  64, top =   312, right =  72, bottom =   319},
		{left =  72, top =   312, right =  80, bottom =   319},
		{left =  80, top =   312, right =  88, bottom =   319},
		{left =  88, top =   312, right =  96, bottom =   319},
		{left =  96, top =   312, right = 104, bottom =   319},
		{left = 104, top =   312, right = 112, bottom =   319},



	--Default Settings: Changes these values will change where the Booster renders it's smoke particles on the Sprite Sheet.

			-- Locations on the Sprite Sheet -- 
					-- left is Left --
					-- top is Top --
					-- right is Right --
					-- bottom is Down--

		--{left =  56, top =   0, right =  64, bottom =   8},
		--{left =  64, top =   0, right =  72, bottom =   8},
		--{left =  72, top =   0, right =  80, bottom =   8},
		--{left =  80, top =   0, right =  88, bottom =   8},
		--{left =  88, top =   0, right =  96, bottom =   8},
		--{left =  96, top =   0, right = 104, bottom =   8},
		--{left = 104, top =   0, right = 112, bottom =   8},

			-- The Order of Sprites (7 Particles) are Top is First, and Bottom which is Last Sprite in the Effect.
			-- Use 16 for every bottom value and 9 for every top if you want to use the Red particle instead of the Green one.
			-- Top is the Starting Value it draws and Bottom is where it'll stop Drawing at so for example 1-6. 1 is the first Green Pixel for the Boosters and 6 is the last and it'll draw from 1 to 6. 
			-- I imagine that up there ^ is the same for left and right.

	}

	--Animation



	crt.ani_wait = crt.ani_wait + 1 --Produces less smoke | Default Value: 1

	if crt.ani_wait > 1 then --How long will the smoke appear for on screen | Default Value: 1

		crt.ani_wait = 0 --Shortens the smoke | Default Value: 0

		crt.ani_no = crt.ani_no + 1 --How many smoke sprites it uses until the effect stops | Default Value: 1 (Using Negative Integers can sometimes show the whole Sprite Sheet)

		if crt.ani_no > 6 then --the amount of smoke sprites (0-6 with 0 first sprite the large being the first and 6 the smallest one being last)
			-- (Going above 6 will cause Errors as there isn't a 7th Sprite | Default Value: 6

			crt.cond = 0 --When the particle will stop producing. Looks like anything pass 0 will make the smoke stop appearing after using the Booster for awhile | Default Value: 0
			-- (Anything pass 1 will have no effect and keep in mind when enabling this that the smoke doesn't regenerate/comeback after awhile of not using the Booster.
			-- You must go into a new Level in order to reset it!)

			return
		end
	end

	--Rect
	crt.rect = rcLeft[1 + crt.ani_no] --Any other Integers besides its Default Value (1) will creates Errors! | Default Value: 1

	if crt.direct == cs.DIR_LEFT then --It's right, not left in-game! | Default Value: 2
		crt.x = crt.x - cs.VS * 2

	elseif crt.direct == cs.DIR_UP then --It's down, not up in-game! | Default Value: 2
		crt.y = crt.y - cs.VS * 2

	elseif crt.direct == cs.DIR_RIGHT then--It's left, not right in-game! | Default Value: 2
		crt.x = crt.x + cs.VS * 2

	elseif crt.direct == cs.DIR_DOWN then --It's up, not down in-game! | Default Value: 2
		crt.y = crt.y + cs.VS * 2

	end
--	if crt.direct == cs.DIR_DOWN then --It's up, not down in-game! | Default Value: 3 (Same thing as the non-commented out one at Line, 48-49 but with a Base Value of 3 instead)
--		crt.y = crt.y + cs.VS * 3
--	end
end

return ActCaret17