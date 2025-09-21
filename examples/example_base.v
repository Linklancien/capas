module main

import base
import linklancien.capas {Spell, Spell_const, Spell_interface}

struct App {
	base.Turn_based_rules
}

fn main() {
	mut app := App{}
	app.team_nb = 2
	app.rule = base.init_rule_base(app.team_nb)

	// println(app)
	basic_attack := fn (mut self Spell, mut rule Spell_interface){
		base.attack(1, mut self, mut rule)
	}
	app.rule.add_spell(0, Spell_const{
		name:             'Test spell team 0'
		cast_fn:          [basic_attack]
		initiliazed_mark: {
			'PV':     1
			'TARGET': -1
		}
	})
	app.rule.add_spell(1, Spell_const{
		name:             'Test spell team 1'
		cast_fn:          [basic_attack]
		initiliazed_mark: {
			'PV':     1
			'TARGET': -1
		}
	})
	app.init()
	app.game()
}

fn (mut app App) init() {
	for team in 0 .. 2 {
		app.rule.draw(team, 1)
		app.rule.play_ordered(team, 1)
	}
}

