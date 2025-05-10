extends Node

@export var mob_scene: PackedScene

func _ready() -> void:
	new_game()
	pass

func new_game():
	$Player.start()
	get_tree().call_group("mobs", "queue_free")
	#$Music.play()
