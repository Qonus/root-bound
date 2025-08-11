extends Node2D

@export var game_scene: PackedScene = null
@export var menu_scene: PackedScene = null

func _ready() -> void:
	($CanvasLayer/Score as Label).text = "survived %d waves" % PlayerParameters.score
	($CanvasLayer/Title/Cause as Label).text = PlayerParameters.death_cause

func _on_restart_button_button_up() -> void:
	get_tree().change_scene_to_packed(game_scene)

func _on_main_menu_button_button_up() -> void:
	get_tree().change_scene_to_packed(menu_scene)
