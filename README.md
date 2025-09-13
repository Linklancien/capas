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
You can add a mark using the ``add_mark(mark_cfg)`` function and by giving it a Mark_config

The struct Rules, contain all the players' [spells]()
- deck, all the [spells]() possible to draw
- hand, all the [spells]() playable by the player in a turn
- permanent, all the [spells]() that have been played
- graveyard, all the [spells]() that have been used

## Spells

In this module, [spells]() are anything a player interacts with.  
Some effects are built-in:
- if a Spell.is_ended is true and the spell is in the permanent list, it will be placed in the graveyard


## Marks

In this module a mark is a modifier attached to a spell.  
It can be used to represent:
- a quantity like something hp, shield or else
- a modifier that you can check to
- something else as you which

# base module
Some mark exemples are defined in the base sub-module
