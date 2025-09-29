module main

import linklancien.capas { Mark_config, Rules, Spell, Spell_const, Spell_interface }
import os { input }

struct App {
mut:
	rule Rules

	team_turn int
	team_nb   int = 2
}

fn main() {
	mut app := App{}
	app.rule = capas.rule_create(app.team_nb, capas.Deck_type.classic)

	app.rule.add_mark(Mark_config{
		name:        'PV'
		description: 'Test of a PV mark'

		effect: pv_effect
	}, Mark_config{
		name:        'TARGET'
		description: 'Used to store a spell target'

		effect: target_effect
	})
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
	for app.rule.team.permanent[app.team_turn].len > 0 {
		app.team_turn = (app.team_turn + 1) % app.team_nb
		app.turn()
	}
	println('TEAM ${app.team_turn} WIN')
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

fn target_effect(id int, mut spells_list []Spell) {
	for mut spell in spells_list {
		spell.marks[id] == -1
	}
}

fn pv_effect(id int, mut spells_list []Spell) {
	for mut spell in spells_list {
		if spell.marks[id] == 0 {
			spell.is_ended = true
			println('${spell.name} is dead')
			// here the target doesn't change so it will always be 'Test spell team 0 is dead'
		}
	}
}

fn basic_attack(mut self Spell, mut app Spell_interface) {
	if mut app is App {
		target := self.marks[app.rule.get_mark_id('TARGET')]
		if target >= 0 {
			pv_id := app.rule.get_mark_id('PV')
			other_team_id := (app.team_turn + 1) % 2
			if app.rule.team.permanent[other_team_id][target].marks[pv_id] > 0 {
				app.rule.team.permanent[other_team_id][target].marks[pv_id] -= 1
			}
		}
	} else {
		panic('Not the expected type ${app}')
	}
}
