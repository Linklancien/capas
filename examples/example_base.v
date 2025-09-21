module main

import base
import linklancien.capas

struct App {
	base.Turn_rules
}

fn main() {
	mut app := App{}
	app.rule = base.init_rule_base(2)

	// println(app)

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
}
