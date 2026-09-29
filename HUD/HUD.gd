extends CanvasLayer

onready var player = get_parent().get_node("player")

#var current_hearts = 3
#var extra_hearts = 0
func _ready():
	#ff the key is pressed, it releases it
	######################################
	Input.action_release("Right")
	Input.action_release("Left")
	Input.action_release("Jump")
	Input.action_release("Interact")
	######################################
	
	calculate_coin()
	set_hearts()
	
	
var full_health = 0
func set_hearts():
	
	full_health = Globals.max_health + Globals.max_extra_health
	for d in $HeartBox.get_children():
		d.free()
	#print(current_hearts,"/",extra_hearts)
		
	
	
	
	for i in range(full_health):
		var new_heart = TextureRect.new()
		$HeartBox.add_child(new_heart)
		new_heart.name = str(i+1)
		if i <= Globals.max_health- 1:
			new_heart.texture = load("res://Assets/heart_empty.png")
		else:
			new_heart.texture = load("res://Assets/extra_heart_empty.png")
	check_heart()


#var current_health = Globals.health + Globals.extra_health

func check_heart():
	
	print(Globals.max_health+Globals.extra_health)
	print($HeartBox.get_children())\
	
	for oh in range(full_health):
	#	#

		if oh <=Globals.max_health-1:
			$HeartBox.get_children()[oh].texture = load("res://Assets/heart_empty.png")
		
		elif oh >=Globals.max_health and oh <= (full_health)-1:
			$HeartBox.get_children()[oh].texture = load("res://Assets/extra_heart_empty.png")
	
	
	

		if oh <=Globals.health-1:
		#	print(nh)
			$HeartBox.get_children()[oh].texture = load("res://Assets/heart_red.png")
		if oh >=Globals.max_health and oh <= (Globals.max_health+Globals.extra_health)-1:
			$HeartBox.get_children()[oh].texture = load("res://Assets/extra_heart.png")
		#else:
		#	$HeartBox.get_children()[nh].free()
	

func calculate_coin():
	$CoinLabel.text = "Coin: " + str(Globals.coins)


func show_game_over(victory):
	get_tree().paused = true
	if victory:
		$GameOver.show()
		$GameOver/Buttons/Next.disabled = false
	else:
		$GameOver.show()

func _process(delta):
	$Fps.text = "FPS: " + str(Engine.get_frames_per_second())

func _on_Touch_GUI_jump_pressed():
	player.jump_system_pressed()


func _on_Touch_GUI_jump_released():
	player.jump_system_released()



func _on_PauseButton_pressed():
	get_tree().paused = true
	$PauseMenu.show()
	
func _on_Resume_pressed():
	get_tree().paused = false
	$PauseMenu.hide()

func _on_Restart_pressed():
	var _restart = get_tree().reload_current_scene()
	get_tree().paused = false
	
func _on_LevelsMenu_pressed():
	var _goto_levelmenu = get_tree().change_scene("res://Levels/MainLevel.tscn")
	get_tree().paused = false
	
func _on_Quit_pressed():
	get_tree().quit()





func _on_Next_pressed():
	if Globals.current_level < Globals.level_count:
		var _goto_nextlevel = get_tree().change_scene("res://Levels/Lv"+ str(Globals.current_level+1) +".tscn") 
		get_tree().paused = false


func _on_MainMenu_pressed():
	get_tree().paused =false
	var _goto_mainmenu = get_tree().change_scene("res://Menus/MainMenu.tscn")
