extends Node2D


onready var Key = load("res://Lives/Keys.tscn") 

func spawn(attr, p):
	var key = Key.instance()
	for a in attr:
		key[a] = attr[a]
	key.position = p
	add_child(key)

