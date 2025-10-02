@tool
class_name OxygenMeter
extends Control

@export var filler: Control = null
@export var fill_level = 0.5

func _process(delta: float) -> void:
	filler.material.set("shader_parameter/fill_level", fill_level)
