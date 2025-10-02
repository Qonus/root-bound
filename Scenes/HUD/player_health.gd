@tool
class_name PlayerHealthUI
extends Control

@export var health_slot: PackedScene = null
@export var health_slots: Array[HoneyComb] = []
@export var slot_container: Node = null
@export var max_health: int = 0 : set = set_max_health
@export var health: int = 0 : set = set_health

func set_health(new_val: int):
	var new_health = clampi(new_val, 0, max_health)
	
	var diff = new_health - health
	for i in range(min(health, new_health), max(health, new_health)):
		if (max_health <= i): continue
		if (diff < 0):
			health_slots[i].damage()
		else:
			health_slots[i].restore()
	
	health = new_health

func set_max_health(new_val: int):
	if (new_val < 0): return
	var diff = new_val - max_health
	for i in range(min(max_health, new_val), max(max_health, new_val)):
		if (diff < 0):
			if (health_slots.size() > i): continue
			health_slots[i].queue_free()
			health_slots.pop_back()
		else:
			var new_health_slot: HoneyComb = health_slot.instantiate()
			health_slots.append(new_health_slot)
			slot_container.add_child(new_health_slot)
	
	max_health = new_val
	health = new_val
