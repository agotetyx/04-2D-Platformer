extends Area2D


export var score = 10

func _on_Gem_body_entered(body):
	if body.name == "Player":
		Global.increase_score(score)
		queue_free()
		#print(Global.score)
