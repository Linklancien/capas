module capas

// A: Context struct
// B: Spell struct
// C: Mark struct

// A: Context struct
// 1: each mark id is their index in this string
pub struct Context {
mut:
	// 1:
	marks_list []Mark
	// 2:
	team_spell_list [][]Spell
}

// is it usefull ?
fn (ctx Context) get_marks_ids(marks_name ...string) []int {
	mut ids := []int{len: marks_name.len}

	for index, mark in ctx.marks_list {
		for mark_index, name in marks_name {
			if mark.name == name {
				ids[mark_index] = index
				break
			}
		}
	}

	assert -1 !in ids, 'error, ${marks_name} contain a mark that is not register ${ids}'
	return ids
}

// B: Spell struct
// 1: this array is of a len of how many Mark you have
pub struct Spell {
	Spell_const
pub mut:
	// 1:
	marks []int
	is_ended bool
}

pub struct Spell_const{
pub:
	// UI
	name        string
	description string

	cast_fn fn (mut Context)
	end_fn  fn (mut Context)
}

// C: Mark struct
struct Mark {
	// UI
	name        string
	description string

	id     int
	effect fn (mut []Spell)
}
