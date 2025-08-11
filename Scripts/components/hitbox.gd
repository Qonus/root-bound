class_name HitBox
extends Area2D

signal on_damage_dealt(hurtbox: HurtBox)

@export var damage: int = 1 : set = set_damage, get = get_damage
@export var direction: Vector2 = Vector2() : set = set_direction, get = get_direction

func set_damage(value: int) -> void:
	damage = value

func get_damage() -> int:
	return damage

func set_direction(value: Vector2) -> void:
	direction = value
	
func get_direction() -> Vector2:
	return direction
