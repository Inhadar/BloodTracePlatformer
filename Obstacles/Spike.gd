extends Area2D

var dyed = false


func painted(type):
	if dyed ==false:
		dyed = true
	if type == "blood":
		$Sprite.frame = 2
	if type == "player":
		$Sprite.frame = 1
	
	


func _on_Spike_body_entered(body):
	if body.is_in_group("blood"):
		if dyed == false:
			$Sprite.frame = 2
			dyed = true


func _on_Spike_area_entered(area):
	if area.is_in_group("player"):
		if dyed == false:
			$Sprite.frame = 1
			dyed = true
		#if get_parent().get_parent().player_dead == false:
		#	get_parent().get_parent().get_node("player").damagehit()
		
