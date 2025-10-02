@tool
extends Button

@export var tree: TreeParams

@export var image: TextureRect
@export var description: Label

func _ready() -> void:
	if (tree == null): return
	image.texture = tree.sprite_frames.get_frame_texture("default", 2)
	description.text = tree.description
