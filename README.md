# Unfair Warcraft

Lua script for unfair warcraft. Inspired by [Болькрафт](https://www.youtube.com/playlist?list=PLZT7fvvYlYfhqWJBWzJoLQxconfz1lHPq).

## Modes
Modes are buffs for Buffed Player (default Player 2), or debuffs for Enemies of Buffed Player.

### Epic drop
Buffed player has a chance to get epic item or 1-6 books for hero stats from killing neutrals
![Epic drop](https://i.ibb.co/9sPXpDB/epic-drop.png)

### Hell rain
Every 120 seconds of game Mal'ganis spawns on enemie's of Buffed player base. Mal'ganis is neutral passive and has 50 hp. If Mal'ganis is alife he casts Infernal in 15 seconds after spawn. Infernal is ally for Buffed Player.
![Hell rain](https://i.ibb.co/WH5sW99/infernal.png)

### Neutral attack
Every time Buffed Player kills neutral, it spawns on enemie's base.
![Neutral attack](https://i.ibb.co/N2NC7WS/unit-wave.png)

### Unit rescue
Every time Buffed Player looses unit it is staffed to his base.
![Unit rescue](https://i.ibb.co/y5v1WGB/unit-rescue.png)

### Unit train
Units of Buffed Player gain stats for killing units.
![Unit train](https://i.ibb.co/Pr2b2Zw/unit-train.png)

### Walking dead
If Buffed Player kills enemies unit, it's copy spawns on that place and attack moves to enemies base. Revived zombi has 25% of max hp and it is ally for Buffed Player
![Walking dead](https://i.ibb.co/1vBwT3q/animated-dead.png)

## Modes activation
Modes are switched off by default. Admin Player (default player 1) can control special UI. It could be opened/closed by toggle button
![Toggle button](https://i.ibb.co/jMhdsJC/toggler-off.png)
Each mode icon enables/disables the corrisponding mode.
![Modes menu](https://i.ibb.co/SNM2RS4/toggler-on.png)
## Setup
1. Open Map to Modify in Warcraft 3 Editor
2. Go To Scenario->Map Options
![Map options](https://i.ibb.co/ryXcvHj/step-2.png)
3. Switch Script Language to Lua and press OK
![Lua select](https://i.ibb.co/C0MQTDv/step-3.png)
![Lua apply](https://i.ibb.co/1Jjq5qB/step-3-2.png)
4. Go To Scenario->Player Properties
![Player properties](https://i.ibb.co/LxVwYvp/step-4.png)
5. Switch Controller for Player 24 to Computer, and Fix it's Start Location and press OK
![AI player](https://i.ibb.co/Hdxcwv4/step-5.png)
![AI position](https://i.ibb.co/SsYKxXf/step-5-2.png)
![Ai-apply](https://i.ibb.co/GCM915w/step-5-3.png)
6. Go To Trigger Editor
![Trigger editor](https://i.ibb.co/s2fKSCj/step-6.png)
7. New Custom Script, name does not matter
![Custom script](https://i.ibb.co/RYBP6rf/step-7.png)
8. Copy paste script from [dist/script.lua](https://github.com/webstormrage/unfair-warcraft/blob/master/dist/script.lua) to text area below Trigger Function title
![Copy+paste custom script](https://i.ibb.co/QXMTnVF/step-8.png)
9. Go To Meele Initialization trigger
10. New Action -> General -> Custom Script
![New Action](https://i.ibb.co/TKM3WzC/step-10.png)
![General](https://i.ibb.co/2k4JMk5/step-10-2.png)
![Custom Script](https://i.ibb.co/dDj5v63/step-10-3.png)
11. Fill Script code placeholder with 
```
unfairWarcraftMain()
```
![Call main](https://i.ibb.co/JHpTbWP/step-10-4.png)
![Result trigger](https://i.ibb.co/WxbFP6j/step-10-5.png)
