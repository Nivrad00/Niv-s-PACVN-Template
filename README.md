# Niv's PACVN Template
 A miminal point-and-click/visual novel template

This project was made in Godot 3.4. You have to use the Mono/C# verson in order for GodotInk to work:
https://github.com/paulloz/godot-ink

## ENGINE 

The "engine" folder contains my implementation of a minimal point-and-click/visual novel engine, more or less. This engine supports traveling between rooms, looking at things in rooms, talking to characters, making branching choices, picking up items, placing/using items, and checking what items you are currently holding. 

The "im-tired" folder contains a tiny example game that uses this engine.

The main scene of the project is set to be main.tscn, which is a completely empty scene. The actual functionality is in game.tscn, which is set as an AutoLoad so that you can use the global variable Game to refer to the engine at any time. The structure of game.tscn is as follows:

```text
Game
|
|__ State
|
|__ Location
|   |
|   |__ Place (or image)
|       |
|       |__ GoThing
|       |
|       |__ TalkThing
|       |
|       |__ TakeThing
|
|__ Stuff
|   |
|   |__ InvThing
|
|__ Words
|
|__ InkPlayer
```

## STATE

The State node does nothing because I didn't get around to implementing game state. You can use Ink's built in variables for basic state tracking, though.

## LOCATION

The Location node holds the current room that the player is in. This can either be a Place (a scene inheriting the place.gd class), or a static background. The Location node has a variable called place_path, which should point at the folder that contains all the Places and static images in the game. Places can contain GoThings, TalkThings, and TakeThings. These all inherit from the Thing class, which implements a basic polygonal button.

GoThings (buttons that inherit GoThing.gd) let you move from Place to Place, and has one variable that determines which Place it leads to.

TalkThings (buttons that inherit TalkThing.gd) let you talk to a character or say something about a static object, and has one variable that correspond to a stitch in the Ink story.

TakeThings (buttons that inherit TakeThing.gd) let you pick up or place an item. They have two variables: thing_name, which is what the name of the thing is, and starts_here, which is a Boolean value. 

There should be a TakeThing in EVERY location where an item can be picked up or placed. That means there can be multiple TakeThings with the same thing_name. For example, if you want to be able to pick up a key in Room 1 and then use it on a door in Room 2, both rooms should have TakeThings with the thing_name "key," but only Room 1 should have starts_here == true. This tells the engine that the TakeThing in Room 1 should be visible to start with, but the TakeThing in Room 2 should only be visible if you pick it up in Room 1 and then place it in Room 2.

## STUFF

The Stuff node displays the player's inventory. The pictures of objects that show up in the inventory are called InvThings. Whenever you pick up a TakeThing in a Place, a corresponding InvThing will show up in your Stuff. Clicking on an InvThing loads a stitch in the Ink story that corresponds to the InvThing's name.

The Stuff node has a variable called icon_path, which should point at the folder that contains all the pictures that show up in the inventory. The engine automatically converts these pictures to InvThings, so you never have to manually create an InvThing. The file names of these pictures will become the name of the corresponding InvThings.

## WORDS

The Words node displays the text box and the choice boxes.

## IKPLAYER

This is the InkPlayer node provided by the GodotInk plugin. Your Ink story containing your dialog should be loaded here. The autoload variable should be enabled.

Your Ink story needs to be structured in a specific way. Each knot should correspond to a Place, and each stitch in that knot should correspond to a TalkThing or TakeThing in that Place. There should also be a knot called "stuff" that contains a stitch for every InvThing. Finally, there should be a knot called "start" where the story begins.

There's only one external function, have(thing). This checks if your Stuff contains a particular InvThing. However, there are a few special characters that you can use to communicate with the engine from within the Ink story. 

- "@ place" will make the engine go to a particular Place.
- "& thing" will add a particular InvThing to your Stuff.
- I think "% state value" was supposed to manipulate the game state, but like I said earlier I didn't actually implement any state management, so this will probably just crash the game.

Here's an example Ink story:
```text
EXTERNAL have(thing)

=== start ===
    @tweeter
    hmmm
    i'm on tweeter?
    ...
    hmmmmmmmmmmmb............
    i'm tired of this
    @house1
    -> END
    
=== house1 ===
    = computer
        i don't have any "hot tanks" to post right now -> END

    = booba
        booba!
        should i do the booba dance?
        +   [no]
        +   [hells yes]
            \*does the booba dance*
        - -> END

=== house2 ===
    = hecktor
        there you are, hecktor!
        HECKTOR ACQUIRED!! -> END

=== house4 ===
    = door
        { have("hecktor"): i think it's time to go | i can't leave without hecktor! } -> END

=== stuff ===
    = hecktor
        hecktor's my travel buddy
        we go everywhere together -> END
```
## TL;DR

To make a game, you need these things:
- a path set in Location that points to a directory of Place scenes (or images), each representing a location in your game,
  - which can contain TalkThings and TakeThings and link to each other with GoThings;
- a path set in Stuff that points to a directory of images, each representing an inventory item;
- and an Ink script loaded into InkPlayer.
