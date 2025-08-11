class_name Hints
extends Control

enum Hint {
	Start,
	Grab,
	Return,
}

var hints: Dictionary = {}

func _ready() -> void:
	hints = {
		Hint.Start: $Start,
		Hint.Grab: $Grab,
		Hint.Return: $Return,
	}
	pass

func set_hint(hint: Hint, value: bool) -> void:
	(hints[hint] as CanvasItem).visible = value
	
func get_hint(hint: Hint) -> bool:
	return (hints[hint] as CanvasItem).visible
