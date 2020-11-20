extends Area2D

export var key = 1

func _on_Keys_body_entered(body):
	if body.name == "Player":
		Global.increase_keys(key)
		self.queue_free()
		#print(Global.keys)


