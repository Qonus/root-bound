class_name Plant
extends RigidBody2D

@export var trees: Array[TreeParams] = []
var current_tree

var energy: float = 0.0
var player_inside: bool = false

var tree_animation_player: AnimationPlayer = null
var tree_animated_sprite: AnimatedSprite2D = null
var grow_sound: AudioStreamPlayer2D = null
var area_shape: CollisionShape2D = null
var oxygen_effect: OxygenEffect = null
var hud: HUD = null
#var player: Player = null
var circle_id: int = -1
func _ready() -> void:
	tree_animated_sprite = $TreeAnimatedSprite2D
	tree_animation_player = $TreeAnimationPlayer
	grow_sound = $GrowSound
	area_shape = $OxygenArea/CollisionShape2D
	tree_animated_sprite.material.set("shader_parameter/amplitude", 0)
	oxygen_effect = get_tree().get_first_node_in_group("oxygen_effect")
	hud = get_tree().get_first_node_in_group("hud")
	#player = get_tree().get_first_node_in_group("player")
	connect("body_entered", _on_body_entered)

func _process(delta: float) -> void:
	if (energy > 0):
		var radius = clamp(current_tree.radius_multiplier * energy, 0, current_tree.max_radius)
		oxygen_effect.circles[circle_id].position = global_position
		oxygen_effect.circles[circle_id].radius = radius
		(area_shape.shape as CircleShape2D).radius = radius
		energy -= delta
		current_tree._process(get_node(get_path()), delta)
		if (energy <= 0):
			current_tree._end(get_node(get_path()))
			energy = 0
			oxygen_effect.circles[circle_id].radius = -10
			tree_animation_player.play("die")
			tree_animated_sprite.material.set("shader_parameter/amplitude", 0)

func _physics_process(delta: float) -> void:
	if (energy > 0):
		current_tree._physics_process(get_node(get_path()), delta)

func _on_body_entered(ant: Ant):
	if (ant == null || ant.dead == false): return
	if (energy <= 0):
		hud.connect("_on_choice", _on_choice)
		hud.show_dialogue()
		get_tree().paused = true
		return
	grow()

func grow() -> void:
	tree_animation_player.play("grow")
	grow_sound.play()
	tree_animated_sprite.material.set("shader_parameter/amplitude", 0.05)
	energy += current_tree.energy_per_body
	if (energy > current_tree.max_energy): energy - current_tree.max_energy
	current_tree._energy_update(get_node(get_path()))
	if (circle_id == -1):
		circle_id = oxygen_effect.circles.size()
		oxygen_effect.circles.append(Circle.create(global_position, energy))

func _on_choice(choice: int) -> void:
	hud.disconnect("_on_choice", _on_choice)
	current_tree = trees[choice]
	get_tree().paused = false
	tree_animated_sprite.sprite_frames = current_tree.sprite_frames
	current_tree._ready(get_node(get_path()))
	grow()

func _on_oxygen_area_body_entered(player: Player) -> void:
	if (player == null || player_inside): return
	player.oxygen_areas += 1
	player_inside = true

func _on_oxygen_area_body_exited(player: Player) -> void:
	if (player == null || !player_inside): return
	player.oxygen_areas -= 1
	player_inside = false
