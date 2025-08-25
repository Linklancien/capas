import capas

fn test_context() {
	mut rule := capas.rule_create(1)

	rule.add_mark(capas.Mark_config{
		name:        'PV'
		description: 'Test of a PV mark'

		effect: pv_effect
	})
	rule.add_spell(0, capas.Spell_config{
		name:             'Test spell'
		initiliazed_mark: {
			'PV': 0
		}
	}, capas.Spell_config{
		name:             'Test spell'
		initiliazed_mark: {
			'PV': 2
		}
	})

	println(rule.team_spell_list[0])
	rule.marks_list[0].do_effect(mut rule.team_spell_list[0])

	assert rule.team_spell_list[0][0].is_ended
	assert !rule.team_spell_list[0][1].is_ended
}

fn pv_effect(id int, mut spells_list []capas.Spell) {
	for mut spell in spells_list {
		if spell.marks[id] == 0 {
			spell.is_ended = true
		}
	}
}
