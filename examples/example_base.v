module main

import base
import linklancien.capas { Spell, Spell_const, Spell_interface }
import os { input }

struct App {
mut:
	rule      capas.Rules
	team_turn int
	team_nb   int
}

fn main() {
	mut app := App{}
	app.team_nb = 2
	app.rule = base.init_rule_base(app.team_nb, capas.Deck_type.classic)

	app.rule.add_mark(capas.Mark_config{
		name:        'TARGET'
		description: 'Store the target of the spell'
		effect:      target_effect
	})

	// println(app)
	basic_attack := fn (mut self Spell, mut app Spell_interface) {
		match mut app {
			App {
				target_id := app.rule.get_mark_id('TARGET')
				if self.marks[target_id] != -1 {
					mut spell := app.rule.team.permanent[(app.team_turn + 1) % 2][self.marks[target_id]]
					base.inflict_damage(mut spell, 1)
				}
			}
			else {}
		}
	}
	spell_example := Spell_const{
		name:             'Test spell'
		on_cast_fn:       capas.Spell_fn{
			name:     'Hello'
			function: hello
		}
		cast_fn:          [
			capas.Spell_fn{
				name:     'basic attack'
				function: basic_attack
			},
		]
		initiliazed_mark: {
			'PV':     1
			'TARGET': -1
		}
	}
	app.rule.add_spell(0, spell_example)
	app.rule.add_spell(1, spell_example)

	app.init()
	app.game()
}

fn (mut app App) init() {
	for team in 0 .. 2 {
		app.rule.draw(team, 1)
		app.rule.play_ordered(team, 1, mut app)
	}
}

fn (mut app App) game() {
	base.turn_based_game(mut app)
	println('TEAM ${(app.team_turn + 1) % 2} WIN')
}

fn (mut app App) turn() {
	target_id := app.rule.get_mark_id('TARGET')
	other_team_id := (app.team_turn + 1) % 2
	max_target_id := app.rule.team.permanent[other_team_id].len - 1

	for mut spell in mut app.rule.team.permanent[app.team_turn] {
		promp := input('Select a target for ${spell.name} (-1 to target none, max: ${max_target_id}) : ').int()
		spell.marks[target_id] = if promp <= max_target_id {
			promp
		} else {
			println('VALUE incorrect')
			-1
		}
		spell.cast_fn[0].function(mut spell, mut app)
	}

	app.rule.all_marks_do_effect(other_team_id)
	app.rule.team.update_permanent(mut app)
	println('END TURN')
}

fn hello(mut self Spell, mut app Spell_interface) {
	println('Hello')
}

fn target_effect(id int, mut spells_list []Spell) {
	for mut spell in spells_list {
		spell.marks[id] == -1
	}
}
