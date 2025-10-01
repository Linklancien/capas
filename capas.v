module capas

import rand
// A: Rules struct
// B: Spell
// C: Mark

// A: Rules struct
// a: Rules fn concerning Mark
// b: Rules fn concernunf Spell
// c: Deck gestion

// 1: each mark id is their index in this string
// 2: all lists stocking spell
pub struct Rules {
pub mut:
	// 1:
	marks_list []Mark
	// 2:
	team Deck_gestion = Deck_classic{}
}

pub enum Deck_type {
	classic
	dead_array
}

pub fn rule_create(nb_team int, deck_type Deck_type) Rules {
	match deck_type {
		.classic {
			return Rules{
				team: Deck_classic{
					deck:      [][]Spell{len: nb_team}
					hand:      [][]Spell{len: nb_team}
					permanent: [][]Spell{len: nb_team}
					graveyard: [][]Spell{len: nb_team}
				}
			}
		}
		.dead_array {
			return Rules{
				team: Deck_dead_array{
					deck:      [][]Spell{len: nb_team}
					hand:      [][]Spell{len: nb_team}
					permanent: [][]Spell{len: nb_team}
					graveyard: [][]Spell{len: nb_team}
				}
			}
		}
	}
}

// a: Rules fn concerning marks
pub fn (mut rule Rules) add_mark(mark_cfg_list ...Mark_config) {
	for cfg in mark_cfg_list {
		rule.marks_list << Mark{
			Mark_config: cfg

			id: rule.marks_list.len
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

pub fn (mut rule Rules) all_marks_do_effect(nb int) {
	for index, mark in rule.marks_list {
		mark.effect(index, mut rule.team.permanent[nb])
	}
}

// b: Rules fn concerning Spell
pub fn (mut rule Rules) add_spell(team int, cfg_list ...Spell_const) {
	for cfg in cfg_list {
		mut marks := []int{len: rule.marks_list.len}

		for name in cfg.initiliazed_mark.keys() {
			id := rule.get_mark_id(name)
			marks[id] = cfg.initiliazed_mark[name]
		}

		rule.team.deck[team] << Spell{
			Spell_const: cfg

			marks: marks
		}
	}
}

pub fn (mut rule Rules) add_marks_to_spell(team int, id int, add_marks map[string]int) {
	for name in add_marks.keys() {
		mark_id := rule.get_mark_id(name)
		rule.team.permanent[team][id].marks[mark_id] += add_marks[name]
	}
}

// c: Deck gestion
pub interface Deck_gestion {
mut:
	deck      [][]Spell
	hand      [][]Spell
	permanent [][]Spell
	graveyard [][]Spell

	update_permanent()
}

struct Deck_classic {
pub mut:
	deck      [][]Spell
	hand      [][]Spell
	permanent [][]Spell
	graveyard [][]Spell
}

pub fn (mut deck Deck_classic) update_permanent() {
	for id_player in 0 .. deck.permanent.len {
		total_len := deck.permanent[id_player].len
		mut new_permanent := []Spell{cap: total_len}
		mut new_graveyard := []Spell{}
		for _ in 0 .. total_len {
			spell := deck.permanent[id_player].pop()
			if spell.is_ended {
				new_graveyard << spell
			} else {
				new_permanent << spell
			}
		}
		deck.permanent[id_player] << new_permanent
		deck.graveyard[id_player] << new_graveyard
	}
}

struct Deck_dead_array {
	Deck_classic
mut:
	dead_ids []int
}

const dead_spell = Spell{
	name:        'dead spell'
	description: 'a spell used with the dead array methode'

	is_ended: true
}

pub fn (mut deck Deck_dead_array) update_permanent() {
	for id_player in 0 .. deck.permanent.len {
		total_len := deck.permanent[id_player].len
		for id in 0 .. total_len {
			if deck.permanent[id_player][id].is_ended
				&& deck.permanent[id_player][id].name != 'dead spell' {
				deck.graveyard[id_player] << deck.permanent[id_player][id]
				deck.permanent[id_player][id] = dead_spell
				deck.dead_ids << id
			}
		}
	}
}

pub fn (mut rule Rules) draw(team int, number int) {
	rule.team.hand[team] << rule.team.deck[team]#[-number..]
	rule.team.deck[team] = rule.team.deck[team]#[..-number]
}

pub fn (mut rule Rules) draw_rand(team int, number int) {
	// Not perfect but a least working
	elems := rand.choose(rule.team.deck[team], number) or { panic('RAND FAILED') }

	mut new_deck := []Spell{}
	mut total := 0
	outer: for deck_spell in rule.team.deck[team] {
		for elem in elems {
			if deck_spell.name == elem.name && total != elems.len {
				total += 1
				continue outer
			}
			new_deck << deck_spell
		}
	}

	rule.team.hand[team] << elems
	rule.team.deck[team] = new_deck
}

pub fn (mut rule Rules) play_ordered(team int, number int) {
	match mut rule.team {
		Deck_classic {
			rule.team.permanent[team] << rule.team.hand[team]#[-number..]
			rule.team.hand[team] = rule.team.hand[team]#[..-number]
		}
		Deck_dead_array {
			mut to_add := rule.team.hand[team]#[-number..]
			rule.team.hand[team] = rule.team.hand[team]#[..-number]
			mut added_dead := 0
			for id in rule.team.dead_ids {
				rule.team.permanent[team][id] = to_add.pop()
				added_dead += 1
			}
			rule.team.dead_ids = rule.team.dead_ids[added_dead..]
			for id in 0 .. to_add.len {
				rule.team.permanent[team] << to_add[id]
			}
		}
		else {}
	}
}

// B: Spell

pub interface Spell_interface {
mut:
	rule Rules
}

pub struct Spell_fn {
pub:
	name        string
	description string
	function    fn (mut Spell, mut Spell_interface) = fn (mut spell Spell, mut changed Spell_interface) {}
}

// 1: the string is the name of the mark
pub struct Spell_const {
pub:
	// UI
	name        string
	description string

	on_cast_fn Spell_fn = null_spell_fn
	cast_fn    []Spell_fn
	end_fn     Spell_fn = null_spell_fn

	// 1:
	initiliazed_mark map[string]int
}

// 1: this array is of a len of how many Mark you have
pub struct Spell {
	Spell_const
pub mut:
	// 1:
	marks    []int
	is_ended bool
}

pub const null_spell_fn = Spell_fn{
	name:        'null_spell_fn'
	description: 'a function to initialise the Spell_const struct'
	function:    fn (mut spell Spell, mut changed Spell_interface) {}
}

pub fn (spell Spell) clone() Spell {
	return Spell{
		Spell_const: spell.Spell_const
	}
}

pub fn (spell Spell) clone_perfect() Spell {
	return Spell{
		Spell_const: spell.Spell_const

		marks: spell.marks.clone()
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
