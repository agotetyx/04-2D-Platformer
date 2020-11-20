extends Node

onready var Gem = load("res://Gems/Gem.tscn") 

func spawn(attr, p):
	var gem = Gem.instance()
	for a in attr:
		gem[a] = attr[a]
	gem.position = p
	add_child(gem)
