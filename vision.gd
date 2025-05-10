@tool
extends Node2D

@export_group("Vision Parameters")

@export_range(0.0, 10_000.0, 10.0) var distance: float = 200.0:
	set(value):
		distance = value
		_update_debug_cone()
@export_range(1, 360, 1) var angle_deg: float = 90.0:
	set(value):
		angle_deg = value
		_update_debug_cone()
@export_range(5, 100, 1) var ray_count: int = 10:
	set(value):
		ray_count = value
		_update_debug_cone()
@export var detect_layer: int = 1
@export var debug = false:
	set(value):
		debug = value
		if debug_cone:
			if value:
				debug_cone.show()
			else:
				debug_cone.hide()
func set_debug(value: bool) -> void:
	debug = true

@onready var debug_cone: Polygon2D = $DebugCone

signal target_detected(target)
var detected_targets: Array = []

func _ready():
	detected_targets.clear()
	_update_debug_cone()
	
func _process(delta):
	if Engine.is_editor_hint():
		_update_debug_cone()

func _physics_process(delta):
	if not Engine.is_editor_hint():
		_update_vision()
		_update_debug_cone()

func _update_vision():
	detected_targets.clear()
	var angle_step = deg_to_rad(angle_deg) / (ray_count - 1)
	var start_angle = -deg_to_rad(angle_deg) / 2

	for i in range(ray_count):
		var angle = start_angle + angle_step * i
		var direction = Vector2.RIGHT.rotated(angle + rotation)
		var to = global_position + direction * distance
		var space_state = get_world_2d().direct_space_state

		var result = space_state.intersect_ray(PhysicsRayQueryParameters2D.create(global_position, to, detect_layer, [self.get_parent()]))

		if result and result.collider and result.collider not in detected_targets:
			detected_targets.append(result.collider)
			emit_signal("target_detected", result.collider)

func _update_debug_cone():
	if not debug_cone:
		return
	var points = [Vector2.ZERO]
	var angle_step = deg_to_rad(angle_deg) / (ray_count - 1)
	var start_angle = -deg_to_rad(angle_deg) / 2

	for i in range(ray_count):
		var angle = start_angle + angle_step * i
		var point = Vector2.RIGHT.rotated(angle) * distance
		points.append(point)

	debug_cone.polygon = points
	debug_cone.rotation = 0  # Reset, since we're using parent node rotation
