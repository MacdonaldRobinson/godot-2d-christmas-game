extends Area2D

onready var gifts:Node2D = $"../gifts"
var rand_generate = RandomNumberGenerator.new()
var cycle_counter = 0

func _on_Timer_timeout():	
	cycle_counter+=1
	
	var gift:Area2D = get_random_gift()
	
	if gift == null:
		return
	
	var new_instance:Area2D = gift.duplicate()
	self.add_child(new_instance)
	
	new_instance.global_position.x = get_random_spawn_position_x()
	new_instance.global_position.y = 0
	
	
func get_random_spawn_position_x() -> float:
	rand_generate.randomize()
	var rand_float = rand_generate.randf_range(100, 1600)
	
	return rand_float	
			
func get_random_gift() -> Area2D:
	rand_generate.randomize()	
	var gifts_in_cycle = []
	
	for child in gifts.get_children():
		if child is Gift:
			var rarity = cycle_counter % child.rarity_show_in_x_cycles
			if rarity == 0:
				gifts_in_cycle.append(child)
				
	var rand_int = rand_generate.randi_range(0, gifts_in_cycle.size() -1)
	
	var gift:Area2D = null
	
	if gifts_in_cycle.size() > 0:
		gift = gifts_in_cycle[rand_int]

	return gift			
