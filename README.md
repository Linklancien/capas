# capas
A v module to handle complex Ability système


# API
To use this module, you need to know the following:

The struct Rules, handles the players' "spells"
- deck, all the "spells" possible to draw
- hand, all the "spells" playable
- permanent, all the "spells" that have been played
- graveyard, all the "spells" that have been used

## Spells

In this module, a "spells" design every thing a player interact with
Some effect are build-in
- if a Spell.is_ended is true and the spell is in the permanent list, it will be placed in the graveyard


## Marks

In this module a mark is something attach to a spell
It can be used to represent 
- a quantity like something pv, shield or else
- a modifier that you can check to
- something else as you which

# base module
Some marks exemple are defined in the base sub-module
