extends Node2D





func set_stomp_type(stomp_type,slope_is_right):
	

		
	
	
	
	var new_collison =RectangleShape2D.new() 
	if stomp_type =="slope":
		$Sprite.texture = load("res://Assets/stomp_impact_effect_slope.png")
		new_collison.extents = Vector2(32,44)
		$Sprite/HitArea/CollisionShape2D.shape = new_collison
		
		
		if slope_is_right:
			$Sprite/HitArea/CollisionShape2D.rotation_degrees = -45
			$Sprite.flip_h = true
			$Sprite/HitArea/CollisionShape2D.position = Vector2(24,-24)
		else:
			$Sprite/HitArea/CollisionShape2D.rotation_degrees = 45
			$Sprite.flip_h = false
			$Sprite/HitArea/CollisionShape2D.position = Vector2(-24,-24)
			pass
	
	elif stomp_type == "noslope":
		new_collison.extents = Vector2(32,32)
		$Sprite/HitArea/CollisionShape2D.shape = new_collison
		$Sprite.texture = load("res://Assets/stomp_impact_effect.png")
		$Sprite/HitArea/CollisionShape2D.position = Vector2.ZERO
		$Sprite/HitArea/CollisionShape2D.rotation_degrees = 0
	
	
		pass



func _on_Timer_timeout():
	queue_free()
