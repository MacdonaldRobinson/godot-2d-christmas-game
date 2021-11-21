extends Area2D
class_name Gift

export var fall_speed:float = 5
export var rarity_show_in_x_cycles:int = 1
onready var sprite = $Sprite
export(NodePath) onready var collect_sound

signal gift_collected(gift, collect_sound)

func _ready():
	if self.get_parent().visible == false:
		self.set_process(false)
		return
		
	var visibility_notifier = VisibilityNotifier2D.new()
	visibility_notifier.connect("screen_exited", self, "_gift_exited_screen")	
	self.add_child(visibility_notifier)
	

func _process(delta):
	self.global_position.y += fall_speed

func _on_gift_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("gift_collected", sprite, collect_sound)
		queue_free()
		
func _gift_exited_screen():
	queue_free()
