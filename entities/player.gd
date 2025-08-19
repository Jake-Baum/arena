extends CharacterBody2D

@export var projectile: PackedScene
@export_range(0, 1000, 1) var speed: float = 400
@export var debug = false:
	set(value):
		debug = value
		if vision:
			if vision.has_method("set_debug"):
				vision.set_debug(value)
@export_range(0, 500, 1) var projectile_spawn_distance = 60		

@onready var vision = $Vision
@onready var equipped: EquippedAbilities = get_node_or_null("EquippedAbilities")

var target: Node2D
var targetIndex: int = -1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cycle_targets"):
		if vision.detected_targets.size() > 0:
			if target:
				target.get_node("TargetHighlight").is_active = false
			targetIndex = (targetIndex + 1) % vision.detected_targets.size()
			target = vision.detected_targets[targetIndex]
			target.get_node("TargetHighlight").is_active = true
	
	if Input.is_action_just_pressed("spell_1") and target:
		if equipped:
			equipped.use_slot(0, self, target)
	
func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		
		if vision:
			vision.rotation = velocity.angle()
	else:
		$AnimatedSprite2D.stop()

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	move_and_slide()
