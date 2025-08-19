class_name EquippedAbilities
extends Node

signal abilities_changed

const MAX_SLOTS := 10

@export var abilities: Array[Ability] = []:
	set(value):
		assert(value.size() <= MAX_SLOTS, "EquippedAbilities.abilities cannot exceed %d slots" % MAX_SLOTS)
		
		abilities = value.duplicate()
		abilities_changed.emit()

func _ready() -> void:
	add_to_group("equipped_abilities")

func set_ability(slot_index: int, ability: Ability) -> void:
	assert(slot_index >= 0, "EquippedAbilities.set_ability: slot_index must be >= 0")
	assert(slot_index < MAX_SLOTS, "EquippedAbilities.set_ability: slot_index must be < %d" % MAX_SLOTS)
	
	if slot_index >= abilities.size():
		abilities.resize(slot_index + 1)
	abilities[slot_index] = ability
	abilities_changed.emit()

func get_ability(slot_index: int) -> Ability:
	assert(slot_index >= 0 and slot_index < MAX_SLOTS, "EquippedAbilities.get_ability: slot_index out of range")
	
	if slot_index < 0 or slot_index >= abilities.size():
		return null
	return abilities[slot_index]

func use_slot(slot_index: int, user: Node2D, target: Node2D) -> void:
	assert(slot_index >= 0 and slot_index < MAX_SLOTS, "EquippedAbilities.use_slot: slot_index out of range")
	
	var ability = get_ability(slot_index)
	if ability:
		ability.use(user, target)
