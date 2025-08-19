extends RigidBody2D

@export_range(0, 1000.0, 1.0) var speed: float = 200
@export_range(0, 1000, 1) var damage: int = 1

var _target: Node2D
var initialized = false
var _last_known_target_position: Vector2

func init(relative_position: Vector2, target: Node2D) -> void:
	global_position = relative_position
	_target = target
	_last_known_target_position = target.global_position
	initialized = true
	
func _ready() -> void:
	assert(initialized, "Projectile is not initialized")
	$AnimatedSprite2D.play()
	rotate_towards_target()

func _physics_process(delta: float) -> void:
	if not is_instance_valid(_target):
		queue_free()
		return
	var direction = (_target.global_position - global_position).normalized()
	rotate_towards_target()
	linear_velocity = direction * speed

func _on_body_entered(body: Node) -> void:
	var stats = body.get_node_or_null("Stats")
	if stats:
		stats.modify_health(-damage)
	queue_free()

func rotate_towards_target():
	if not is_instance_valid(_target):
		return
	set_global_rotation((_target.global_position - global_position).angle())
