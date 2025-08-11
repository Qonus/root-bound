extends Node

var score: float = 0.0
var death_cause: String = ""
var player: RigidBody2D = null : get = get_player, set = set_player

func get_player() -> RigidBody2D:
	if (player == null):
		player = get_tree().get_first_node_in_group("player")
	return player

func set_player(player: RigidBody2D) -> void:
	player = player
