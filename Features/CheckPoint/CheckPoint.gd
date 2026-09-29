extends Area2D

onready var current_level = get_tree().current_scene.name

func _process(_delta: float)-> void:
	if (global_position + Vector2(0,64)) == Checkpoint.previous_postion:
		$AnimatedSprite.play("idle")
		$CollisionShape2D.set_deferred("disabled",true)
		#eger 

func _on_CheckPoint_body_entered(body):
	if body.name == "player":
		print("A")
		var last_pos = Checkpoint.last_position
		var pre_pos = Checkpoint.previous_postion
		var pos_for_player = (global_position + Vector2(0,64))
		
		
		if Checkpoint.last_position != null and pos_for_player  != Checkpoint.last_position:
			Checkpoint.previous_postion = Checkpoint.last_position
		
		Checkpoint.last_position = pos_for_player
		if Checkpoint.last_position != Checkpoint.previous_postion:
			$AnimatedSprite.play("checked")
		
		
		
		
		####################################<---------Stars checkand save
		"""
		###check collected star
		var cs= Globals.current_level
		var cls = Globals.curren_level_set
		var current_scene = get_tree().current_scene
		var collected_star = Globals.collected_star
		var for_now_stars = Globals.for_now_collected_star
		
		if cls in Globals.collected_star:
				if current_scene.name in collected_star[cls]:
					if for_now_stars != []:
						for star in for_now_stars:
							if not star in collected_star[cls][current_scene.name]:
								collected_star[cls][current_scene.name].append(star)
				else:
					collected_star[cls][current_scene.name] = []
					if for_now_stars != []:
						for star in for_now_stars:
							if not star in collected_star[cls][current_scene.name]:
								collected_star[cls][current_scene.name].append(star)
		else:
			
			collected_star[cls] = {}
			collected_star[cls][current_scene.name] = []
			if for_now_stars != []:
				for star in for_now_stars:
					if not star in collected_star[cls][current_scene.name]:
						collected_star[cls][current_scene.name].append(star) # Globals.collected_star[Globals.curren_level_set][get_tree().current_scene.name].append("star1")
		
		#Globals.save_data()
		"""
