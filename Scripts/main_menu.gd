extends Node2D

@export var game_scene: PackedScene = null

func _on_new_game_button_button_up() -> void:
	get_tree().change_scene_to_packed(game_scene)
