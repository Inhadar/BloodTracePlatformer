extends Node


var bloodparticle = preload("res://Blood/BloodParticle2.tscn")

var tilewidth = 1920/64
var tileheight = 1080/64

var tile_list = []

onready var label_rect = 32

onready var startposition = $DeadSystem/StartPosition.global_position
#Camera parameters
var player_dead =false
onready var camera = $CameraSystem/Camera2D
onready var camera_tween = $CameraSystem/Tween
var splash_point = {}
var point_counts = 4
onready var all_coins_count = $CoinTile.get_used_cells().size()

var dialog_box_is_active = false

func _ready():
	if dialog_box_is_active == false:
		$player.canMove = true
	
	#print("all_coins: ", $CoinTile.get_used_cells().size())
	Globals.filledpoints.clear()
	#add blood_layers
	for i in $BloodLayers.get_children().size():
		#if i != $BloodLayers.get_children().size()-1:
		Globals.blooded_tiles[$BloodLayers.get_children()[i].name] = []
	#print(Globals.blooded_tiles)
	
	
	#####################################
	
	
	
	$player.global_position =  startposition
	camera.global_position = startposition
	
	
	for x in range(tilewidth):
		for y in range(tileheight):
			var new_label = Label.new()
			$Tileidcontainer.add_child(new_label)
			new_label.align = Label.ALIGN_CENTER
			new_label.valign= Label.VALIGN_CENTER
			new_label.rect_size = Vector2(64,64)
			new_label.rect_scale = Vector2(0.2,0.2)
			var dynamic_font = DynamicFont.new()
			dynamic_font.font_data = load("res://fonts/Lato-Regular.ttf")
			dynamic_font.size = 96
			new_label.add_font_override("font", dynamic_font)
			new_label.rect_position = Vector2((label_rect*2)*x,(label_rect*2)*y)
			new_label.text = str(x)+","+str(y)
	pass
	Checkpoint.last_position = null
	Checkpoint.previous_postion = null
func follow_player():
	if player_dead == false:
		camera_tween.interpolate_property(camera,"global_position",camera.global_position,Vector2($player.global_position.x,$player.global_position.y-50),0.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
		camera_tween.start()



func _physics_process(_delta):
	follow_player()

func player_pos_resetter(situation):
	if Checkpoint.last_position != null:
		startposition = Checkpoint.last_position
	
	#$DeadSystem/DeadPosSetter.disconnect("tween_all_completed",self,"DeadPosSetter_tween_completed")
	
	if $DeadSystem/DeadPosSetter.is_connected("tween_all_completed",self,"DeadPosSetter_tween_completed"):
		$DeadSystem/DeadPosSetter.disconnect("tween_all_completed",self,"DeadPosSetter_tween_completed")
		$DeadSystem/DeadPosSetter.connect("tween_all_completed",self,"DeadPosSetter_tween_completed",[situation])
		$DeadSystem/DeadPosSetter.interpolate_property($player,"global_position",$player.global_position,startposition,0.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
		$DeadSystem/DeadPosSetter.start()
	else:
		$DeadSystem/DeadPosSetter.connect("tween_all_completed",self,"DeadPosSetter_tween_completed",[situation])
		$DeadSystem/DeadPosSetter.interpolate_property($player,"global_position",$player.global_position,startposition,0.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
		$DeadSystem/DeadPosSetter.start()
	#player_dead = true
	#$player.hide()
	#$player.bloodsplashperm = false
	
	#$HUD.show_game_over(false)
	
	
	
func DeadPosSetter_tween_completed(situation):
	if situation == "died":
		Globals.health =Globals.max_health
		$HUD.check_heart()
		
		player_dead = true
		$player.hide()
		$player.bloodsplashperm = false
		#$DeadSystem/DeadPosSetter.interpolate_property($player,"global_position",$player.global_position,startposition,0.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
		#$DeadSystem/DeadPosSetter.start()
		$HUD.show_game_over(false)
	else:
	#player_dead = false	
		$player.bloodsplashperm = true
	#$player.show()
	
	
	#$HUD.check_heart()
	$player.damage_permission = true
	#$player/CollisionShape2D.set_deferred("disabled",false)
	#$player/HitBox/CollisionShape2D.set_deferred("disabled",false)
	$player.show()
	$player.canMove = true 




"""
func player_was_dead():
	player_dead = true
	$player.hide()
	$player.bloodsplashperm = false
	$DeadSystem/DeadPosSetter.interpolate_property($player,"global_position",$player.global_position,startposition,0.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$DeadSystem/DeadPosSetter.start()
	$HUD.show_game_over(false)
"""



func check_stars():
	pass
	#level complated
	#all coins collected
	#no death


















func _on_Reset_pressed():
	get_tree().reload_current_scene()
	Globals.extra_health = 0#Globals.max_extra_health
	Globals.max_extra_health = 0#Globals.max_extra_health
	Globals.health = Globals.max_health


func _on_BloodSplash_pressed():
	$player.produce_blood_particle(50)


func _on_DReturn_pressed():
	#player_was_dead()	\
	pass



func _on_Damage_pressed():
	$player.take_a_damage()



func _on_Show_HideTileID_toggled(button_pressed):
	$Tileidcontainer.visible = button_pressed


func _on_DeadPosSetter_tween_all_completed():
	#print("AAA")
	pass
