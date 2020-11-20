extends Control


#onready var global = get_node("/root/Global")

func _ready():
	update_score(0)
	update_lives(0)
	


func update_score(s):
	Global.score += s
	$Score.text = "Score:" + str(Global.score)
	
	#if Global.score >= 50:
		#pass
		#get_tree().change_scene("res://Menu/Win.tscn")

func update_lives(s):
	Global.keys += s
	$Lives.text = "Lives: " + str(Global.keys)
	if Global.keys <= 0:
		queue_free()

