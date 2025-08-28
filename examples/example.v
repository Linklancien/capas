module main

import linklancien.capas {Spell_interface}

fn main() {
	mut rule := capas.rule_create(1)

	rule.add_mark(capas.Mark_config{
		name:        'PV'
		description: 'Test of a PV mark'

		effect: pv_effect
	})
	rule.add_spell(0, capas.Spell_config{
		name:             'Test spell'
		on_cast_fn: attack
		initiliazed_mark: {
			'PV': 0
		}
	})

	rule.team_spell_list[0][0].on_cast_fn(mut rule)
}

fn pv_effect(id int, mut spells_list []capas.Spell) {
	for mut spell in spells_list {
		if spell.marks[id] == 0 {
			spell.is_ended = true
		}
	}
}

fn attack(mut app Spell_interface){
	if mut app is capas.Rules{
		
	}
	else{
		
	}
}

