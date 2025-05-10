@tool
extends Node2D

@export var is_active: bool = false:
	set(value):
		is_active = value
		$Circle.visible = value

func _ready() -> void:
	is_active = Engine.is_editor_hint()
