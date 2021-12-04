tool
extends VBoxContainer
class_name LeaderBoardStat

export var stat_label_text:String
export var stat_value_amount:int

onready var stat_label:Label = $StatLabel
onready var stat_value:Label = $StatValue

func _ready():
	stat_label.text = stat_label_text;
	stat_value.text = String(stat_value_amount);
	
func set_values(new_stat_value:int):	
	stat_value.text = String(new_stat_value)

