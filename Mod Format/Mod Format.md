Mods could be installed directly to the game's files, but the intended way is
to install them in your 'Documents' folder, like this:

- Videos
- Pictures
- Downloads
- Documents
  - My Games
    - Cave Story+
      - Mods
        - My Cave Story Mod
        - mods.txt

'mods.txt' lists each mod that is to be enabled. It looks like this:

```
+ My Cave Story Mod
```

Each line is a relative path to a mod's folder. The '+' at the start means
that this mod is enabled. Changing it to '-' will disable the mod.

Modded files go inside a mod's folder, and will override files in the game. Like In
the My Cave Story Mod, any changes you make in a new "MyChar01.1.png" inside the Graphic folder is
going to override the base game when loading the mod in the Expansion/Challenges Menu in-game. Many other files can be
overridden, such as music, level data, and Lua code.
