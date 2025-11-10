import capas

struct Use{
mut:
	rule capas.Rules
}

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

	// println(rule.team.deck[0])
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

fn test_classic_update_permanent() {
	mut use := Use{}
	use.rule = capas.rule_create(1, capas.Deck_type.classic)

	use.rule.add_spell(0, capas.Spell_const{
		name: 'Test spell'
	}, capas.Spell_const{
		name: 'Test spell'
	})

	use.rule.team.permanent[0] = use.rule.team.deck[0].clone()
	use.rule.team.deck[0].clear()

	assert use.rule.team.deck[0].len == 0, ".clear didn't work? ${use.rule.team.deck}"

	use.rule.team.permanent[0][0].is_ended = true
	use.rule.team.update_permanent(mut use)

	assert use.rule.team.permanent[0].len == 1, 'update_permanent issue, ${name_array(use.rule)}'

	use.rule.add_spell(0, capas.Spell_const{
		name: 'Test spell'
	})

	use.rule.team.permanent[0] << use.rule.team.deck[0].clone()
	use.rule.team.deck[0].clear()
	use.rule.team.permanent[0][1].is_ended = true
	use.rule.team.update_permanent(mut use)
	assert use.rule.team.permanent[0].len == 1, 'update_permanent issue, ${name_array(use.rule)}'
}

fn test_dead_array_update_permanent() {
	mut use := Use{}
	use.rule = capas.rule_create(1, capas.Deck_type.dead_array)

	use.rule.add_spell(0, capas.Spell_const{
		name: 'Test spell'
	}, capas.Spell_const{
		name: 'Test spell'
	})

	use.rule.team.permanent[0] = use.rule.team.deck[0].clone()
	use.rule.team.deck[0].clear()

	assert use.rule.team.deck[0].len == 0, ".clear didn't work? ${use.rule.team.deck}"

	use.rule.team.permanent[0][0].is_ended = true
	use.rule.team.update_permanent(mut use)

	assert use.rule.team.permanent[0].len == 2, 'update_permanent issue, ${name_array(use.rule)}'

	use.rule.add_spell(0, capas.Spell_const{
		name: 'Test spell'
	})

	use.rule.team.permanent[0] << use.rule.team.deck[0].clone()
	use.rule.team.deck[0].clear()
	use.rule.team.permanent[0][2].is_ended = true
	use.rule.team.update_permanent(mut use)
	assert use.rule.team.permanent[0].len == 3, 'update_permanent issue, ${name_array(use.rule)}'
}

fn name_array(rule capas.Rules) []string {
	mut names := []string{}
	for id in 0 .. rule.team.permanent.len {
		for spell in rule.team.permanent[id] {
			names << spell.name
		}
	}
	return names
}

fn test_draw() {
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

fn test_play_ordered() {
	decks_types := [capas.Deck_type.classic, capas.Deck_type.dead_array]
	for deck_type in decks_types {
		mut use := Use{}
		use.rule = capas.rule_create(1, deck_type)

		use.rule.add_spell(0, capas.Spell_const{
			name: 'Test spell'
		}, capas.Spell_const{
			name: 'Test spell'
		})

		use.rule.draw_rand(0, 1)
		use.rule.play_ordered(0, 1,mut use)

		assert use.rule.team.hand[0].len == 0, 'len != 1, ${deck_type}'
		assert use.rule.team.permanent[0].len == 1, 'len != 1, ${deck_type}'

		use.rule.draw_rand(0, 1)
		use.rule.play_ordered(0, 1,mut use)

		assert use.rule.team.hand[0].len == 0, 'len != 1, ${deck_type}'
		assert use.rule.team.permanent[0].len == 2, 'len != 1, ${deck_type}'

		use.rule.team.permanent[0][0].is_ended = true
		use.rule.team.update_permanent(mut use)

		match deck_type {
			.classic {
				assert use.rule.team.permanent[0].len == 1, 'len != 1, ${deck_type}'
			}
			.dead_array {
				assert use.rule.team.permanent[0].len == 2, 'len != 1, ${deck_type}'
			}
		}
	}
}
