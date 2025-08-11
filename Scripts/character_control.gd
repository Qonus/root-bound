class_name Player
extends RigidBody2D

@export var speed = 8
@export var sting: PackedScene

# SMOOTHER
var target_rotation := 0.0
# INPUT
var move_direction := Vector2()
var mouse_direction := Vector2()
# GRAB
var grabbed: bool = false
var grabable: Ant = null
# OXYGEN
@export var max_oxygen: float = 20.0
@export var oxygen_enabled: bool = true
@onready var oxygen: float = max_oxygen
var oxygen_areas: int = 0
# HEALTH
var dead: bool = false

var grabable_area: Area2D = null
var sting_timer: Timer
var hud: HUD
var health: Health
#var start_time: int = 0
var animation_player: AnimationPlayer = null
func _ready() -> void:
	sting_timer = $StingTimer
	grabable_area = $GrabableArea2D
	health = $Health
	animation_player = $AnimationPlayer
	hud = get_tree().get_first_node_in_group("hud")
	#start_time = Time.get_ticks_usec()

var can_sting: bool = true
func _on_sting_timer_timeout() -> void:
	can_sting = true

func _process(delta: float) -> void:
	#PlayerParameters.score = (Time.get_ticks_usec() - start_time) / 1000000
	if (dead): return
#	OXYGEN METER UPDATE
	if (oxygen_enabled && !hud.hints.get_hint(Hints.Hint.Start)):
		if (oxygen_areas > 0):
			oxygen += 1.5 * delta
		else:
			oxygen -= delta
		oxygen = clamp(oxygen, 0, max_oxygen)
		hud.oxygen_bar.value = oxygen / max_oxygen
		if (oxygen <= 0):
			die("Not enough Oxygen")

#	MOVEMENT DIRECTION
	move_direction = Vector2()
	move_direction.x += Input.get_axis("ui_left", "ui_right")
	move_direction.y += Input.get_axis("ui_up", "ui_down")
	move_direction = move_direction.normalized()
	
#	MOUSE DIRECTION
	mouse_direction = get_global_mouse_position() - position

#	ANIMATION
	if (move_direction == Vector2()):
		$PlayerAnimatedSprite2D.animation = "idle"
	else:
		set_hud_hint(Hints.Hint.Start, false)
		$PlayerAnimatedSprite2D.play("fly");
	
#	ROTATION
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		var shoot_dir := -mouse_direction.normalized()
		target_rotation = shoot_dir.angle() + PI/2
#		SHOOTING
		if (can_sting):
			set_hud_hint(Hints.Hint.Start, false)
			shoot(shoot_dir)
			can_sting = false
			sting_timer.start()
	elif (move_direction.length() > 0):
		target_rotation = move_direction.angle() + PI/2
		
#	GRABABLES
	if (!is_instance_valid(grabable)):
		grabbed = false
	grabable = null
	if (grabable_area.has_overlapping_bodies()):
		var bodies: Array[Node2D] = grabable_area.get_overlapping_bodies()
		for i in range(bodies.size()):
			if (bodies[i] is not Ant || bodies[i].dead == false): continue
			if (grabable == null ||
			(grabable.global_position - global_position).length() > (bodies[i].global_position - global_position).length()):
				grabable = bodies[i]
		if (grabable != null):
			set_hud_hint(Hints.Hint.Grab, true)
		else:
			set_hud_hint(Hints.Hint.Grab, false)
	else:
		set_hud_hint(Hints.Hint.Grab, false)
	
#	GRAB IF NOT
	if (!grabbed && grabable != null && Input.is_action_just_released("grab")):
		grab()
#	THROW IF GRABBED
	elif (grabbed && Input.is_action_just_released("throw")):
		throw()

func set_hud_hint(hint_type: Hints.Hint, value: bool):
	if (hud == null): return
	hud.hints.set_hint(hint_type, value)

func _physics_process(delta: float) -> void:
	if (health.health <= 0): return
	rotation = lerp_angle(rotation, target_rotation, 0.5)
	apply_force(move_direction * delta * speed * 10000)

func shoot(shoot_dir: Vector2) -> void:
	var newSting = sting.instantiate() as Node2D
	newSting.position = position
	newSting.global_rotation = shoot_dir.angle() - PI/2
	add_sibling(newSting)

func grab() -> void:
	set_hud_hint(Hints.Hint.Grab, false)
	grabbed = true
	grabable.is_grabbed = true

func throw() -> void:
	grabbed = false
	grabable.position += mouse_direction.normalized() * 20
	grabable.apply_impulse(mouse_direction.normalized() * 500)
	grabable.apply_torque_impulse(5000)
	grabable.is_grabbed = false
	grabable = null

# DAMAGE
func _on_hurt_box_receved_damage(hitbox: HitBox) -> void:
	health.set_temporary_immortality(0.5)
	apply_impulse(hitbox.direction)
	if(!animation_player.is_playing()):
		animation_player.play("hurt")

func _on_health_on_health_change(diff: int) -> void:
	hud.health_bar.value = float(health.health) / float(health.max_health)

func die(cause: String = "health depletion") -> void:
	PlayerParameters.death_cause = cause
	move_direction = Vector2()
	dead = true
	animation_player.play("die")
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
