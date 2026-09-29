extends Node

var current_point = 0
var level_poses = []
var player_start_pos = Vector3.ZERO

var moving = false

func _ready():
	Globals.load_file()
	current_point = Globals.current_level
	print(Globals.unlocked_levels,Globals.complated_levels,Globals.current_level)
	Globals.level_count = $LevelBase.get_children().size()
	for i in range($LevelBase.get_children().size()):
		level_poses.append($LevelBase.get_children()[i].global_position)
		if i in Globals.unlocked_levels:
			#if i != 0:
			$LevelBase.get_children()[i].get_node("Sprite").frame =2
		else:
			$LevelBase.get_children()[i].modulate = Color(0.576471, 0.576471, 0.576471)
			
		if i in Globals.complated_levels:
			$LevelBase.get_children()[i].get_node("Sprite").frame =1
		
	$MenuPlayer.global_position = level_poses[current_point]
		
	print(level_poses)
	
var level_chosen = false


func to_next_level():
	if current_point < len($LevelBase.get_children())-1:
		if Input.is_action_just_pressed("Right"):
			if moving== false and level_chosen == false:
				$LevelChangeTween.interpolate_property($MenuPlayer,"global_position",$MenuPlayer.global_position,level_poses[current_point+1],0.2,Tween.TRANS_LINEAR,Tween.EASE_OUT)
				$LevelChangeTween.start()
				current_point +=1
				$AnimationPlayer.play("move")
				moving = true
			$MenuPlayer/Sprite3D.scale.x = 1
				
	if current_point > 0:
		if Input.is_action_just_pressed("Left"):
			if moving== false and level_chosen == false:
				$LevelChangeTween.interpolate_property($MenuPlayer,"global_position",$MenuPlayer.global_position,level_poses[current_point-1],0.2,Tween.TRANS_LINEAR,Tween.EASE_OUT)
				$LevelChangeTween.start()
				current_point -=1
				$AnimationPlayer.play("move")
				moving = true
			$MenuPlayer/Sprite3D.scale.x = -1

var tween_count = 0 #fond handle to level buton effect
func _physics_process(delta):
	to_next_level()
	if Input.is_action_just_pressed("Jump") and tween_count == 0:
		if current_point in Globals.unlocked_levels:
			#if level_unlocked
			var current_level_button = $LevelBase.get_node("Lv"+str(current_point+1)+"/Sprite")
			$LevelEffectTween.interpolate_property(current_level_button,"scale",current_level_button.scale,current_level_button.scale*1.5,0.1,Tween.TRANS_QUAD,Tween.EASE_OUT)
			$LevelEffectTween.start()
			tween_count +=1
			level_chosen = true
			$StartTimer.start()
		else:
			var current_level_button = $LevelBase.get_node("Lv"+str(current_point+1)+"/Sprite")
			var target_pos = Vector2(current_level_button.position.x+15,current_level_button.position.y)
			$LevelEffectTween.interpolate_property(current_level_button,"position",current_level_button.position,target_pos,0.1,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
			$LevelEffectTween.start()
			$StartTimer.start()
			level_chosen = true
			tween_count +=1
func _on_LevelChangeTween_tween_all_completed():
	moving = false
	$AnimationPlayer.stop()


func _on_AnimationPlayer_animation_finished(anim_name):
	pass

func _on_StartTiner_timeout():
	if current_point in Globals.unlocked_levels:
		var _change_scene = get_tree().change_scene("res://Levels/"+ $LevelBase.get_children()[current_point].name+".tscn")
		Globals.current_level = current_point
	tween_count = 0
	level_chosen = false


func _on_LevelEffectTween_tween_all_completed():
	if tween_count ==1:
		if current_point in Globals.unlocked_levels:
			
			var current_level_button = $LevelBase.get_node("Lv"+str(current_point+1)+"/Sprite")
			$LevelEffectTween.interpolate_property(current_level_button,"scale",current_level_button.scale,current_level_button.scale /1.5,0.2,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
			$LevelEffectTween.start()
			tween_count +=1
		else:
			var current_level_button = $LevelBase.get_node("Lv"+str(current_point+1)+"/Sprite")
			var target_pos = Vector2(current_level_button.position.x-15,current_level_button.position.y)
			$LevelEffectTween.interpolate_property(current_level_button,"position",current_level_button.position,target_pos,0.2,Tween.TRANS_BOUNCE,Tween.EASE_OUT)
			$LevelEffectTween.start()
			tween_count +=1


func _on_Back_pressed():
	var _change_scene = get_tree().change_scene("res://Menus/MainMenu.tscn")
