extends KinematicBody2D

onready var animations:AnimatedSprite = $animations
onready var jameson_assest_timer:Timer = $JamesonAssistTimer

var gravity = 9.8
var velocity = Vector2.ZERO

var initial_speed = 50
var initial_jump = 500

var speed = 50
var jump = 500

func _ready():
	pass # Replace with function body.

func _process(delta):
	var animation = "idle"
	var new_velocity = velocity
	
	new_velocity.y += gravity
	
	if Input.is_action_pressed("left"):
		new_velocity.x -= speed
		animation = "walk"
		animations.flip_h = true
	elif Input.is_action_pressed("right"):
		new_velocity.x += speed	
		animation = "walk"
		animations.flip_h = false
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		new_velocity.y -= jump
		animation = "jump"		
	elif !is_on_floor() and Input.is_action_just_pressed("down"):
		new_velocity.y += jump
		animation = "jump"
		
	if !is_on_floor():
		animation = "jump"
	
	animations.play(animation)
		
	new_velocity.x = lerp(new_velocity.x, 0, 0.1)
		
	velocity = move_and_slide(new_velocity, Vector2.UP)


func _on_JamesonAssist_gift_collected(gift, collect_sound):
	if speed != initial_speed:
		return
		
	speed *= 3
	jump *= 3
	self.scale *= 2
	jameson_assest_timer.start()
	
	
func _on_JamesonAssistTimer_timeout():
	speed = initial_speed
	jump = initial_jump
	self.scale = Vector2.ONE
