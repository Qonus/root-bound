extends Node2D

@export var default_leg_anchor: Node2D
@export var max_distance: float = 13

var target: Vector2 = Vector2()

func _ready() -> void:
	target = global_position

func _process(delta: float) -> void:
	var dir := default_leg_anchor.global_position - global_position
	if (dir.length() > max_distance):
		target += dir * 1.2
	global_position = lerp(global_position, target, 0.5)
