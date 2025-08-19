class_name Ability
extends Resource

@export var name: String = ""
@export var icon: Texture2D

func use(user: Node2D, target: Node2D) -> void:
	push_error("Ability.use not implemented for %s" % name)
