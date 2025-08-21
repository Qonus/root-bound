extends Node2D

var hud: HUD = null
var player_in: bool = false
func _ready() -> void:
	hud = get_tree().get_first_node_in_group("hud")

func _process(delta: float) -> void:
	if (Input.is_action_just_released("ui_cancel") && player_in):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_area_2d_body_entered(body: Player) -> void:
	hud.hints.set_hint(Hints.Hint.Return, true)
	player_in = true

func _on_area_2d_body_exited(body: Player) -> void:
	hud.hints.set_hint(Hints.Hint.Return, false)
	player_in = false
