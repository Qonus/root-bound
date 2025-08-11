class_name AntTurretModification
extends AntModification

@export var cooldown: float = 0.3
@export var bullet: PackedScene = null

var last_fire: int = 0
var dir: Vector2 = Vector2()
func _ready(node: Ant):
	pass

func _process(node: Ant, delta: float) -> void:
	if (node.player == null || node.player.health.health <= 0 || node.dead): return
	
	dir = node.player.position - node.global_position
	if (cooldown * 1000000 < Time.get_ticks_usec() - last_fire):
		shoot(node, node.player)
		last_fire = Time.get_ticks_usec()

func shoot(node: Ant, player: Player):
	var newBullet = bullet.instantiate() as Node2D
	newBullet.position = node.global_position # + dir.normalized() * 20
	newBullet.rotation = dir.angle() + PI/2
	node.add_sibling(newBullet)

func _physics_process(node: Ant, delta: float) -> void:
	if (node.player == null || node.player.health.health <= 0 || node.dead): return
	var angle_difference = wrapf(dir.angle() + PI/2 - node.rotation, -PI, PI)
	node.apply_torque(angle_difference * delta * 1000000)
	node.apply_force(dir.normalized() * (dir.length() - node.attack_range) * node.speed * delta)
