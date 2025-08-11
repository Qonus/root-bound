@tool
class_name OxygenEffect
extends Sprite2D

@export var circles: Array[Circle] = []

func _process(delta: float) -> void:
	material.set("shader_parameter/world_position", global_position)
	material.set("shader_parameter/scale", global_scale)
	material.set("shader_parameter/circles", circles.map(func (circle: Circle): return Vector3(circle.position.x, circle.position.y, circle.radius)))
	material.set("shader_parameter/num_circles", circles.size())
	pass
