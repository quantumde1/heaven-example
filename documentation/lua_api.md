Description of Lua Heaven's Engine API.

## 1. Main Structure

Script for engine is only one - this is a limitation of my bad code, sorry.

Engine using two loops: one for 3D, another for 2D. They're both executed in main loop in source/graphics/engine.d(if anyone interested in internals of engine, lol).
They can be swapped, but i do not recommend to do this because of no profit and worse readability of script. Outside of loops, basic things being set up, like characters on map, MC model, camera position, etc. 

### Lua functions.

Warning: there is too much functions, and i may forgot to add something. Open an issue if you think so.
I'll divide functions in multiple groups:

1. Music
2. 3D graphics
3. 2D graphics.
4. Video playback
5. Engine specific things.

So, lets go!

### 1. Music

There's only few functions available(irc):
```loadMusic("filepath in res/data.bin")```

```playMusic("filepath in res/data.bin")```

```playMusicExternal("filepath at any place of your filesystem")```

Also, music is NOT stopped automatically when you play a video. You must stop it using ```stopMusic()```.

### 2. 2D graphics

Next functions are available:

WARNING: max count of loaded backgrounds is 5, same as max.count of characters on-screen.

```stopDraw2Dtexture()``` - no need in argument, simple stopping render of 2d image

```unload2Dtexture(counter integer from load2Dtexture)``` - unload image from RAM

```load2Dtexture("filename from bg.bin", counter_integer)``` - load image to RAM

```showHint("text")``` -- show hint at screen center bottom

```hideHint()``` -- hide hint

```showUI()``` -- show UI with navigator

```draw2Dtexture(counter)``` -- draw loaded image

```hideUI()``` -- hide navigator

```stopDraw2Dcharacter(character count integer from l)``` -- stop draw character texture with

```draw2Dcharacter("filename_in_tex.bin", x_coordinate, y_coordinate, size_integer, counter)``` - loads & draws 2d texture of character on top of background(load2Dtexture etc.)

```getScreenWidth()``` and ```getScreenHeight()``` works as called - get value of screen size.

### 3. 3D graphics

Oh, it would be long story...

```dungeonCrawlerMode(1/0)``` - which type of camera would you use(first or third with old-school JRPG moveset like SMT or new as Persona 3+)

```drawPlayerModel(1/0)``` - do you need to draw player's model?

```loadScene("filename")``` - loads .json file with scene recept

```startCubeMove(2, getPlayerX()+4, getPlayerY(), getPlayerZ(), 0.9)``` -- 2 - cube's index(which cube to move), getPlayerX,Y,Z - coordinates of cube's target. 0.9 - movement speed

```startCubeRotation(1, 90, 80, 10)``` -- 1 - cube count, 90 - rotation degree, 80 speed, 10 delta time

```changeCameraPosition(0.0, 10.0, 10.0)``` -- idk, its raylib function. Try yourself to find out needed way!

```changeCameraTarget(0.0, 4.0, 0.0)``` -- idk, its raylib function. Try yourself to find out needed way!

```changeCameraUp(0.0, 1.0, 0.0)``` -- idk, its raylib function. Try yourself to find out needed way!

```removeCube(cube_index)``` - remove cube from world of engine. Must be used alongside with ```removeCubeModel(index)``` -- otherwise would crash engine.

```isCameraRotating()``` - is player camera's rotating now.

I've already said about getPlayerX,Y,Z before. There is same functions for camera - ```getCameraX(), getCameraY(), and getCameraZ()```. Also you can get position of specific cube using ```getCubeX,Y,Z(count of cube)```. 

```rotateCamera(angle_int, speed_int)``` - player's camera rotating.

```setPlayerModel("filename", size_float)``` - set player model.

```howMuchModels()``` - shows how much models are in scene are now.

```setCubeModel(index_cube, "filepath", size_float)``` -- sets cube model with specified index.

```addCube(x_float, y_float, z_float, "Name", {"initial dialog"}, wtf, wtf)``` - what doing last two things idk..

```isCubeMoving()``` - if any cube is moving, returns true, else false.

### 4. Video playback

There is only one func: ```playVideo("filepath")```. It uses libVLC.

### 5. Engine-specific things.

Not so much, but still pretty useful.

```setFriendlyZone(1/0)``` - if not, there would be Random Encounters as in JRPG. Disable if you're creating not RPG/JRPG/etc with this type of combat.

```getTime()``` - get current time.

```initBattle(is_bossfight, "name_of_enemy", {"enemy dialog"}, count_of_enemies)``` - inits JRPG styled battle. is_bossfight can be 1 on 0.

```getLocationName()``` - get current location name from the world map.

```openMap("currentPlace")``` - open map from your place at world.

```getButtonName("button")``` - can be:
1. forward;
2. dialog;
3. backward;
4. right;
5. left;
6. opmenu;

```isKeyPressed('key_char')``` - direct bind to raylib, get current pressed button.

```getBattleStatus()``` - is battle ended or not?

```isDialogExecuted()``` - if player is talking with someone it would return true

```getDialogName()``` - returns name of cube with which player talking

```shadersState(1/0)``` - state of lighting/fog shaders. Could be 1 or 0.

```getAnswerValue()``` -- get answer value from dialog.

```dialogBox("Name", {"Text"}, "", question_page_int, {"Answer 1", "Answer 2"},placement_of_portrait)``` -- question_page_int starts from zero. This is a page, where would be shown questions from next object. Placement of portrait could be 1 or 0. Zero - left, 1 - right.

```allowDemons({"name1", "name2"})"``` -- allowed demons from res/enemies_data in current location. For every enemy in this list JSON in res/enemies_data must be provided!!

```allowControl()``` - turns on control(movement, rotating etc)

```disallowControl()``` - turns off control(movement, rotating etc)

```checkInventoryForObject("test", 0)``` - "test" is an object which we're searching and 0 is number of tab where we search for it

```configureInventoryTabs({"Items", "System"})``` -- adding tabs to inventory, must be initialized at game's beginning

```addToInventoryTab("test", 0)``` - "test" is object which we're adding to 0 tab(Items tab)

```addPartyMember(120, 0, "quantumde1", 1, 0, 0)``` - 120 is current and MAX hp, 0 is current and MAX mana, "quantumde1" is name, 1 is level, 0 is XP points, 0 is counter(max.count is 6)

```setCameraRotationSpeed(1.0)``` - set speed of camera rotating in-game


```walkAnimationValue(10)``` - setting animations for specific actions

```idleAnimationValue(2)``` - setting animations for specific actions

```runAnimationValue(6)``` - setting animations for specific actions

```fogSwithcher(0/1)``` - 0 is turn off, 1 turn on

```reloadShaderFragment(path)``` - load fs shader

```reloadShaderVertex(path)``` - load vs shader
### Not working properly functions/not implemented:

```loadScript(filename``` - was meant to load next script. because of shitcode it doesnt work as excepted.

```inputName()``` - meant to enter player's name.

## example script placed in [here](../scripts/00_script.lua) and everything for resources placed in [here](../res/)
