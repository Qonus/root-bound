class_name Bullet
extends Node2D

@export var speed := 200

@onready var direction: Vector2 = Vector2.UP.rotated(rotation) * speed

var hit_sound: AudioStreamPlayer = null
var hitbox: HitBox = null
var sprite: Sprite2D = null
func _ready() -> void:
	hit_sound = $HitSound
	hitbox = $StingHitBox
	hitbox.direction = direction
	sprite = $Sprite2D

func _process(delta: float) -> void:
	position += direction * delta
	pass

func _on_hit_box_on_damage_dealt(hurtbox: HurtBox) -> void:
	pass

func _on_hit_box_body_entered(body: Node2D) -> void:
	hit_sound.play()
	hitbox.queue_free()
	sprite.queue_free()
	await hit_sound.finished
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
