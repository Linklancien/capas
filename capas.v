module capas

// A: Rules struct
// B: Spell struct
// C: Mark struct

// A: Rules struct
// 1: each mark id is their index in this string
pub struct Rules {
mut:
	// 1:
	marks_list []Mark
	// 2:
	team_spell_list [][]Spell
}

// B: Spell struct
// 1: this array is of a len of how many Mark you have
pub struct Spell {
	Spell_const
pub mut:
	// 1:
	marks    []int
	is_ended bool
}

pub struct Spell_const {
pub:
	// UI
	name        string
	description string

	cast_fn fn (mut Rules)
	end_fn  fn (mut Rules)
}

// C: Mark struct
pub struct Mark {
pub:
	// UI
	name        string
	description string

	id     int
	effect fn (int, mut []Spell)
}

pub fn (mark Mark) do_effect(mut spells_list []Spell) {
	mark.effect(mark.id, mut spells_list)
}
