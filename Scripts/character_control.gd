class_name Player
extends RigidBody2D

@export var speed = 8
@export var sting: PackedScene

@export var dash_force: float = 200.0;
@export var dash_cool_down: float = 0.5;
var dash_timer: float = 0.0;
var is_dashing: bool = false

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
var oxygen_damage_time: float = 2.0
var oxygen_damage_timer: float = 0.0
var oxygen_areas: int = 0
# HEALTH
var dead: bool = false

var grabable_area: Area2D = null
var sting_timer: Timer
var hud: HUD
var health: Health
#var start_time: int = 0
var animation_player: AnimationPlayer = null
var darkness: Darkness = null
var darkness_id: int = -1
func _ready() -> void:
	sting_timer = $StingTimer
	grabable_area = $GrabableArea2D
	health = $Health
	animation_player = $AnimationPlayer
	hud = get_tree().get_first_node_in_group("hud")
	if (hud != null):
		hud.player_health.max_health = health.max_health
	darkness = get_tree().get_first_node_in_group("darkness")
	if (darkness != null):
		darkness_id = darkness.circles.size()
		darkness.circles.append(Circle.create(global_position, 0))
	#start_time = Time.get_ticks_usec()

var can_sting: bool = true
func _on_sting_timer_timeout() -> void:
	can_sting = true

var vignette_strength = 0.0
func _process(delta: float) -> void:
	update_visuals();
	#PlayerParameters.score = (Time.get_ticks_usec() - start_time) / 1000000
	if (dead): return
#	OXYGEN METER UPDATE
	if (oxygen_enabled && !hud.hints.get_hint(Hints.Hint.Start)):
		if (oxygen_areas > 0):
			oxygen += 1.5 * delta
			oxygen_damage_timer = 0.0
			vignette_strength = 0.0
		else:
			oxygen -= delta
			vignette_strength = 1-oxygen/max_oxygen
		oxygen = clamp(oxygen, 0, max_oxygen)
		hud.vignette.strength = lerpf(hud.vignette.strength, vignette_strength, 0.04)
		hud.oxygen_meter.fill_level = oxygen / max_oxygen
		if (oxygen <= 0):
			oxygen_damage_timer += delta
			if (oxygen_damage_timer > oxygen_damage_time):
				health.health -= 1
				oxygen_damage_timer = 0.0

#	MOVEMENT DIRECTION
	move_direction = Vector2()
	move_direction.x += Input.get_axis("ui_left", "ui_right")
	move_direction.y += Input.get_axis("ui_up", "ui_down")
	move_direction = move_direction.normalized()
	
#	MOUSE DIRECTION
	mouse_direction = get_global_mouse_position() - position

#	ANIMATION
	if (move_direction == Vector2() && !is_dashing):
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
	
	
#	DASH
	dash_timer += delta;
	var dir = (get_global_mouse_position() - global_position).normalized()
	if (Input.is_action_just_pressed("dash") && dash_timer >= dash_cool_down):
		apply_impulse(dir * dash_force)
		dash_timer = 0.0
		is_dashing = true
	if (is_dashing):
		target_rotation = dir.angle() + PI/2
	if (is_dashing && dash_timer >= 0.2):
		is_dashing = false


func update_visuals():
	if (darkness != null):
		darkness.circles[darkness_id].position = global_position
		darkness.circles[darkness_id].radius = lerpf(darkness.circles[darkness_id].radius, (1-vignette_strength) * 60 + 50, 0.05)

func set_hud_hint(hint_type: Hints.Hint, value: bool):
	if (hud == null): return
	hud.hints.set_hint(hint_type, value)

func _physics_process(delta: float) -> void:
	if (health.health <= 0): return
	rotation = lerp_angle(rotation, target_rotation, 0.5)
	if (!is_dashing):
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
	apply_impulse(hitbox.direction)

func _on_health_on_health_change(diff: int) -> void:
	hud.player_health.health = float(health.health)
	if (diff < 0):
		health.set_temporary_immortality(0.5)
		if(!animation_player.is_playing()):
			animation_player.play("hurt")

func die(cause: String = "health depletion") -> void:
	PlayerParameters.death_cause = cause
	dead = true
	animation_player.play("die")
	move_direction = Vector2()
	await get_tree().create_timer(2.0).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
