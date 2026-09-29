extends Node




func _on_Start_pressed():
	var _goto_game = get_tree().change_scene("res://Levels/TestLvl.tscn")


func _on_Quit_pressed():
	get_tree().quit()
