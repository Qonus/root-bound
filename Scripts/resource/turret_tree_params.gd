class_name TurretTreeParams
extends TreeParams

@export var attack_range: float = 100
@export var bullet: PackedScene = null
@export var cooldown: float = 0.4

var last_fire: int = 0
func _ready(node: Node2D) -> void:
	pass

func _process(node: Node2D, delta: float):
	var collisions = PhysicsService.cast_circle(node, attack_range, node.global_position)
	var closest_ant: Ant = null
	for collision in collisions:
		var ant = collision.collider as Ant
		if (ant == null || ant.dead): continue
		var dir = ant.position - node.global_position
		if (closest_ant == null ||
		dir.length() < (closest_ant.position - node.global_position).length()):
			closest_ant = ant
	
	if (closest_ant == null): return
	if (cooldown * 1000000 < Time.get_ticks_usec() - last_fire):
		shoot(node, closest_ant)
		last_fire = Time.get_ticks_usec()

func shoot(node: Node2D, closest_ant: Ant):
	var newBullet = bullet.instantiate() as Node2D
	var dir = closest_ant.position - node.global_position
	newBullet.position = node.global_position + dir.normalized() * 20
	newBullet.rotation = dir.angle() + PI/2
	node.add_sibling(newBullet)
