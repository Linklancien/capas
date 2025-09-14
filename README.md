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
The Rules fields are as follows:

marks_list which is an exaustive list of all the possible marks used.  
You can add a [mark](#marks) using the ``Rules.add_mark(mark_cfg)`` function and by giving it some ``Mark_config``

The rest of the Rules fields, contain all the players' [spells](#spells) 
- deck, for [spells](#spells) possible to draw
- hand, for [spells](#spells) playable by the player in a turn
- permanent, for [spells](#spells) that have been played
- graveyard, for [spells](#spells) that have been used
> [!CAUTION]
> This is subject to changes

You can add a [spells](#spells) using the ``Rules.add_spell(team, cfg_list)`` function and by giving it an index for which team can use this spell and some ``Spell_config``

## Spells

In this module, [spells](#spells) are anything a player interacts with.  


Each spell have the following fields:
- name, which is a string and is used for UI
- description, also a string and also for UI
- on_cast_fn, which is a function that is called when the spell arrives in the permanent field of Rules
- cast_fn, which is an array of function that can be cast during turns
- end_fn, which is a function called when the spell exits the permanent field an goes in the graveyard
- marks, which is an array that represent how many of each [mark](#marks) the spell has
- is_ended, if a Spell.is_ended is true and the spell is in the permanent list, it will be placed in the graveyard when you call Rules.update_permanent(), that will call it's ``end_fn``
> [!CAUTION]
> Currently, update_permanent() doesn't automatically call ``end fn``

## Marks

In this module a [mark](#marks) is a modifier attached to a spell.  
It can be used to:
- represent a quantity like something hp, shield or else
- indiquate some attributes such as flying, underground or else



# base module
The base sub-module ``capas.base`` provide some predefined marks such as:
- `HP`; Count the HP of a spell, if the spell's HP is == 0 the spell is noted as ended so negative HP will end up as indestructibility
- `SHIELD`; Protects the HP [mark](#marks) of direct attack (excluding poison)
- `FLAT REDUCTION DAMAGE`; Reduce an attack by the [mark](#marks) quantity
- `STUN`; Incapacitates the spell for as long as the [mark](#marks) quantity, [decreasing](#decreasing)
- `REGEN` Regenerate the HP [mark](#marks) as much as the regen [mark](#marks) quantity, [decreasing](#decreasing)
- `POISON`; Reduces the HP [mark](#marks) as much as the poison [mark](#marks) quantity, [decreasing](#decreasing)

## Decreasing
Key-word qualifying a [mark](#marks), implying that each time the effect is applied, its quantity decrease.


to use them, you only need to use ``base.init_rule_base(nb_team)`` instead of ``capas.rule_create(nb_team)``
It is compatible with your own marks you just need to add them after as if you used ``rule_create``