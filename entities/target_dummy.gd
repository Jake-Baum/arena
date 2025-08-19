extends StaticBody2D

func _on_health_depleted() -> void:
	queue_free()
