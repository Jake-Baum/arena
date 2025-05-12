extends RigidBody2D

@export_range(0, 1000.0, 1.0) var speed: float = 200
@export_range(0, 1000, 1) var damage: int = 1

var _target: Node2D
var initialized = false

func init(relative_position: Vector2, target: Node2D) -> void:
	global_position = relative_position
	_target = target
	initialized = true
	
func _ready() -> void:
	assert(initialized, "Projectile is not initialized")
	$AnimatedSprite2D.play()
	rotate_towards_target()

func _physics_process(delta: float) -> void:
	var direction = (_target.global_position - global_position).normalized()
	rotate_towards_target()
	linear_velocity = direction * speed

func _on_body_entered(body: Node) -> void:
	if body.has_method("damage"):
		body.damage(damage)
	queue_free()

func rotate_towards_target():
	set_global_rotation((_target.global_position - global_position).angle())
