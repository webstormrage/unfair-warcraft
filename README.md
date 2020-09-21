# Unfair Warcraft

Lua script for unfair warcraft. Inspired by [Болькрафт](https://www.youtube.com/playlist?list=PLZT7fvvYlYfhqWJBWzJoLQxconfz1lHPq).

## Modes
Modes are buffs for Buffed Player (default Player 2), or debuffs for Enemies of Buffed Player.

### Epic drop
Buffed player has a chance to get epic item or 1-6 books for hero stats from killing neutrals
```
+drop
```

### Hell rain
Every 120 seconds of game Mal'ganis spawns on enemie's of Buffed player base. Mal'ganis is neutral passive and has 50 hp. If Mal'ganis is alife he casts Infernal in 15 seconds after spawn. Infernal is ally for Buffed Player.
```
+inferno
```

### Neutral attack
Every time Buffed Player kills neutral, it spawns on enemie's base.
```
+rush
```

### Unit rescue
Every time Buffed Player looses unit it is staffed to his base.
```
+rescue
```

### Unit train
Units of Buffed Player gain stats for killing units.
```
+train
```

### Walking dead
If Buffed Player kills enemies unit, it's copy spawns on that place and attack moves to enemies base. Revived zombi has 25% of max hp and it is ally for Buffed Player
```
+revenge
```

## Modes activation
Modes are switched off by default. Admin Player (default player 1) can control them by chat messages. Modes could be combined in one string. For example
```
+rescue+inferno+train
```
turns on Unit rescue, Hell rain and Unit train modes.

For turning off mode '-' instead of '+' should be written. For example:
```
-rush
```
turns off Neutral attack

## Setup
1. Open Map to Modify in Warcraft 3 Editor
2. Go To Scenario->Map Options
3. Switch Script Language to Lua and press OK
4. Go To Scenario->Player Properties
5. Switch Controller for Player 24 to Computer, and Fix it's Start Location and press OK
6. Go To Trigger Editor
7. New Custom Script, name does not matter
8. Copy paste script from dist/script.lua to text area below Trigger Function title
9. Go To Meele Initialization trigger
10. New Action -> General -> Custom Script
11. Fill Script code placeholder with 
```
unfairWarcraftMain()
```
