module capas

// A: Rules struct
// B: Spell
// C: Mark

// A: Rules struct
// a: Rules fn concerning Mark
// b: Rules fn concernunf Spell

// 1: each mark id is their index in this string
pub struct Rules {
pub mut:
	// 1:
	marks_list []Mark
	// 2:
	team_spell_list [][]Spell
}

pub fn rule_create(nb_team int) Rules {
	return Rules{
		team_spell_list: [][]Spell{len: nb_team}
	}
}

// a: Rules fn concerning marks
pub fn (mut rule Rules) add_mark(mark_cfg_list ...Mark_config) {
	for cfg in mark_cfg_list {
		rule.marks_list << Mark{
			name:        cfg.name
			description: cfg.description

			effect: cfg.effect
			id:     rule.marks_list.len
		}
	}
}

fn (rule Rules) get_mark_id(name string) int {
	for index, mark in rule.marks_list {
		if name == mark.name {
			return index
		}
	}
	panic('Name: ${name} is not a mark name ${rule.marks_list}')
}

// b: Rules fn concerning Spell
pub fn (mut rule Rules) add_spell(team int, cfg_list ...Spell_config) {
	for cfg in cfg_list {
		mut marks := []int{len: rule.marks_list.len}

		for name in cfg.initiliazed_mark.keys() {
			id := rule.get_mark_id(name)
			marks[id] = cfg.initiliazed_mark[name]
		}

		rule.team_spell_list[team] << Spell{
			name:        cfg.name
			description: cfg.description

			cast_fn: cfg.cast_fn
			end_fn:  cfg.end_fn
			marks:   marks
		}
	}
}

// B: Spell

// 1: the string is the name of the mark
pub struct Spell_config {
	Spell_const 
pub:
	// 1:
	initiliazed_mark map[string]int
}

struct Spell_const {
pub:
	// UI
	name        string
	description string

	cast_fn fn (mut Rules) = null_spell_fn
	end_fn  fn (mut Rules) = null_spell_fn
}

// 1: this array is of a len of how many Mark you have
pub struct Spell {
	Spell_const
pub mut:
	// 1:
	marks    []int
	is_ended bool
}

pub fn null_spell_fn(mut rule Rules) {}

// C: Mark
pub struct Mark_config {
pub:
	name        string
	description string

	effect fn (int, mut []Spell) = null_mark_fn
}

struct Mark {
	Mark_config
	id int
}

pub fn (mark Mark) do_effect(mut spells_list []Spell) {
	mark.effect(mark.id, mut spells_list)
}

pub fn null_mark_fn(id int, mut spell_list []Spell) {}
