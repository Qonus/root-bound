class_name Ant
extends RigidBody2D

signal on_death()

@export var speed = 200
@export var attack_range = 40
@export var modification: AntModification = null
@export var ant_mass = 2.5

var player: Node2D
var dir := Vector2() # direction to player
var distance: float = 0.0
@export var dead: bool = false
var is_grabbed: bool = false
var can_attack: bool = true

var ant_animated_sprite: AnimatedSprite2D = null
var ant_skeleton: Skeleton2D = null
var ant_animation_player: AnimationPlayer = null
var ant_hitbox: HitBox = null
var ant_collision_shape: CollisionShape2D = null
var attack_cooldown_timer: Timer = null
var attack_sound: AudioStreamPlayer = null
func _ready() -> void:
	ant_animated_sprite = $AntAnimatedSprite2D
	ant_skeleton = $AntSkeleton2D
	ant_animation_player = $AntAnimationPlayer
	ant_hitbox = $AntAnimatedSprite2D/Claw/AntHitBox
	ant_collision_shape = $AntCollisionShape2D
	attack_cooldown_timer = $AttackCooldown
	#attack_sound = $AttackSound
	connect("body_entered", on_body_entered)
	if (dead): _on_health_on_health_depleted()
	if (modification != null): modification._ready(get_node(get_path()))

func _process(delta: float) -> void:
	if (player == null): return
	dir = (player.global_position - global_position).normalized()
	distance = (player.global_position - global_position).length()
	if (modification != null):
		modification._process(get_node(get_path()), delta)
		return
	if (dead): return
	ant_hitbox.direction = dir * 200
	if (can_attack && distance < attack_range):
		attack()
		can_attack = false
		attack_cooldown_timer.start()

func _physics_process(delta: float) -> void:
	if (is_grabbed):
		set_collision_mask_value(1, false)
		var angle_difference = wrapf(player.global_rotation + PI/2 - rotation, -PI, PI)
		scale /= 1.5
		rotation += angle_difference
		position += dir * distance
		#apply_torque(angle_difference * delta * 100 * 1000000)
		#apply_force(dir * 5000 * delta)
	else:
		#if (get_colliding_bodies().filter(func (node: Node2D): return node.is_in_group("player")).size() <= 0):
		set_collision_mask_value(1, true)
		ant_collision_shape.disabled = false
		
	if (player == null || dead): return
	
	if (modification != null):
		modification._physics_process(get_node(get_path()), delta)
	else:
		var angle_difference = wrapf(dir.angle() + PI/2 - rotation, -PI, PI)
		apply_torque(angle_difference * delta * 1000000)
		apply_force(dir * speed * 100 * delta)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		player = body

func _on_health_on_health_depleted() -> void:
	if (ant_animated_sprite == null): return
	ant_animated_sprite.play("dead")
	ant_skeleton.hide()
	on_death.emit()
	dead = true
	ant_hitbox.collision_layer = 0

func _on_hurt_box_receved_damage(hitbox: HitBox) -> void:
	apply_impulse(hitbox.direction/ant_mass, hitbox.global_position - global_position)
	#if (hitbox.name == "StingHitBox"):
		#player = get_node("../Player")

func attack() -> void:
	ant_animation_player.play("attack")

func on_body_entered(tree: Plant):
	if (!dead || tree == null): return
	queue_free()

func _on_attack_cooldown_timeout() -> void:
	can_attack = true
