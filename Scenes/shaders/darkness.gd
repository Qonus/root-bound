@tool
class_name Darkness
extends Sprite2D

@export var color: Color
@export var border_color: Color
@export var border_width: float = 150
@export var speed: float = 0.1
@export var noise: float = 15.0
@export var circles: Array[Circle] = []
@export var noise_texture: NoiseTexture2D = null

var time: float = 0.0;

func _process(delta: float) -> void:
	material.set("shader_parameter/color", color)
	material.set("shader_parameter/border_color", border_color)
	material.set("shader_parameter/border_width", border_width)
	material.set("shader_parameter/world_position", global_position)
	material.set("shader_parameter/scale", global_scale)
	material.set("shader_parameter/circles", circles.map(func (circle: Circle): return Vector3(circle.position.x, circle.position.y, circle.radius)))
	material.set("shader_parameter/num_circles", circles.size())
	material.set("shader_parameter/noise", noise)
	material.set("shader_parameter/noise_texture", noise_texture)
	
	time += delta
	(noise_texture.noise as FastNoiseLite).offset.x = 1000 * sin(time*speed)
	(noise_texture.noise as FastNoiseLite).offset.y = 1000 * cos(time*speed)
	pass
