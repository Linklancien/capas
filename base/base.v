module base

import linklancien.capas { Mark_config, Rules, Spell, Spell_interface }

// Note: here all marks are initialised in an anticiped order so mark like regen can work
// A: Init function
// B: Turn_base_rule
// C: Marks effects function
// D: Spell function

pub const id_pv = 0
pub const id_shield = 1
pub const id_flat_reduce_dmg = 2
pub const id_stun = 3

// A: Init function
pub fn init_rule_base(nb_team int, deck_type capas.Deck_type) Rules {
	mut rule := capas.rule_create(nb_team, deck_type)

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
pub interface Turn_based_rules {
mut:
	rule      Rules
	team_turn int
	team_nb   int

	game()
	turn()
}

pub fn turn_based_game(mut turn_based_game Turn_based_rules) {
	for turn_based_game.rule.team.permanent[turn_based_game.team_turn].len > 0 {
		turn_based_game.team_turn = (turn_based_game.team_turn + 1) % turn_based_game.team_nb
		turn_based_game.turn()
	}
}

// C: Marks effects function
fn pv_effect(id int, mut spells_list []Spell) {
	for mut spell in spells_list {
		if spell.marks[id] == 0 {
			spell.is_ended = true
			println('ER ${id}')
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

// 1: handle flat reduction
// 2: handle shield
// 3: handle pv
fn inflict_damage(mut spell Spell, damage int) {
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

fn inflict_effects(mut spell Spell, rule Rules, effects_mark map[string]int){
	for name in effects_mark.keys() {
		id := rule.get_mark_id(name)
		spell.marks[id] += effects_mark[name]
	}
}

pub fn test_import() {
	println('IMPORTED')
}
