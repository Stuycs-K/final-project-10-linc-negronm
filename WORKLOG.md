# Work Log

## Marcus Negron

### 5/22

Created room generation and display.

### 5/23

Added wall and enemy generation.

### 5/24

Created fundamental movement method swap().

### 5/25

Implemented a targeting system that starts on hero and can be toggled. Also added various GUI debug texts to the interface.

## 5/30

Finished targeting system. Added basic attack with a working attack range, as well as a death system for enemies.

## 5/31

Added rudimentary pathfinding system. Enemies will move left towards the hero horizontally until encountering a wall, after which they will move up or down to clear it. Also added an ability cap of 2 per hero turn.

## 6/1

Polished up pathfinding system, removed bugs that would cause enemies to get stuck on each other and phase thru walls.

## 6/6

Added skeleton code for future enemy subclasses, fixed enter spamming.

# 6/7 and 6/9

Fixed enter spam for real this time, added tile descriptions, a better start screen, stuns, some abstraction and created ability to be a mage.

# 6/11

Added Knight class, added Arbalist enemy, added enemy and hero sprites, finished tile descriptions, finished hero descriptions, updated attack, added console, fixed many bugs, Added Rogue class, fixed stuns, added diverse ranges, fixed up GUI.

## Curt Lin

### 5/22

Created a shell of each of the classes (Tile, Character, Hero, Enemy, and Wall). Also did some of the easier methods in those classes.

### 5/23

Wrote randomly generated wall code

### 5/24

Wrote a controller class using the Konstantinovich model as a base, then implemented movement for the hero such that it can go in all the cardinal directions and won't run into walls.

### 5/25

Wrote methods to switch between enemy and hero turns, also implemented a move cap for the hero and enemy.

## 5/30

Wrote code during an enemies turn to simulate the enemies movement and attacks, made the enemies try to move towards the hero

## 6/1

Wrote code to check if the hero is at the exit and as such will enter the next room with the same amount of hp

## 6/5

Made a minimum requirement for enemies killed to advance to the next room, created the basics of a TreasureTile class to give random buffs to the player, write code for a character select screen.

## 6/9

Created the mage class and its abilities.

## 6/11

Made Treasure tiles work, display work, and tile info work
