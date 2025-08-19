class_name ProjectileAbility
extends Ability

@export var projectile_scene: PackedScene
@export_range(0, 500, 1) var projectile_spawn_distance: float = 60

func use(user: Node2D, target: Node2D) -> void:
	assert(projectile_scene != null, "ProjectileAbility.use: projectile_scene must be assigned")
	assert(is_instance_valid(user), "ProjectileAbility.use: user must be a valid Node2D")
	assert(is_instance_valid(target), "ProjectileAbility.use: target must be a valid Node2D")
	
	var proj: Node2D = projectile_scene.instantiate()
	var direction := (target.global_position - user.global_position).normalized()
	if proj.has_method("init"):
		proj.init(user.global_position + direction * projectile_spawn_distance, target)
	# Add to the same scene as the user
	user.get_tree().current_scene.add_child(proj)
