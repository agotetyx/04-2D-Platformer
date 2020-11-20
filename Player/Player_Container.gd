extends Node2D

onready var Player = load("res://Player/Player.tscn")
var spawn_location = Vector2(200,200)
var previous_postiton = Vector2.ZERO
var plat_position = Vector2.ZERO


func _ready():
	pass


func _physics_process(_delta):
	var player = get_node_or_null("Player")
	if player == null:
		spawn(spawn_location)
		#player.get_node("Camera2D").current = true
	else:
		if player.is_on_moving_platform == null:
			previous_postiton = position
			plat_position = Vector2.ZERO
		elif plat_position == Vector2.ZERO:
			plat_position = player.is_on_moving_platform.position
			print(plat_position)
		else:
			position = player.is_on_moving_platform.position - plat_position
		
func spawn(p):
	position = Vector2.ZERO
	var player = Player.instance()
	player.position = p
	player.name = "Player"
	add_child(player)
