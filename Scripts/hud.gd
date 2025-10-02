class_name HUD
extends Control

signal _on_choice(choice: int)

@export var player_health: PlayerHealthUI = null
var oxygen_meter: OxygenMeter = null
var vignette: Vignette = null
var hints: Hints = null
var animation_player: AnimationPlayer = null

func _ready() -> void:
	#player_health = $PlayerHealth
	oxygen_meter = $OxygenMeter
	oxygen_meter.fill_level = 1
	vignette = $Vignette
	hints = $Hints
	animation_player = $AnimationPlayer

func show_dialogue() -> void:
	animation_player.play("show_dialogue")

func _on_dialogue_button_button_up(choice: int) -> void:
	animation_player.play("hide_dialogue")
	_on_choice.emit(choice)
