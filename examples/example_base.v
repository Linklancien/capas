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

	// println(app)
	basic_attack := fn (mut self Spell, mut rule Spell_interface) {
		base.attack(1, mut self, mut rule)
	}
	app.rule.add_spell(0, Spell_const{
		name:             'Test spell team 0'
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
	})
	app.rule.add_spell(1, Spell_const{
		name:             'Test spell team 1'
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
	app.rule.team.update_permanent()
	println('END TURN')
}
