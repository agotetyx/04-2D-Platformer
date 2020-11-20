
extends KinematicBody2D

var player = null
onready var ray = $RayCast2D
export var speed = 250
export var looking_speed = 100
	
onready var Explosion = load("res://Explosions/Explosion2.tscn")		

func _physics_process(_delta):
	if player == null:
		player = get_node("/root/Game/Player_Container/Player")
	else:
		ray.cast_to = ray.to_local(player.global_position)
		var c = ray.get_collider()
		if c:
			var velocity = ray.cast_to.normalized()*looking_speed
			if c.name == "Player":
				velocity = ray.cast_to.normalized()*speed
			move_and_slide(velocity, Vector2(0,0))

func die():
	var explosion = Explosion.instance()
	explosion.position = position
	get_node("/root/Game/Explosions").add_child(explosion)
	queue_free()



func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.die()
			
			#body.queue_free()
	#print(body.name)
