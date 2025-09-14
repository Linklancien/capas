# capas
A v module to handle complex Ability systems.


# API
To use this module, you need to know the following:

## Rules
This struct is in the interface between the module and your code.  
You initialize your variable by using the ``capas.rule_create(nb_team)`` function, which only need the number of team your code will use.  
For instance if you have a player against some npc, you will need 2 team as followed:  
``
mut rules := rule_create(2)
``  
The Rules fields are as followed:

marks_list which is an exaustive list of all the possible marks used.  
You can add a mark using the ``Rules.add_mark(mark_cfg)`` function and by giving it some ``Mark_config``

The rest of the Rules fields, contain all the players' [spells](#spells) 
- deck, for [spells](#spells) possible to draw
- hand, for [spells](#spells) playable by the player in a turn
- permanent, for [spells](#spells) that have been played
- graveyard, for [spells](#spells) that have been used
> [!CAUTION]
> This is subject to changes

You can add a [spells](#spells) using the ``Rules.add_spell(team, cfg_list)`` function and by giving it an index for which team is this spell and some ``Spell_config``

## Spells

In this module, [spells](#spells) are anything a player interacts with.  


Each spell have the following fields:
- name, which is a string and is used for UI
- description, also a string and also for UI
- on_cast_fn, which is a function that is called when the spell arrived in the permanent field of Rules
- cast_fn, which is an array of function that can be cast during turns
- end_fn, which is a function called whern the spell quit the permanent field an go in the graveyard
- marks, which is an array that represent ow many of each mark the spell has
- is_ended, if a Spell.is_ended is true and the spell is in the permanent list, it will be placed in the graveyard when you call Rules.update_permanent(), that will call it's ``end_fn``
> [!CAUTION]
> Currently, update_permanent() doesn't automatically call ``end fn``

## Marks

In this module a mark is a modifier attached to a spell.  
It can be used to:
- represent a quantity like something hp, shield or else
- indiquate some attributes such as flying, underground or else



# base module
The base sub-module ``capas.base`` provide some predefined mark such as:
- `PV`; Count the pv of a spell, if the spell's pv is == 0, the spell is mark as ended so negative pv will end up as indestructibility
- `SHIELD`; Protect the pv mark of direct attack (excluding poison)
- `FLAT REDUCTION DAMAGE`; Reduce en attack by the mark quantity
- `Stun`; Incapacitate the spell for as long as the mark quantity
- `REGEN` Regenerate the pv mark as much as the regen mark quantity
- `POISON`; Reduce the pv mark as much as the poison mark quantity 

to use them, you only need to use ``base.init_rule_base(nb_team)`` instead of ``capas.rule_create(nb_team)``
It is compatible with your own marks you just need to add them after as if you used ``rule_create``