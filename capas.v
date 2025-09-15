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
	team_deck_list      [][]Spell
	team_hand_list      [][]Spell
	team_permanent_list [][]Spell
	team_graveyard_list [][]Spell
}

pub fn rule_create(nb_team int) Rules {
	return Rules{
		team_deck_list:      [][]Spell{len: nb_team}
		team_hand_list:      [][]Spell{len: nb_team}
		team_permanent_list: [][]Spell{len: nb_team}
		team_graveyard_list: [][]Spell{len: nb_team}
	}
}

// a: Rules fn concerning marks
pub fn (mut rule Rules) add_mark(mark_cfg_list ...Mark_config) {
	for cfg in mark_cfg_list {
		rule.marks_list << Mark{
			Mark_config: cfg
			
			id:     rule.marks_list.len
		}
	}
}

pub fn (rule Rules) get_mark_id(name string) int {
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

		rule.team_deck_list[team] << Spell{
			Spell_const: cfg.Spell_const
			
			marks:      marks
		}
	}
}

pub fn (mut rule Rules) add_marks_to_spell(team int, id int, add_marks map[string]int) {
	for name in add_marks.keys() {
		mark_id := rule.get_mark_id(name)
		rule.team_permanent_list[team][id].marks[mark_id] += add_marks[name]
	}
}

pub fn (mut rule Rules) draw(team int, number int){
	rule.team_hand_list[team] << rule.team_deck_list[team]#[-number..]
	rule.team_deck_list[team] = rule.team_deck_list[team]#[..-number]
}

pub fn (mut rule Rules) draw_rand(team int, number int){
	panic('NOT IMPLEMENTED')
}

pub fn (mut rule Rules) update_permanent() {
	for id_player in 0..rule.team_permanent_list.len{
		total_len := rule.team_permanent_list[id_player].len
		mut new_permanent := []Spell{cap: total_len}
		mut new_graveyard := []Spell{}
		for i in 0..total_len{
			spell := rule.team_permanent_list[id_player].pop()
			if spell.is_ended{
				new_graveyard << spell
			}
			else{
				new_permanent << spell
			}
		}
		rule.team_permanent_list[id_player] << new_permanent
		rule.team_graveyard_list[id_player] << new_graveyard
	}
}

// B: Spell

// 1: the string is the name of the mark
pub interface Spell_interface {}

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

	on_cast_fn fn (mut Spell_interface) = null_spell_fn
	cast_fn    []fn (mut Spell_interface)
	end_fn     fn (mut Spell_interface) = null_spell_fn
}

// 1: this array is of a len of how many Mark you have
pub struct Spell {
	Spell_const
pub mut:
	// 1:
	marks    []int
	is_ended bool
}

pub fn null_spell_fn(mut changed Spell_interface) {}

pub fn (spell Spell) clone() Spell{
	return Spell{
		Spell_const: spell.Spell_const
		
		marks:      spell.marks.clone()
	}
}

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

pub fn (mark Mark) do_effect(mut spell_list []Spell) {
	mark.effect(mark.id, mut spell_list)
}

pub fn null_mark_fn(id int, mut spell_list []Spell) {}
