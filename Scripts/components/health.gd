class_name Health
extends Node

signal on_max_health_change(diff: int)
signal on_health_change(diff: int)
signal on_health_depleted

@export var max_health: int = 10 : set = set_max_health, get = get_max_health
@export var immortality: bool = false : set = set_immortality, get = get_immortality

var immortality_timer: Timer = null

@onready var health: int = max_health : set = set_health, get = get_health

func get_max_health() -> int:
	return max_health

func set_max_health(value: int):
	var clamped_value = 1 if value <= 0 else value
	if (clamped_value == max_health): return
	
	var difference = clamped_value - max_health
	max_health = clamped_value
	on_max_health_change.emit(difference)
	
	if (health > max_health):
		health = max_health


func get_immortality() -> bool:
	return immortality

func set_immortality(value: bool) -> void:
	immortality = value

func set_temporary_immortality(time: float):
	if immortality_timer == null:
		immortality_timer = Timer.new()
		immortality_timer.one_shot = true
		add_child(immortality_timer)
		
	if (immortality_timer.timeout.is_connected(set_immortality)):
		immortality_timer.timeout.disconnect(set_immortality)
		
	immortality_timer.set_wait_time(time)
	immortality_timer.timeout.connect(set_immortality.bind(false))
	immortality = true
	immortality_timer.start()


func get_health() -> int:
	return health

func set_health(value: int) -> void:
	if (value < health and immortality): return
	
	var clamped_value = clamp(value, 0, max_health)
	
	if (clamped_value == health): return
	
	var difference = clamped_value - health
	health = clamped_value
	on_health_change.emit(difference)
	
	if (health == 0):
		on_health_depleted.emit()
	
