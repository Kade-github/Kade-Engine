# Creating A Custom Character

# Requirements
1. A text editor, like Notepad++ for example. (recommended because normal Windows Notepad breaks formatting sometimes)
2. Character assets. (the .png and the .xml file)

---
### Asset setup
_Note for this step: You're able to put your assets anywhere as long as you remember where they are and they're inside of `assets/shared/images`,
but we'll be using the normal setup that Kade Engine uses for the base game's assets in this guide._

Move your assets to `assets/shared/images/characters` and remember the name of your assets.

---

### Character .json creation

Move to `assets/data/characters` (`assets/preload/data/characters` in the source code), this is where all the character .json files are stored.
For the sake of simplicity we'll just do the basic setup for an FNF Character (with an idle and notes poses only) using Mommy Mearest's character .json.

Copy the mom.json character and name it whatever you want and open it with your preferred text editor.
From here onwards this guide will be teaching the meaning of the things inside the .json and how to suit to your custom character using Mommy Mearest as the base

## Basic character .json setup

```
"name": "Mommy Mearest"
```
  Name of your character, not sure what for but you should set it

---

```  
"asset": "characters/Mom_Assets"
```
  Path to your character's assets starting from `assets/shared/images`.
  If your assets are `exampleChar.png` and `exampleChar.xml` and they're placed in `assets/shared/images/characters`, 
  the thing you put in the .json will be `"characters/exampleChar"`.
  
---

```  
"barColor": "#D8558E"
```
  The color your character's health bar will be if the player has the Colored Health Bar option turned on.
  The `"#D8558E"` is in a color hex format, search hex color picker on google and see what the code for your preferred color is,
  as an example `"#ffffff"`, this will make your character's health bar white
  
---

```
"startingAnim": "idle"
```
the starting animation of your character, 
FNF characters for some reason sometimes have 2 idles,
`idle` and `idleLoop`, i don't know why but you should be able to delete one of them. (preferably the one without Loop at the end)

If you do in fact delete idleLoop just remember to change 
```
"startingAnim": "idleLoop"
```

to

```
"startingAnim": "idle"
```

---

```
"camFollow": [0, 100]
```
Don't know what this is for, you can delete it if you want i haven't found any notable differences with setting it

---

## Character .json animation setup
This part will be the setup for animations, which are the things located below
```
  "animations": [
```

---

```
"name": "idle"
```
Name that the animation is referred by in code, for this one it's the idle.
Typically should be kept as is for the basic shit. (idle and note poses)

---

```
 "prefix": "Mom Idle"
```
Name of your animation inside your .xml.

---

```
"nextAnim": "idleLoop"
```
Generally used by the weird thing mentioned before about more than one Idle,
from what i can gather it's purpose is to play an animation after the current animation. (like the idle thing does)
You can delete it if you want as it's not required.

---

```
"offsets": [0, 0]
```
Pretty self explanatory, the offsets of your animation.
the first 0 is the x value and the second 0 is the y value.

---

### Adding character to character list
Alright, we've added the assets and just finished setting up the .json,
Now the last step to have your character in is adding them to the character list so they're selectable in the chart editor.

Move to `assets/data` (`assets/preload/data`), this is where the file we need is stored,

Open characterList.txt with your preferred text editor, you should see something similar to this inside
```
bf
dad
gf
spooky
pico
mom
mom-car
bf-car
parents-christmas
monster-christmas
bf-christmas
gf-christmas
monster
bf-pixel
senpai
senpai-angry
spirit
```

Add the name of your character .json in `assets/data/characters` (`assets/data/preload/characters` in source code) below or above wherever character you want.


### Conclusion

If you followed the guide correctly and properly set each animation you should have your own custom character inside Kade Engine!
If you want to test your sprites go inside a song and change the opponent to your character.
