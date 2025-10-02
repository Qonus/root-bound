@tool
class_name Vignette
extends ColorRect

@export var speed: float = 5.0
@export var strength: float = 0.5
@export var noise_texture: NoiseTexture2D = null
var time: float = 0.0

func _process(delta: float) -> void:
	material.set("shader_parameter/noise_texture", noise_texture);
	material.set("shader_parameter/strength", strength);
	time += delta
	(noise_texture.noise as FastNoiseLite).offset.x = 1000 * sin(time*speed)
	(noise_texture.noise as FastNoiseLite).offset.y = 1000 * cos(time*speed)
