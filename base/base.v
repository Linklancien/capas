module base

import linklancien.capas { Mark_config, Rules, Spell }

// Note: here all marks are initialised in an anticiped order so mark like regen can work
// A: Init function
// B: Marks effects function
// C: Spell function

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
		effect:      pv_effect
	}, Mark_config{
		name:        'TARGET'
		description: 'Used to store a spell target'

		effect: target_effect
	})

	return rule
}

// B: Marks effects function
fn pv_effect(id int, mut spells_list []Spell) {
	for mut spell in spells_list {
		if spell.marks[id] == 0 {
			spell.is_ended = true
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

// C: Spell function

pub fn attack(damage int, mut self Spell, mut rule Spell_interface) {
	if mut rule is Rules {
		target := self.marks[rule.get_mark_id('TARGET')]
		if target >= 0 {
			// other_team_id := (team_turn + 1) % 2
			// inflict_damage(damage, mut rule.team_permanent_list[other_team_id][target])
		}
	}
}

// 1: handle flat reduction
// 2: handle shield
// 3: handle pv
pub fn inflict_damage(damage int, mut spell Spell) {
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
