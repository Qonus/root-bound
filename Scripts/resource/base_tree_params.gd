class_name TreeParams
extends Resource

@export var description: String = ""

@export var energy_per_body: float = 30
@export var max_energy: float = 80
@export var radius_multiplier: float = 4.0
@export var max_radius: float = 200
@export var sprite_frames: SpriteFrames = null

func _ready(node: Plant) -> void:
	pass

func _energy_update(node: Plant) -> void:
	pass

func _process(node: Plant, delta: float) -> void:
	pass

func _physics_process(node: Plant, delta: float) -> void:
	pass

func _die(node: Plant) -> void:
	pass

func _end(node: Plant) -> void:
	pass
