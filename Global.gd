extends Node

var fade = null
var fade_speed = 0.015

var fade_in = false
var fade_out = ""

var death_zone = 1000

var level = 1
var keys = 3
var score = 0
onready var HUD = get_node("/root/Game/UI/HUD")

var saves = [
	"user://game-data_0.json"
]

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		var menu = get_node_or_null("/root/Game/UI/Menu")
		if menu != null:
			var p = get_tree().paused
			if p:
				menu.hide()
				get_tree().paused = false
			else:
				menu.show()
				get_tree().paused = true 
	

func _physics_process(_delta):
	if fade == null:
		fade = get_node_or_null("/root/Game/Camera/Fade")
	if fade_out != "":
		execute_fade_out(fade_out)
	if fade_in:
		execute_fade_in()
	
	
func get_save_data():
	var data = {
		"score": score
		,"key": keys
		,"level": level
		,"Player": ""
		,"enemy_ground": []
		,"enemy_bird": []
		,"enemy_bat": []
		,"gems": []
		,"keys": []
	}	
	
	var player = get_node_or_null("/root/Game/Player_Container/Player")
	if player != null:
		data["player"] = var2str(player.position)
	var enemies = get_node("/root/Game/EnemyContainer").get_children()
	for e in enemies:
		
		if e.is_in_group("Enemy_Ground"):
			var temp = {"position": var2str(e.position), "max_constraint": e.max_constraint, "min_constraint": e.min_constraint}
			data["enemy_ground"].append(temp)
		
		if e.is_in_group("Enemy_Bat"):
			var temp = {"position": var2str(e.position)}
			data["enemy_bat"].append(temp)
		
		if e.is_in_group("Enemy_Bird"):
			var temp = {"position": var2str(e.position)}
			data["enemy_bird"].append(temp)
	
	
	var gems = get_node("/root/Game/Gems_Container").get_children()
	for g in gems:
		var temp = {"position": var2str(g.position), "score": g.score}
		data["gems"].append(temp)
		
	var keys = get_node("/root/Game/Lives_Container").get_children()
	for k in keys:
		var temp = {"position": var2str(k.position), "key": k.key}
		data["keys"].append(temp)
	
	
	#print(data)
	return data
	
func load_save_data(data):
	#print(data)
	score = data["score"]
	keys = data["key"]
	level = data["level"]
	#score = data["score"]
	##
	if data["player"] != "" :
		var player = get_node_or_null("/root/Game/Player_Container/Player")
		if player != null:
			player.name = "bc"
			player.queue_free()
		get_node("/root/Game/Player_Container").spawn(str2var(data["player"]))
	
	var enemy_container = get_node("/root/Game/EnemyContainer")
	
	for e in enemy_container.get_children():
		e.queue_free()
	for e in data["enemy_ground"]:
		var attr = {"max_constraint": e["max_constraint"], "min_constraint": e["min_constraint"]}
		enemy_container.spawn("Enemy_Ground", attr, str2var(e["position"]))
	for e in data["enemy_bat"]:
		var attr = {}
		enemy_container.spawn("Enemy_Bat", attr, str2var(e["position"]))	
	for e in data["enemy_bird"]:
		var attr = {}
		enemy_container.spawn("Enemy_Bird", attr, str2var(e["position"]))	
	
	var gem_container = get_node("/root/Game/Gems_Container")
	for g in gem_container.get_children():
		g.queue_free()
	for g in data["gems"]:
		var attr = {"score": g["score"]}
		gem_container.spawn(attr, str2var(g["position"]))
		
	var key_container = get_node("/root/Game/Lives_Container")
	for k in key_container.get_children():
		k.queue_free()
	for k in data["keys"]:
		var attr = {"key": k["key"]}
		key_container.spawn(attr, str2var(k["position"]))
	
	

func save_game(which_file):
	var file = File.new()
	var data = {}
	data = get_save_data()
	file.open(saves[which_file], File.WRITE)
	file.store_string(to_json(data))
	file.close()
	
func load_game(which_file):
	var file = File.new()
	if file.file_exists(saves[which_file]):
		file.open(saves[which_file], File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			load_save_data(data)
		else:
			printerr("corrupted data")
		
	else:
		printerr("save data does not exist")

func start_fade_in():
	if fade != null:
		fade.visible = true
		fade.color.a = 1
		fade_in = true

func start_fade_out(target):
	if fade != null:
		fade.color.a = 0
		fade.visible = true
		fade_out = target

func execute_fade_in():
	if fade != null:
		fade.color.a -= fade_speed
		if fade.color.a <= 0:
			fade_in = false

func execute_fade_out(target):
	if fade != null:
		fade.color.a += fade_speed
		if fade.color.a >= 1:
			fade_out = ""
			

#func _unhandled_input(event):
	#if event.is_action_pressed("quit"):
		#get_tree().quit()
	

func increase_score(s):
	#score += s
	#HUD.update_score(s)
	pass
	
func increase_keys(k):
	
	HUD.update_lives(k)
