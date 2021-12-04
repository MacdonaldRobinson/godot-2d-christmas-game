tool
extends HBoxContainer
class_name LeaderBoardItem

onready var candies_stat:LeaderBoardStat = $VBoxContainer/VBoxContainer/Candies
onready var nude_logos_stat:LeaderBoardStat = $VBoxContainer/VBoxContainer/NudeLogos
onready var jameson_assists_stat:LeaderBoardStat = $VBoxContainer/VBoxContainer/JamesonAssists
onready var name_of_player_label:Label = $VBoxContainer/HBoxContainer/Name
onready var player_standing_label:Label = $VBoxContainer/HBoxContainer/Standing

export var candies_amount:int
export var nude_logos_amount:int
export var jameson_assists_amount:int
export var name_of_player:String
export var player_standing:int

func _ready():
	candies_stat.set_values(candies_amount)
	nude_logos_stat.set_values(nude_logos_amount)
	jameson_assists_stat.set_values(jameson_assists_amount)
	name_of_player_label.text = name_of_player
	player_standing_label.text = String(player_standing)
