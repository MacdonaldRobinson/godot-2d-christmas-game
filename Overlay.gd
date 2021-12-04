extends Control

onready var candy_count:Label = $HBoxContainer/CandyCount
onready var nude_count:Label = $HBoxContainer2/NudeCount
onready var jameson_assist_count:Label = $HBoxContainer3/JamesonAssistsCount

onready var animation_player = $AnimationPlayer
onready var jameson_assist_popup = $JamesonAssistPopup
onready var jameson_assist_popup_timer = $JamesonAssistPopup/JamesonAssistPopupTimer

var is_being_assisted = false
var time_start:int = 20

onready var time_left_in_seconds:Label = $HBoxContainer4/TimeLeftInSeconds
onready var count_down_timer:Timer = $HBoxContainer4/CountDownTimer
onready var game_over_popup:Popup = $GameOver

onready var your_name:LineEdit = $GameOver/VBoxContainer/SubmitScore/YourNameWrapper/YourName
onready var get_leaderboard_request = $GameOver/GetLeaderBoardRequest
onready var post_leaderboard_request = $GameOver/PostLeaderBoardRequest

var webservice_url = "https://maconly.000webhostapp.com/nude-christmas-game.php?method={method}"

onready var leader_board:VBoxContainer = $GameOver/VBoxContainer/LeaderBoardContainer/ScrollContainer/LeaderBoard
onready var submit_score_panel:VBoxContainer = $GameOver/VBoxContainer/SubmitScore
onready var leader_board_panel:VBoxContainer = $GameOver/VBoxContainer/LeaderBoardContainer

var leaderboard_item:PackedScene = preload("res://LeaderBoardItem.tscn")

func _ready():
	reset()

func _on_RedCandy_gift_collected(gift, collect_sound):
	candy_count.text = String(int(candy_count.text) + 1)	
	get_node(collect_sound).play()

func _on_Nude_gift_collected(gift, collect_sound):
	nude_count.text = String(int(nude_count.text) + 1)
	get_node(collect_sound).play()

func reset():
	game_over_popup.hide()
	submit_score_panel.show()
	leader_board_panel.hide()
	time_left_in_seconds.text = String(time_start)

func resume_game():
	get_tree().paused = false			

func pause_game():
	get_tree().paused = true

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
	jameson_assist_popup.hide()
		
func _on_JamesonAssistTimer_timeout():
	is_being_assisted = false
	
	
func _on_CountDownTimer_timeout():
	var current_timer = int(time_left_in_seconds.text)
	current_timer = current_timer - 1
	
	time_left_in_seconds.text = String(current_timer)
	
	if current_timer == 0:		
		animation_player.play("game_over_popup")

func get_leader_board():
	var url = webservice_url.replace("{method}", "get_all_as_json")
	get_leaderboard_request.request(url)
	

func submit_to_leader_board(your_name:String):
	var url = webservice_url.replace("{method}", "add_or_update_entry")
	var new_entry:LeaderBoardModel = LeaderBoardModel.new()
	new_entry.Name = your_name
	new_entry.Number_Of_Candies = int(candy_count.text)
	new_entry.Number_Of_Jameson_Assists = int(jameson_assist_count.text)
	new_entry.Number_Of_Nude_Logos = int(nude_count.text)
	
	var data = to_json(get_dictionary_entry(new_entry));
	
	var headers = []
	var result = post_leaderboard_request.request(url, headers, true, HTTPClient.METHOD_POST, data)

func get_entry_from_json(json_entry) -> LeaderBoardModel:
	var entry:LeaderBoardModel = LeaderBoardModel.new()
	entry.Name = json_entry.Name
	entry.Number_Of_Candies = json_entry.Number_Of_Candies
	entry.Number_Of_Jameson_Assists = json_entry.Number_Of_Jameson_Assists
	entry.Number_Of_Nude_Logos = json_entry.Number_Of_Nude_Logos	
	
	return entry
	
func get_dictionary_entry(entry:LeaderBoardModel)->Dictionary:
	var json_entry = {
		"Name": entry.Name,
		"Number_Of_Candies": entry.Number_Of_Candies,
		"Number_Of_Jameson_Assists": entry.Number_Of_Jameson_Assists,
		"Number_Of_Nude_Logos": entry.Number_Of_Nude_Logos		
	}
	
	return json_entry
	
func get_json_entries(entries:Array)->Array:
	var json_entries = []
	for entry in entries:
		var json_entry:String = to_json(get_dictionary_entry(entry))
		json_entries.append(json_entry)
		
	return json_entries
	
func get_array_from_json(json_entries:Array)->Array:
	var entries = []
	for json_entry in json_entries:
		var entry:LeaderBoardModel = get_entry_from_json(json_entry)
		entries.append(entry)
		
	return entries
	

func render_leader_board(json_entries:Array):
	submit_score_panel.hide()
	leader_board_panel.show()	
	
	for ui_entry in leader_board.get_children():
		leader_board.remove_child(ui_entry)
	
	var entries:Array = get_array_from_json(json_entries)
	var index:int = 1
	for entry in entries:
		if entry is LeaderBoardModel:			
			var leader_board_item:LeaderBoardItem = leaderboard_item.instance()
			leader_board_item.player_standing = index
			leader_board_item.name_of_player = entry.Name
			leader_board_item.candies_amount = entry.Number_Of_Candies
			leader_board_item.nude_logos_amount = entry.Number_Of_Nude_Logos
			leader_board_item.jameson_assists_amount = entry.Number_Of_Jameson_Assists

			leader_board.add_child(leader_board_item)
			
			index = index + 1
		
func _on_Submit_pressed():
	if your_name.text == "":
		var window = JavaScript.get_interface("window")
		
		if window:
			var name = window.prompt("Enter your name:")
			your_name.text = name
	
	if your_name.text != "":
		submit_to_leader_board(your_name.text)
	
func _on_GetLeaderBoardRequest_request_completed(result, response_code, headers, body):
	var json_entries:Array = parse_json(body.get_string_from_utf8())
	render_leader_board(json_entries)

func _on_PostLeaderBoardRequest_request_completed(result, response_code, headers, body):
	get_leader_board()


func _on_KeepPlaying_pressed():
	resume_game()
	reset()


func _on_Left_button_down():
	Input.action_press("left")

func _on_Right_button_down():
	Input.action_press("right")

func _on_Jump_button_down():
	Input.action_press("jump")

func _on_Left_button_up():
	Input.action_release("left")
	
func _on_Right_button_up():
	Input.action_release("right")

func _on_Jump_button_up():
	Input.action_release("jump")

