class_name HUD
extends Control

signal _on_choice(choice: int)

var health_bar: ProgressBar = null
var oxygen_bar: ProgressBar = null
var hints: Hints = null
var animation_player: AnimationPlayer = null

func _ready() -> void:
	health_bar = $HealthBar
	health_bar.value = 1
	oxygen_bar = $OxygenBar
	oxygen_bar.value = 1
	hints = $Hints
	animation_player = $AnimationPlayer

func show_dialogue() -> void:
	animation_player.play("show_dialogue")

func _on_dialogue_button_button_up(choice: int) -> void:
	animation_player.play("hide_dialogue")
	_on_choice.emit(choice)
