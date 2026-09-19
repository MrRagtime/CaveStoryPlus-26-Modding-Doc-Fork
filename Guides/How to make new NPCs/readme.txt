1. First, you're going to want to copy a NPC's folder in Npc > Table > [NPC Number of your choice (You can use Booster's Lab Fork to find
which NPC Entity you want)]
- https://github.com/Clownacy/boosters-lab-csplus-2026

2. Rename the folder (Example: 154) to something higher than 369 (Example: 370)

3. Open up the "Code.lua" inside your NPC Folder.

4. Rename "ActNpc(Number)" to "ActNpc(Your New NPC's Number" (Example: ActNpc369 > ActNpc370) There at least two of these "ActNpc"s in
thes Lua files... One at the very top and one at the very bottom.

5. Open up Clownacy's Booster Lab Fork for Cave Story 2026

6. You should make a copy of your Cave Story+ 2026 and just put it in "mods". Here you will use its exe in order for Booster to work
properly! Copying Stage Files, NPC Files, & etc can be tedious but for now, this is the only way to do it!

7. After loading up this copy of CS+2026... Load any Map and click on "Entity".

8. On the right is a button named, "Edit npc.tbl". Click on that! (Cave Story+ 2026 doesn't use a npc.tbl but instead folders but this
fork doesn't know how to make a new folder at the moment, so thats why we did step 1. through 4.)

9. Click on "Add New".

10. You can put whatever you want here like for example the Short Name, & Description... After that, go to step 11.



Preview Rect: > "That is just the framerects for what displays in the editor itself. It doesn't exist in the engine like that
because that's only a single sprite. That's what pixel to start drawing the top, left, right and bottom of the preview sprite.
The actual framerects (rectangle coordinates for each sprite) is not in npc.tbl but in the npc code itself." - Enlight

Leaving it at its Default Values should be fine though!!!



11. At the very bottom of this list will be your new NPC you just created. Here you can change its Display, Hitbox, Flags, & Stats.

12. Sadly, Cave Story+ 2026 does not support the ability to create a new Tileset, so you will have to use the "MyChar.pbm" option
instead for new NPC Textures. It uses "MyChar01.1" for that. If you want to have a new NPC with Classic Graphics, you can rezize
your texture(s) to use "Nearest Neighbor" Resampling.

13. Makee whatever changes you want for this new NPC in the "Code.lua" or in the "Metadata.json".
