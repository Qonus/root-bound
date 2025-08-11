class_name HurtBox
extends Area2D

signal receved_damage(hitbox: HitBox)

@export var health: Health

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
	if (hitbox == null): return
	health.health -= hitbox.damage
	receved_damage.emit(hitbox)
	hitbox.on_damage_dealt.emit(get_node(get_path()))
