import capas

fn test_context() {
	mut rule := capas.rule_create(1, capas.Deck_type.classic)

	rule.add_mark(capas.Mark_config{
		name:        'PV'
		description: 'Test of a PV mark'

		effect: pv_effect
	})
	rule.add_spell(0, capas.Spell_const{
		name:             'Test spell'
		initiliazed_mark: {
			'PV': 0
		}
	}, capas.Spell_const{
		name:             'Test spell'
		initiliazed_mark: {
			'PV': 2
		}
	})

	println(rule.team.deck[0])
	rule.marks_list[0].do_effect(mut rule.team.deck[0])

	assert rule.team.deck[0][0].is_ended
	assert !rule.team.deck[0][1].is_ended
}

fn pv_effect(id int, mut spells_list []capas.Spell) {
	for mut spell in spells_list {
		if spell.marks[id] == 0 {
			spell.is_ended = true
		}
	}
}

fn test_update_permanent() {
	mut rule := capas.rule_create(1, capas.Deck_type.classic)

	rule.add_spell(0, capas.Spell_const{
		name: 'Test spell'
	}, capas.Spell_const{
		name: 'Test spell'
	})

	rule.team.permanent = rule.team.deck.clone()
	rule.team.deck.clear()

	assert rule.team.deck.len == 0, ".clear didn't work? ${rule.team.deck}"

	rule.team.permanent[0][0].is_ended = true
	rule.team.update_permanent()

	assert rule.team.permanent.len == 1, 'update_permanent issue, ${rule.team.permanent}'
	assert rule.team.permanent.len == 1, 'update_permanent issue, ${rule.team.permanent}'
}

fn test_draw() {
	mut rule := capas.rule_create(1, capas.Deck_type.classic)

	rule.add_spell(0, capas.Spell_const{
		name: 'Test spell 1'
	}, capas.Spell_const{
		name: 'Test spell 2'
	})

	assert rule.team.deck[0].len == 2, 'len != 2, ${rule}'
	assert rule.team.hand[0].len == 0, 'len != 0, ${rule}'

	rule.draw(0, 1)

	assert rule.team.deck[0].len == 1, 'len != 1, ${rule}'
	assert rule.team.hand[0].len == 1, 'len != 1, ${rule}'

	rule.draw(0, 1)

	assert rule.team.deck[0].len == 0, 'len != 1, ${rule}'
	assert rule.team.hand[0].len == 2, 'len != 1, ${rule}'
}

fn test_draw_rand() {
	names := [['Test spell 1', 'Test spell 2'], ['Test spell 1', 'Test spell 1']]
	for name in names {
		mut rule := capas.rule_create(1, capas.Deck_type.classic)

		rule.add_spell(0, capas.Spell_const{
			name: name[0]
		}, capas.Spell_const{
			name: name[1]
		})

		assert rule.team.deck[0].len == 2, 'len != 2, ${name}'
		assert rule.team.hand[0].len == 0, 'len != 0, ${name}'

		rule.draw_rand(0, 1)

		assert rule.team.deck[0].len == 1, 'len != 1, ${name}'
		assert rule.team.hand[0].len == 1, 'len != 1, ${name}'

		rule.draw_rand(0, 1)

		assert rule.team.deck[0].len == 0, 'len != 0, ${name}'
		assert rule.team.hand[0].len == 2, 'len != 2, ${name}'
	}
}
