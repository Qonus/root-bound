@tool
class_name HoneyComb
extends TextureRect

@export var animation_player: AnimationPlayer = null

func restore():
	animation_player.play("restore")

func damage():
	animation_player.play("damage")
