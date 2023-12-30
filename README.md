# Tak: A beautiful game

### Video Demo: https://youtu.be/wGlgWozHkq8

### Description:

Tak is a two player board-game built with [LÖVE](https://love2d.org/) and [Lua](https://www.lua.org/).
The game is from a book called The Wise Man's Fear. Grab a friend and play!

<br>
<details>
<summary>
Game Rules
</summary>

#### A Two-Player Game

To start, each player places their opponent's stone in an empty space
<br>
Then, players take turns doing 1 of 2 things
<br>
* Place
    * Place their stone in any empty space
<br>
* Move
    * Move up to five stones from a stack in their control
        * Must move in only one direction
        * Must drop at least one stone in every space
        * Cannot move laystone onto standing stone
        * Capstone can crush a standing stone if it's the only piece being moved

#### How to win
A player wins by building a road across the board either vertically or horizontally
* Standing stones *do not* count towards a road
* Laystones and Capstones *do* count towards a road

#### Scoring
Each player gets one point for any space that they have control over
* Standing stones do not count for scoring
</details>

<br>
<details>
<summary>
Controls
</summary>

#### Placement
* Use left and right arrow keys to select your stone type. You only have one capstone, so use it wisely!
<br>
Simply click an empty space to place a stone

#### Movement
* Press up or down to toggle into the movement move type
* Click on a stack in your control
* Press up or down to pick up desired stone amount
* Press enter to lock in the stones in hand
* Click to select a legal adjacent space
* Drop desired stones
* Press enter to lock in your drop
<br>

**You can carry stones to further spots if there is room to move in the same direction. Follow the onscreen directions for more help**
</details>

<br>
<details>
<summary>
Installation Instructions
</summary>

### Made with Love2d

#### MacOS/Windows
* Download the [LÖVE](https://love2d.org/) game engine and install it on your machine
<br>
* Download the [Tak](https:github.com/findingfocus/tak.git) repository to your machine
<br>
* Drag and drop the source folder onto your LÖVE application to begin playing!

#### Terminal Instructions
```
git clone https:github.com/findingfocus/tak.git
cd tak
love .
```
</details>


<br>
<details>
<summary>
    Directory Overview
</summary>

#### Project Folder
* /dependendies
    * BaseState.lua
        * a class used for state inheritance
    * class.lua
        * enables classes in Lua
    * Constants.lua
        * contains all constants used
    * push.lua
        * resizing library
    * slam.lua
        * sound library to enable multiple sounds at once
    * StateMachine.lua
        * library for handling state machine changes
* dependencies.lua
    * contains all imports for library functions as well as other class dependencies to tidy up main.lua
* /fonts
    * contains all .ttf font files
* main.lua
    * the main function of the game that imports all dependencies, handles all input, and sets default game state
* /music
    * Contains all sound files used 
* Notes.lua
    * A list of features and to do lists used in development 
* /src
    * Board.lua
        * sets board size
    * Member.lua
        * defines the stone type in a space as well as its stack order and rendering depending on the stack height 
    * Occupant.lua
         * defines information for each grid that holds all member instantiations and also determines stone control and road status 
    * /pics
        * contains all images used 
* /states
    * PlayState.lua
        * the main state of the game, early in development I had a title screen but decided to just streamline gameplay for fast playing 
---
#### Final Reflections
This was a difficult game to implement since it is a two-dimensional representation of a three-dimensional game, I had to implement constraints in order to digitize the game. I was forced to limit the stone height so that the stone stacks were legible for up to 13 stones.
<br>
<br>
I had to calculate a win based on adjacent road configuration, which was the most difficult part. I ended up calculating possible horizontal road and possible vertical roads by systematically checking stone control for all pieces starting from the left to right or from top down. 
<br>
<br>
This game is from my favorite book series, and it was an honor to bring it to life. Please try it out if you're curious and play with a friend.
</details>

---
<p align="center">
Tak Creators: James Ernest, Patrick Rothfuss
</p>
