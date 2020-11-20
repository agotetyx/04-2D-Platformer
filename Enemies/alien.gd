
extends KinematicBody2D

var player = null
var damage = 10
var speed = 2
var velocity =  Vector2.ZERO
var direction = 1

export var max_constraint = 100
export var min_constraint = -100


onready var Explosion = load("res://Explosions/Explosion.tscn")
	
func _physics_process(_delta):
	if direction < 0 and !$AlienSprite.flip_h:
		$AlienSprite.flip_h = true
	if direction > 0 and $AlienSprite.flip_h:
		$AlienSprite.flip_h = false
	if direction > 0 and position.x >= max_constraint:
		velocity.x = 0
		direction  = -1
	if direction < 0 and position.x <= min_constraint:
		velocity.x = 0
		direction  = 1
	
	velocity.x += direction * speed
	move_and_slide_with_snap(velocity, Vector2.UP)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
	#	print(collision.collider.name)
		
	
	#if player == null:
	#	player = get_node("/root/Game/Player_Container/Player")
	#else:
	#	ray.cast_to = ray.to_local(player.global_position)
		#var c = ray.get_collider()
	#	if c:
	#		var velocity = ray.cast_to.normalized()*looking_speed
	#		if c.name == "Player":
		#		velocity = ray.cast_to.normalized()*speed
		#	move_and_slide(velocity, Vector2(0,0))


func _on_Area2D_body_entered(body):
	if body.name == "Platform" or body.name == "Ground":
			velocity.x = 0
			direction *= -1
	if body.name == "Player":
			body.die()
			
func die():
	var explosion = Explosion.instance()
	explosion.position = position
	get_node("/root/Game/Explosions").add_child(explosion)
	queue_free()

