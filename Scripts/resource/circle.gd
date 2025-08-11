class_name Circle
extends Resource

@export var position: Vector2
@export var radius: float

static func create(position: Vector2, radius: float) -> Circle:
	var circle = Circle.new()
	circle.position = position
	circle.radius = radius
	return circle
