class_name EnemySpawner
extends Node

signal on_next_wave(wave_number: int)

@export var enabled: bool = true
@export var spawn_distance: float = 300
@export var despawn_distance: float = 500
@export var spawn_rate_per_minute: float = 10
@export var origin: Node2D = null
@export var enemy_instances: Array[PackedScene] = []
@export var waves: Array[Wave] = []
var current_wave: int = 0

#var max_bodies: int = 15
var bodies: Array[Ant] = []
var alive_bodies: int = 0
var spawning: bool = false

var timer: Timer = null
var hud: HUD = null
func _ready() -> void:
	timer = $Timer
	hud = get_tree().get_first_node_in_group("hud")

func _process(delta: float) -> void:
	if (!spawning && enabled && !hud.hints.get_hint(Hints.Hint.Start)):
		start_spawning()
	var alive: int = 0
	for i in range(bodies.size() - 1, -1, -1):
		if (!is_instance_valid(bodies[i])):
			bodies.remove_at(i)
			continue
		if ((bodies[i].global_position - origin.global_position).length() < despawn_distance):
			if (!bodies[i].dead): alive += 1
			continue
		despawn(bodies[i])
	
	alive_bodies = alive
	if (spawning && alive_bodies <= 0 && timer.is_stopped()):
		next_wave()

func start_spawning():
	on_next_wave.emit(current_wave + 1)
	_on_timer_timeout()
	spawning = true

func next_wave():
	on_next_wave.emit(current_wave + 1)
	timer.start()

func wave_spawn(wave: Wave):
	for i in range(wave.enemy_quantities.size()):
		for n in range(wave.enemy_quantities[i]):
			auto_spawn(i)

func auto_spawn(enemy_type: int) -> void:
	#if (bodies.size() >= max_bodies): return
	var spawn_position: Vector2 = Vector2.UP.rotated(randf()*360) * spawn_distance + origin.position
	var spawn_rotation: float = (origin.position - spawn_position).angle()
	spawn(enemy_type, spawn_position, spawn_rotation)

func spawn(enemy_type: int, position: Vector2, rotation: float) -> void:
	var newEnemy = enemy_instances[enemy_type].instantiate() as Ant
	newEnemy.global_position = position
	#newEnemy.rotation = rotation
	alive_bodies += 1
	add_sibling(newEnemy)
	bodies.append(newEnemy)

func despawn(body: Node2D):
	body.queue_free()
	bodies.erase(body)

func _on_timer_timeout() -> void:
	wave_spawn(waves[current_wave])
	PlayerParameters.score = current_wave
	current_wave += 1
	if (current_wave >= waves.size()):
		get_tree().change_scene_to_file("res://Scenes/win.tscn")
	#auto_spawn(randi_range(0, enemy_instances.size() - 1))
	#timer.wait_time = 60 / spawn_rate_per_minute + randf_range(-1, 1) + pow(bodies.size(), 2)/16
	#timer.start()
