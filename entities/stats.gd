extends Node

signal health_changed(current_health: float, max_health: float)
signal health_depleted

@export var max_health: float = 100.0
var current_health: float

func _ready() -> void:
	current_health = max_health

func modify_health(amount: float) -> void:
	current_health = clamp(current_health + amount, 0, max_health)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		health_depleted.emit()

func get_health_percentage() -> float:
	return current_health / max_health 
