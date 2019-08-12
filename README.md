modui for Classic WoW
======
![UI](https://i.imgur.com/WNCe8em.png)
![UI:cast](https://i.imgur.com/34BJX0D.png)
![UI:inventory](https://i.imgur.com/YPoAaqG.jpg)
![UI:options](https://i.imgur.com/e3VtOsZ.png)
======

#### Elements ####
- Actionbar: BfA-style small mainbar with compact menus & bags.
- Bag: one-bag inventory and bank.
- Chat: simple chat solution with modified text strings and style.
- Enemy Castbars: on Target and Nameplate unitframes.
- Nameplates: combo points for Rogues and Druids, icon-style totems, style changes.
- Quest Tracker: click-through to Quest Log.
- Theme: change the colour of your UI textures with a colour wheel. cleaner button skinning.
- Tooltip: cleaner, prettier, more useful information.
- UnitFrame: style changes, class information,
- Worldmap: smaller panel, usable while playing, coordinates and better group pins.


#### Options ####
Click the M above the backpack button (bottom-right of the main actionbar) to open theme and display options. modui is designed to be modular and the different elements of the UI can be turned on and off.

#### FAQ ####
Q: I'm getting an error that says something about MODUI_VAR.

A: try reloading the UI (type: _/rl_) and then deleting your cache before making an issue, particularly if you've recently used an older version of modui.



Q: The UI won't load in my game!

A: Make sure you're putting the directory in _WoW/Classic/Interface/AddOns/_, then rename the folder from *modui_classic-master* to *modui_classic*.



Q: Why aren't my target and nameplate casting timers correct?

A: Blizzard recently disabled accurate timer checking in their classic API in the run up to release, so now its no longer possible to check which spell rank is being used - so modui has to assume its the highest rank with the longest spell cast time for now.



Q: I don't want a black UI, how do I change it back to normal?

A: Open the theme option by hitting the *M* above the bag button or typing _/modui_, then choose *UI Colour*. Hit *Reset To Default* or move the colour wheel picker to white and hit Okay.

#### To-do ####
- Combat Text
- PvP and Battleground support.
- Raid Frames (?)
- Other stuff i forgot about since I last worked on this thing.
