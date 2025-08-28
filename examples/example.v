module main

import linklancien.capas { Rules, Spell_interface }

struct App {
mut:
	rule Rules

	team_target int
	id_target   int
}

fn main() {
	mut app := App{}
	app.rule = capas.rule_create(2)

	app.rule.add_mark(capas.Mark_config{
		name:        'PV'
		description: 'Test of a PV mark'

		effect: pv_effect
	})
	app.rule.add_spell(0, capas.Spell_config{
		name:             'Test spell team 0'
		on_cast_fn:       basic_attack
		initiliazed_mark: {
			'PV': 1
		}
	})
	app.rule.add_spell(1, capas.Spell_config{
		name:             'Test spell team 1'
		on_cast_fn:       basic_attack
		initiliazed_mark: {
			'PV': 1
		}
	})
	for _ in 0 .. 2 {
		for mut team in mut app.rule.team_spell_list {
			app.rule.marks_list[0].do_effect(mut team)
			for spell in team {
				spell.on_cast_fn(mut app)
			}
		}
	}
}

fn pv_effect(id int, mut spells_list []capas.Spell) {
	for mut spell in spells_list {
		if spell.marks[id] == 0 {
			spell.is_ended = true
		}
	}
}

fn basic_attack(mut app Spell_interface) {
	if mut app is App {
		if app.rule.team_spell_list[app.team_target][app.id_target].marks[app.rule.get_mark_id('PV')] > 0 {
			app.rule.team_spell_list[app.team_target][app.id_target].marks[app.rule.get_mark_id('PV')] -= 1
		}
	} else {
		panic('Not the expected type ${app}')
	}
}
