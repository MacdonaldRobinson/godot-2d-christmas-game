extends Control

onready var candy_count:Label = $HBoxContainer/CandyCount
onready var nude_count:Label = $HBoxContainer2/NudeCount
onready var jameson_assist_count:Label = $HBoxContainer3/JamesonAssistsCount

onready var animation_player = $AnimationPlayer
onready var jameson_assist_popup = $JamesonAssistPopup
onready var jameson_assist_popup_timer = $JamesonAssistPopup/JamesonAssistPopupTimer

var is_being_assisted = false

func _on_RedCandy_gift_collected(gift, collect_sound):
	candy_count.text = String(int(candy_count.text) + 1)	
	get_node(collect_sound).play()

func _on_Nude_gift_collected(gift, collect_sound):
	nude_count.text = String(int(nude_count.text) + 1)
	get_node(collect_sound).play()
		
func _on_JamesonAssist_gift_collected(gift, collect_sound):
	if is_being_assisted:
		return
	
	get_node(collect_sound).play()
		
	jameson_assist_count.text = String(int(jameson_assist_count.text) + 1)
			
	jameson_assist_popup.show()	
	animation_player.play("jameson_assist_popup")
	jameson_assist_popup_timer.start()
	is_being_assisted = true

func _on_JamesonAssistPopup_timeout():
	animation_player.play_backwards("jameson_assist_popup")
	yield(get_tree().create_timer(1), "timeout")
	jameson_assist_popup.hide()
		
func _on_JamesonAssistTimer_timeout():
	is_being_assisted = false
