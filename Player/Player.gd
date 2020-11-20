extends KinematicBody2D

onready var SM = $StateMachine
onready var VP = get_viewport_rect()

var velocity = Vector2.ZERO
var jump_power = Vector2.ZERO
var direction = 1

export var gravity = Vector2(0,30)

export var move_speed = 20
export var max_move = 300

export var jump_speed = 100
export var max_jump = 1000

export var leap_speed = 100
export var max_leap = 1000

var moving = false
var is_jumping = false
var is_on_moving_platform = null
var moving_platform_offset = 0

var container_position = Vector2.ZERO


onready var Attack = load("res://Attack/Attack.tscn")


func _ready():
	pass


func _physics_process(_delta):
	velocity.x = clamp(velocity.x,-max_move,max_move)
	
	if direction < 0 and not $AnimatedSprite.flip_h: $AnimatedSprite.flip_h = true
	if direction > 0 and $AnimatedSprite.flip_h: $AnimatedSprite.flip_h = false
	
	if position.y > Global.death_zone:
		queue_free()
	
	if Input.is_action_just_pressed("attack"):
		var attack = Attack.instance()
		attack.position = global_position 
		attack.position.x += 10 * direction
		attack.direction = direction
		get_node("/root/Game/Attack_Container").add_child(attack)
	
	if is_on_moving_platform != null:
		self.get_parent().position = container_position + (is_on_moving_platform.global_position - moving_platform_offset)

func is_moving():
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		return true
	return false

func move_vector():
	return Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),1.0)

func _unhandled_input(event):
	if event.is_action_pressed("left"):
		direction = -1
	if event.is_action_pressed("right"):
		direction = 1

func set_animation(anim):
	if $AnimatedSprite.animation == anim: return
	if $AnimatedSprite.frames.has_animation(anim): $AnimatedSprite.play(anim)
	else: $AnimatedSprite.play()

func die():
	Global.keys -= 1
	Global.score = 0
	
	queue_free()

func do_damage(d):
	queue_free()
	
#func is_on_floor():
	#is_on_moving_platform = null
	#var fl = $Floor.get_children()
	#for f in fl:
	#	if f.is_colliding():
		#	var c = f.get_collider()
		#	if c.get_parent().name == "Platform_Container":
			#	is_on_moving_platform = c
	#return false
	
func is_on_right_wall():
	if $Wall/Right.is_colliding():
		return true
	return false


func is_on_left_wall():
	if $Wall/Left.is_colliding():
		return true
	return false


func _on_Area2D_body_entered(body):
	if body.get_parent().name == "Platform_Container":
		is_on_moving_platform = body
		moving_platform_offset = body.global_position
		container_position = get_parent().position


func _on_Area2D_body_exited(body):
	if body.get_parent().name == "Platform_Container":
		is_on_moving_platform = null
