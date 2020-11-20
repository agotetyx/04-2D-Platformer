extends Node2D

onready var Enemy_Ground = load("res://Enemies/Enemy Ground.tscn")
onready var Enemy_Bat = load("res://Enemies/Bat.tscn")
onready var Enemy_Bird = load("res://Enemies/Bird.tscn")

func _ready():
	#spawn("Enemy_Ground", {"max_constraint":1200, "min_constraint": 900},Vector2(400, 215))
	pass


func spawn(e_type, attr, p):
	var enemy = null
	if e_type == "Enemy_Ground":
		enemy = Enemy_Ground.instance()
	if e_type == "Enemy_Bat":
		enemy = Enemy_Bat.instance()
	if e_type == "Enemy_Bird":
		enemy = Enemy_Bird.instance()
	for a in attr:
		enemy[a] = attr [a]
	enemy.position = p
	add_child(enemy)
