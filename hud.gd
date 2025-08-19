extends CanvasLayer

const SLOT_SIZE := Vector2(64, 64)

@onready var ability_bar: PanelContainer = $AbilityBar
@onready var slots_container: HBoxContainer = $AbilityBar/HBoxContainer
var slot_icons: Array = []

func _ready() -> void:
	# Defer to next frame so Player and children are fully ready
	call_deferred("_rebuild_and_refresh")

func _rebuild_and_refresh() -> void:
	_build_slots()
	_refresh_icons()
	_connect_equipped_signal()

func _get_player_equipped() -> EquippedAbilities:
	var world := get_tree().current_scene
	if not world:
		return null
	var player := world.get_node_or_null("Player")
	if not player:
		return null
	return player.get_node_or_null("EquippedAbilities")

func _connect_equipped_signal() -> void:
	var equipped := _get_player_equipped()
	if equipped and not equipped.is_connected("abilities_changed", Callable(self, "_refresh_icons")):
		equipped.connect("abilities_changed", Callable(self, "_refresh_icons"))

func _build_slots() -> void:
	for child in slots_container.get_children():
		child.queue_free()
	slot_icons.clear()
	var max_slots := EquippedAbilities.MAX_SLOTS
	for i in range(max_slots):
		var slot := _create_slot(i)
		slots_container.add_child(slot)

func _create_slot(index: int) -> Control:
	var slot := PanelContainer.new()
	slot.custom_minimum_size = SLOT_SIZE
	var vb := VBoxContainer.new()
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
	vb.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
	slot.add_child(vb)
	var tex := TextureRect.new()
	tex.custom_minimum_size = SLOT_SIZE
	tex.name = "Icon"
	vb.add_child(tex)
	slot.set_meta("icon", tex)
	slot_icons.append(tex)
	return slot

func _refresh_icons() -> void:
	var equipped := _get_player_equipped()
	if not equipped:
		return
	var max_slots := EquippedAbilities.MAX_SLOTS
	for i in range(slots_container.get_child_count()):
		var slot := slots_container.get_child(i)
		var icon: TextureRect = slot.get_meta("icon")
		if icon == null:
			continue
		var ability := equipped.get_ability(i) if i < max_slots else null
		icon.texture = ability.icon if ability and ability.icon else null
