

#const IDLE_DURATION = 1.0

#export var move_to = Vector2.RIGHT * 192
#export var speed = 3.0

#onready var platform = $MovePlatform
#onready var tween = $Movetween

#func _init_tween():
	#var duration = move_to.length() / float(speed)
	#tween.interpolate_properety(self,"position",Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	#tween.interpolate_properety(self,"position",move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION)
	#tween.start()
	#pass


extends KinematicBody2D

var locations = [ position, Vector2(1144, 404), Vector2(1115,10)]
var pos = 0
var duration = 3.0


func _ready():
	$Timer.start()
	#_init_tween()
	


func _on_Movetween_tween_completed(object, key):
	pos = wrapf(pos+1, 0, locations.size())
	$Timer.start()


func _on_Timer_timeout():
	$Tween.interpolate_property(self,"position",locations[pos], locations[wrapf(pos+1, 0, locations.size())], duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()
	#$Timer.start
	
func _physics_process(delta):
	#print(global_position)
	pass
