extends Node

#levels
onready var level_base = $LevelGates.get_children()
var level_poses = []
var current_level = 0

#Camera
onready var startposition = $DeadSystem/StartPosition.global_position
onready var camera = $CameraSystem/Camera2D
onready var camera_tween = $CameraSystem/Tween

#doors
var in_gate = false

var on_exit = false










func _ready():
	
	Globals.filledpoints.clear()
	#add blood_layers
	for i in $BloodLayers.get_children().size():
		#if i != $BloodLayers.get_children().size()-1:
		Globals.blooded_tiles[$BloodLayers.get_children()[i].name] = []
	#####################################
	
	
	
	
	
	
	
	Globals.load_file()
	current_level = Globals.current_level
	
	$player.global_position =  startposition
	camera.global_position = startposition
	
	Globals.level_count = level_base.size()
	for i in level_base.size():
		
		#print(i)
		
		#if i <level_base.size():
		#print("CRT: ",Globals.level_datas)
		if !i in Globals.level_datas:	
			Globals.level_datas[i] = {}
			Globals.level_datas[i]["stars"] = [0,0,0]
			level_base[i].set_star(Globals.level_datas[i]["stars"])
		else:
			#set curent_stars
			level_base[i].set_star(Globals.level_datas[i]["stars"])
				
				
				
				
			pass
				
				
		##############primal level vars################
		level_poses.append(level_base[i].global_position)##All level poses
		level_base[i].connect("body_entered",self,"Player_in_gate",[i])#All level connected
		level_base[i].connect("body_exited",self,"Player_out_gate",[i])#All level connected
		###############################################
		
		#### Level 0(Exit to main menu level) is separated from all levels################## 
		level_base[i].get_node("Label").text = "Lv" + str(i+1)
		if i in Globals.unlocked_levels:
			level_base[i].get_node("Collision").set_deferred("disabled",false)
			level_base[i].get_node("Sprite").frame = 0
		else:
			level_base[i].modulate = Color(0.5,0.5,0.5)
		if i in Globals.complated_levels:
			level_base[i].get_node("Sprite").frame = 2
		#################################################
		

	$player.global_position = level_poses[current_level] #player's position setting to current level position
	$player.global_position.y += 160
	print(Globals.level_datas)
	
func follow_player():#camera
	camera_tween.interpolate_property(camera,"global_position",camera.global_position,Vector2($player.global_position.x,$player.global_position.y-50),0.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	camera_tween.start()

func _physics_process(delta):
	follow_player()
	#print(on_exit)
	if in_gate and Input.is_action_just_pressed("Up"):
		var _goto_level = get_tree().change_scene("res://Levels/Lv"+str(current_level+1)+".tscn")
		#print("res://Levels/Lv"+str(Globals.current_level)+".tscn")
		Globals.current_level = current_level
	
	if on_exit and Input.is_action_just_pressed("Up"):
		var _goto_mainmenu = get_tree().change_scene("res://Menus/MainMenu.tscn")
	

#####################Connect#########################

func Player_in_gate(body,gate_number):
	if body.is_in_group("Player"):
		in_gate = true
		#print("Lv"+str(gate_number))
		current_level = gate_number

			
func Player_out_gate(body,gate_number):
	if body.is_in_group("Player"):
		in_gate = false


func _on_Exit_body_entered(body):
	if body.is_in_group("Player"):
		on_exit = true


func _on_Exit_body_exited(body):
	if body.is_in_group("Player"):
		on_exit = false
