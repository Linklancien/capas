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

	println(rule.team_deck_list[0])
	rule.marks_list[0].do_effect(mut rule.team_deck_list[0])

	assert rule.team_deck_list[0][0].is_ended
	assert !rule.team_deck_list[0][1].is_ended
}

fn pv_effect(id int, mut spells_list []capas.Spell) {
	for mut spell in spells_list {
		if spell.marks[id] == 0 {
			spell.is_ended = true
		}
	}
}

fn test_update_permanent() {
	mut rule := capas.rule_create(1)

	rule.add_spell(0, capas.Spell_config{
		name: 'Test spell'
	}, capas.Spell_config{
		name: 'Test spell'
	})

	rule.team_permanent_list = rule.team_deck_list.clone()
	rule.team_deck_list.clear()

	assert rule.team_deck_list.len == 0, ".clear didn't work? ${rule.team_deck_list}"

	rule.team_permanent_list[0][0].is_ended = true
	rule.update_permanent()

	assert rule.team_permanent_list.len == 1, 'update_permanent issue, ${rule.team_permanent_list}'
	assert rule.team_graveyard_list.len == 1, 'update_permanent issue, ${rule.team_graveyard_list}'
}

fn test_draw(){
	mut rule := capas.rule_create(1)

	rule.add_spell(0, capas.Spell_config{
		name: 'Test spell 1'
	}, capas.Spell_config{
		name: 'Test spell 2'
	})

	assert rule.team_deck_list[0].len == 2, 'len != 2, ${rule}'
	assert rule.team_hand_list[0].len == 0, 'len != 0, ${rule}'

	rule.draw(0, 1)

	assert rule.team_deck_list[0].len == 1, 'len != 1, ${rule}'
	assert rule.team_hand_list[0].len == 1, 'len != 1, ${rule}'

	rule.draw(0, 1)

	assert rule.team_deck_list[0].len == 0, 'len != 1, ${rule}'
	assert rule.team_hand_list[0].len == 2, 'len != 1, ${rule}'
}