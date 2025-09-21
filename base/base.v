module base

import linklancien.capas { Rules, Mark_config, Rules, Spell, Spell_interface }
import os {input}

// Note: here all marks are initialised in an anticiped order so mark like regen can work
// A: Init function
// B: Turn_base_rule
// C: Marks effects function
// D: Spell function

const id_pv = 0
const id_shield = 1
const id_flat_reduce_dmg = 2
const id_stun = 3

// A: Init function
pub fn init_rule_base(nb_team int) Rules {
	mut rule := capas.rule_create(nb_team)

	rule.add_mark(Mark_config{
		name:        'PV'
		description: "Count the pv of a spell, if the spell's pv is == 0, the spell is mark as ended so negative pv will end up as indestructibility"
		effect:      pv_effect
	}, Mark_config{
		name:        'SHIELD'
		description: 'Protect the pv mark of direct attack (excluding poison)'
	}, Mark_config{
		name:        'FLAT REDUCTION DAMAGE'
		description: 'Reduce en attack by the mark quantity'
	}, Mark_config{
		name:        'STUN'
		description: 'Incapacitate the spell for as long as the mark quantity'
	}, Mark_config{
		name:        'REGEN'
		description: 'Regenerate the pv mark as much as the regen mark quantity'
		effect:      regen_effect
	}, Mark_config{
		name:        'POISON'
		description: 'Reduce the pv mark as much as the poison mark quantity'
		effect:      poison_effect
	}, Mark_config{
		name:        'TARGET'
		description: 'Used to store a spell target'

		effect: target_effect
	})

	return rule
}

// B: Turn_base_rule
pub struct Turn_based_rules {
pub mut:
	rule      Rules
	team_turn int
	team_nb   int
}

pub fn (mut turn_based_rule Turn_based_rules) game() {
	for turn_based_rule.rule.team_permanent_list[turn_based_rule.team_turn].len > 0 {
		turn_based_rule.turn()
		turn_based_rule.team_turn = (turn_based_rule.team_turn + 1) % 2
	}
	println('TEAM ${(turn_based_rule.team_turn + 1) % 2} WIN')
}

fn (mut turn_based_rule Turn_based_rules) turn() {
	target_id := turn_based_rule.rule.get_mark_id('TARGET')
	other_team_id := (turn_based_rule.team_turn + 1) % 2
	max_target_id := turn_based_rule.rule.team_permanent_list[other_team_id].len - 1

	for mut spell in mut turn_based_rule.rule.team_permanent_list[turn_based_rule.team_turn] {
		promp := input('Select a target for ${spell.name} (-1 to target none, max: ${max_target_id}) : ').int()
		spell.marks[target_id] = if promp <= max_target_id{promp} else{println('VALUE incorrect')
		-1}
		spell.cast_fn[0](mut spell, mut turn_based_rule)
	}

	turn_based_rule.rule.all_marks_do_effect(other_team_id)
	turn_based_rule.rule.update_permanent()
	println('END TURN')
}
// C: Marks effects function
fn pv_effect(id int, mut spells_list []Spell) {
	for mut spell in spells_list {
		if spell.marks[id] == 0 {
			spell.is_ended = true
			println('ER $id')
		}
	}
}

fn regen_effect(id int, mut spells_list []Spell) {
	for mut spell in spells_list {
		if spell.marks[id] < 0 {
			if spell.marks[id_pv] > 0 {
				spell.marks[id_pv] += spell.marks[id]
				spell.marks[id] -= 1
			}
		}
	}
}

fn poison_effect(id int, mut spells_list []Spell) {
	for mut spell in spells_list {
		if spell.marks[id] < 0 {
			if spell.marks[id_pv] > spell.marks[id] {
				spell.marks[id_pv] -= spell.marks[id]
				spell.marks[id] -= 1
			} else if spell.marks[id_pv] > 0 {
				spell.marks[id_pv] = 0
				spell.marks[id] -= 1
			}
		}
	}
}

fn target_effect(id int, mut spells_list []Spell) {
	for mut spell in spells_list {
		spell.marks[id] == -1
	}
}

// D: Spell function


pub fn attack(damage int, mut self Spell, mut costom_rule Spell_interface) {
	if mut costom_rule is Turn_based_rules {
		if costom_rule.team_nb == 2 {
			target := self.marks[costom_rule.rule.get_mark_id('TARGET')]
			if target >= 0 {
				other_team_id := (costom_rule.team_turn + 1) % 2
				inflict_damage(damage, mut costom_rule.rule.team_permanent_list[other_team_id][target])
			}
		} else {
			panic('Not implemented')
		}
	}
}

// 1: handle flat reduction
// 2: handle shield
// 3: handle pv
fn inflict_damage(damage int, mut spell Spell) {
	// 1:
	mut dmg := damage - spell.marks[id_flat_reduce_dmg]
	// 2:
	if dmg >= spell.marks[id_shield] {
		dmg -= spell.marks[id_shield]
		spell.marks[id_shield] = 0
	} else if spell.marks[id_shield] > 0 {
		spell.marks[id_shield] -= dmg
		dmg = 0
	}
	// 3:
	if dmg >= spell.marks[id_pv] {
		dmg -= spell.marks[id_pv]
		spell.marks[id_pv] = 0
	} else if spell.marks[id_pv] > 0 {
		spell.marks[id_shield] -= dmg
		dmg = 0
	}
}

pub fn test_import() {
	println('IMPORTED')
}
