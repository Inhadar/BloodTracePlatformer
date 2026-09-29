extends Node2D

export var effect_time = 5
export(String,"unlimited_ammo","horizontal_shoot","clean_all_paints","extra_hearts","shield","feather_fall","jump_height_reducer") var object_type = "unlimited_ammo"
export var extra_heart_count = 4



func _ready():
	$Sprite.texture = load("res://Assets/SpecialItems/"+object_type+".png")
	$Timer.wait_time = effect_time



func special_effect_handler(type):
	if type == "unlimited_ammo":
		get_tree().current_scene.get_node("player").unlimited_ammo = true
	elif type == "horizontal_shoot":
		get_tree().current_scene.get_node("player").shooting_direction = "Horizontal"
	elif type == "clean_all_paints":
		var bloodlayers = get_tree().current_scene.get_node("BloodLayers")
		for layer in bloodlayers.get_children():
			for i in layer.get_used_cells():
				layer.set_cell(i.x,i.y,-1,false,false,0)
		for mini_blood in get_tree().get_nodes_in_group("mini_blood"):
			mini_blood.free()
		
		
			#print(layer.get_used_cells())
	elif type == "extra_hearts":
		Globals.max_extra_health = extra_heart_count
		Globals.extra_health = extra_heart_count
		get_tree().current_scene.get_node("HUD").set_hearts()
	elif type == "shield":
		get_tree().current_scene.get_node("player").damage_permission = false
	elif type ==  "feather_fall":
		get_tree().current_scene.get_node("player").gravity = 700
	elif type ==  "jump_height_reducer":
		get_tree().current_scene.get_node("player").jump_height = 35000
	
	if !type in ["extra_hearts","clean_all_paints"]:
		
		$CanvasLayer.show()
		$Timer.start()

		
		
		

func _process(delta):
	$CanvasLayer/ColorRect/Label.text = object_type+"\n"+"Time Left: " + str(stepify($Timer.time_left,0.01))

func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		special_effect_handler(object_type)
		hide()
		$Area2D/CollisionShape2D.set_deferred("disabled",true)



func _on_Timer_timeout():
	if object_type == "unlimited_ammo":
		get_tree().current_scene.get_node("player").unlimited_ammo = false
	elif object_type == "horizontal_shoot":
		get_tree().current_scene.get_node("player").shooting_direction = "Vertical"
	elif object_type == "clean_all_paints":
		var bloodlayers = get_tree().current_scene.get_node("BloodLayers")
		for layer in bloodlayers.get_children():
			for i in layer.get_used_cells():
				layer.set_cell(i.x,i.y,-1,false,false,0)
			#print(layer.get_used_cells())
		
		pass
	elif object_type == "extra_hearts":
		#get_tree().current_scene.get_node("HUD").extra_hearth = 0
		pass
	elif object_type == "shield":
		get_tree().current_scene.get_node("player").damage_permission = true
	elif object_type ==  "feather_fall":
		get_tree().current_scene.get_node("player").gravity = 2100
	elif object_type ==  "jump_height_reducer":
		get_tree().current_scene.get_node("player").jump_height = 50000
	queue_free()
