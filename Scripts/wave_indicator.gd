extends Control

var enemy_spawner: EnemySpawner = null
var animation_player: AnimationPlayer = null
var wave_label: Label = null
func _ready() -> void:
	enemy_spawner = get_tree().get_first_node_in_group("enemy_spawner")
	enemy_spawner.connect("on_next_wave", on_next_wave)
	animation_player = $AnimationPlayer
	wave_label = $WaveLabel

func on_next_wave(wave_number: int) -> void:
	wave_label.text = "Wave %d" % wave_number
	animation_player.play("show_wave")
