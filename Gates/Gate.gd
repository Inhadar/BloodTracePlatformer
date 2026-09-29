extends Area2D


export(String,"finish","level_exit") var gate_type


func _ready():
	if gate_type == "finish":
		$MeshInstance2D.modulate = Color(0, 0.098039, 1)
		pass
	elif gate_type == "level_exit":
		#$CollisionShape2D.set_deferred("disabled",true)
		$MeshInstance2D.modulate = Color(1, 0, 0.785156)




var can_exit = false
var level_complated = false

func _on_Gate_body_entered(body):
	if body.is_in_group("Player"):
		if gate_type == "finish":
			level_complated = true
			#level complated
			var startpos = get_parent().get_node("DeadSystem/StartPosition").global_position#start pos
			get_parent().get_node("player").global_position = startpos
			get_parent().get_node("Gate2/CollisionShape2D").set_deferred("disabled",false)
				#unlock exit door
			if Globals.current_level < Globals.level_count-1:
				if !(Globals.current_level+1) in Globals.unlocked_levels:
					
					Globals.unlocked_levels.append(Globals.current_level+1)
				#get_parent().get_node("HUD").show_game_over(true)
				#get_tree().change_scene("res://Levels/MainLevel.tscn")

			
			
			###old gate system###
			#else:
				#get_parent().get_node("HUD/END").show() #show canguralation you are end of the wold
				#get_tree().paused = true# bunu deyis
			
			
			star_checker()
			if !Globals.current_level in Globals.complated_levels:
				Globals.complated_levels.append(Globals.current_level)
				if Globals.current_level < Globals.level_count-1:	
					Globals.current_level+=1
					pass
			Checkpoint.last_position = null
			Checkpoint.previous_postion = null
			Globals.save_file()
	
	
	
		elif gate_type =="level_exit":
			can_exit = true
			
			

func _process(delta):
	if can_exit:
		if Input.is_action_just_pressed("Up"):
			
			print("test")
			if level_complated == false:
				#show "Are you sure message"?
				get_tree().change_scene("res://Levels/MainLevel.tscn")
				pass
			else:
				get_tree().change_scene("res://Levels/MainLevel.tscn")
			


#chechk stars 
func star_checker():
	if 0 in Globals.level_datas[Globals.current_level]["stars"]:
		
		#var all_coins = get_parent().all_coins_count
		var current_coins = get_parent().get_node("CoinTile").get_used_cells().size()
		var current_health = Globals.health
		#+1 star for complated level
		Globals.level_datas[Globals.current_level]["stars"][0] = 1
		if current_coins ==0:
			Globals.level_datas[Globals.current_level]["stars"][1] = 1
			print("+1 star")
		if current_health == Globals.max_health:
			Globals.level_datas[Globals.current_level]["stars"][2] = 1
			print("+1 star")
		print("current_coins: ",current_coins)
		print("#################","\n","health: ",current_health)
		
		print("#################","\n","Current_level_Stars: ",Globals.level_datas)
	
	



