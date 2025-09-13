# capas
A v module to handle complex Ability systems.


# API
To use this module, you need to know the following:

## Rules
This struct is in the interface between the module and your code.  
You initialize your variable by using the ``rule_create(nb_team)`` function, which only need the number of team your code will use.  
For instance if you have a player against some npc, you will need 2 team as followed:  
``
mut rules := rule_create(2)
``  
The Rules fields are as followed:

marks_list which is an exaustive list of all the possible marks used.  
You can add a mark using the ``add_mark(mark_cfg)`` function and by giving it some ``Mark_config``

The rest of the Rules fields, contain all the players' [spells](#spells)
- deck, for [spells](#spells) possible to draw
- hand, for [spells](#spells) playable by the player in a turn
- permanent, for [spells](#spells) that have been played
- graveyard, for [spells](#spells) that have been used

You can add a [spells](#spells) using the ``add_spell(team, cfg_list)`` function and by giving it an index for which team is this spell and some ``Spell_config``

## Spells

In this module, [spells](#spells) are anything a player interacts with.  
Some effects are built-in:
- if a Spell.is_ended is true and the spell is in the permanent list, it will be placed in the graveyard


## Marks

In this module a mark is a modifier attached to a spell.  
It can be used to:
- represent a quantity like something hp, shield or else
- indiquate some attributes such as flying, underground or else

# base module
Some mark exemples are defined in the base sub-module
