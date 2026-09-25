1. Open up Clownacy's Booster Lab Fork for Cave Story 2026
- https://github.com/Clownacy/boosters-lab-csplus-2026

2. Open your Map

3. Go to "Script"

4. Scroll down in the Command list to find "<MYC - My Character" which 'Changes the the PC(Player)'s character.'

5. Your list of Characters you can set:

<MYC	1	#---	MY Character	Changes the PC's character.	0 (Quote), 1 (Quote), 2 (Curly), 3 (King), 4 (Sue), 5 (Booster),
6 (Toroko), 7 (Team 7 Robot), 8 (Clone Curly), 9 and anything after that is just Quote

These are the Characters Skins you can unlock by just playing the Base Game
You can change the textures in "MyChar.(x)"

6. Remember even when saving and reloading that the Player will reset its skin so the only way for the Player to keep these skins
when reloading/dying, is to set a "H/V_trigger" with Flags 'Not Affected by Tile44(Makes Vertical Triggers work anywhere)',
'Run event on contact', 'Appear once flagID set', and/or 'Spawn with alt direction' if you want a Vertical Trigger

7. Then have it so where you swap, you set a Flag with "<FL+(xxxx)"

8. Put these "H/V_trigger"s at every "Save Point"

9. Make it run a event that Flag Jumps "<FLJ:[xxxx](Flag Number):{xxxx}'Event Number'". This will make it so upon loading
into the game, you will active this event on the save point which jumps to another event if the flag is set

10. Have the event the trigger jumps to be:

#(xxxx)[Example]
<MYC000(x)<END

11. Then have the rest of the event the trigger calls to be:

#0088
<FLJ(xxxx)[Your Flag]:{xxxx}'The Event the flag jumps to do <MYC'<EVE0000(Goes to Event 0000 in Head.tsc which just does <END)
