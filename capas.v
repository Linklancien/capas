module capas

// A: Rules struct
// B: Spell struct & Spell_const struct
// C: Mark struct & Mark_config

// A: Rules struct
// a: Rules fn concerning Mark
// b: Rules fn concernunf Spell

// 1: each mark id is their index in this string
pub struct Rules {
mut:
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
pub fn (mut rule Rules) add_mark(cfg Mark_config) {
	rule.marks_list << Mark{
		name:        cfg.name
		description: cfg.description

		effect: cfg.effect
		id:     rule.marks_list.len
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

// b: Rules fn concernunf Spell
pub fn (mut rule Rules) add_spell(team int, spell_cfg Spell_config) {
	mut marks := []int{len: rule.marks_list.len}

	for name in spell_cfg.initiliazed_mark.keys() {
		id := rule.get_mark_id(name)
		marks[id] = spell_cfg.initiliazed_mark[name]
	}

	rule.team_spell_list[team] << Spell{
		name:        spell_cfg.name
		description: spell_cfg.description

		cast_fn: spell_cfg.cast_fn
		end_fn:  spell_cfg.end_fn
		marks:   marks
	}
}

// B: Spell struct & Spell_const struct

// 1: the string is the name of the mark
pub struct Spell_config {
	Spell_const // 1:
	initiliazed_mark map[string]int
}

struct Spell_const {
	// UI
	name        string
	description string

	cast_fn fn (mut Rules)
	end_fn  fn (mut Rules)
}

// 1: this array is of a len of how many Mark you have
struct Spell {
	Spell_const
mut:
	// 1:
	marks    []int
	is_ended bool
}

// C: Mark struct & Mark_config
pub struct Mark_config {
	name        string
	description string

	effect fn (int, mut []Spell)
}

struct Mark {
	Mark_config
	id int
}

fn (mark Mark) do_effect(mut spells_list []Spell) {
	mark.effect(mark.id, mut spells_list)
}
