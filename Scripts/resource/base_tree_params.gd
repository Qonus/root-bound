class_name TreeParams
extends Resource

@export var energy_per_body: float = 30
@export var max_energy: float = 80
@export var radius_multiplier: float = 4.0
@export var max_radius: float = 200
@export var sprite_frames: SpriteFrames = null

func _ready(node: Node2D) -> void:
	pass

func _energy_update(node: Node2D) -> void:
	pass

func _process(node: Node2D, delta: float) -> void:
	pass

func _physics_process(node: Node2D, delta: float) -> void:
	pass

func _end(node: Node2D) -> void:
	pass
