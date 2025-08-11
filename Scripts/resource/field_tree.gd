class_name FieldTreeParams
extends TreeParams

@export var field_radius: float = 80
@export var fan_power: float = 100

var field_effect: OxygenEffect = null
var circle_id: int = -1
func _ready(node: Node2D) -> void:
	field_effect = node.get_tree().get_first_node_in_group("field_effect")

func _process(node: Node2D, delta: float) -> void:
	if (circle_id == -1):
		circle_id = field_effect.circles.size()
		field_effect.circles.append(Circle.create(node.global_position, field_radius))
	var collisions = PhysicsService.cast_circle(node, field_radius, node.global_position)
	#for collision in collisions:
		#var bullet = collision.collider as Bullet
		#if (bullet == null || bullet.is_in_group("sting")): continue
		#bullet.queue_free()

func _physics_process(node: Node2D, delta: float):
	var collisions = PhysicsService.cast_circle(node, field_radius, node.global_position)
	for collision in collisions:
		var ant = collision.collider as Ant
		if (ant != null):
			var dir = ant.global_position - node.global_position
			if (ant.dead):
				ant.apply_force(-dir.normalized() * fan_power)
			else:
				ant.apply_force(dir.normalized() * fan_power)
