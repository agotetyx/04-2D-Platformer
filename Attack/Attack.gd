extends Area2D

var direction = 1
var velocity = Vector2.ZERO
var speed = 0.5
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = "start"
	$AnimatedSprite.playing = true

func _physics_process(delta):
	if direction < 0 and !$AnimatedSprite.flip_h:
		$AnimatedSprite.flip_h = true
	if not dead:	
		velocity.x += speed * direction
		position += velocity


func _on_Attack_body_entered(body):
	if !dead:
		if body.get_parent().name == "EnemyContainer":
			body.die()
		$AnimatedSprite.animation = "end"
		$AnimatedSprite.playing = true
		dead = true


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "start":
		$AnimatedSprite.animation = "default"
		$AnimatedSprite.playing = true
	if $AnimatedSprite.animation == "end":
		queue_free()
	$AnimatedSprite.playing = true
