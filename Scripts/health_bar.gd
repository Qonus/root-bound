extends ProgressBar

var player: Health
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player").get_node("Health")
	if (player == null): return
	player.connect("on_health_change", on_health_change)
	value = 1
	
func on_health_change(diff: int):
	value = float(player.health)/float(player.max_health)
