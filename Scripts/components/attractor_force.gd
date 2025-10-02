class_name AttractorForce
extends Node2D

@export var force: float = 10.0

var id: int = -1
var grass: GrassShader = null
func _ready() -> void:
	grass = get_tree().get_first_node_in_group("grass")
	if (grass == null): return
	id = grass.attractor_forces.size()
	grass.attractor_forces.append(Circle.create(global_position, force))

func _process(delta: float) -> void:
	if (grass == null): return
	grass.attractor_forces[id].position = global_position
