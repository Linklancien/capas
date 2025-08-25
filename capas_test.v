module capas

fn test_context() {
	mut ctx := Context{
		marks_list: [
			Mark{
				name:        'PV'
				description: 'Test of a PV mark'

				id:     0
				effect: pv_effect
			},
		]

		team_spell_list: [[Spell{marks: [0]}]]
	}

	println(ctx.team_spell_list[0])
	ctx.marks_list[0].do_effect(mut ctx.team_spell_list[0])

	assert ctx.team_spell_list[0][0].is_ended
}

fn pv_effect(id int, mut spells_list []Spell) {
	for mut spell in spells_list {
		if spell.marks[id] == 0 {
			spell.is_ended = true
		}
	}
}
