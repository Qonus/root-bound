extends Button

var enemy_spawner: EnemySpawner = null
func _ready() -> void:
	enemy_spawner = get_tree().get_first_node_in_group("enemy_spawner")
	if (enemy_spawner != null):
		enemy_spawner.connect("on_wave_end", on_wave_end)

func on_wave_end(i: int):
	if (i == enemy_spawner.waves.size()):
		text = "Last Wave"
	elif (i > enemy_spawner.waves.size()):
		text = "The end"
	show()

func _on_button_up() -> void:
	enemy_spawner.next_wave()
	hide()
