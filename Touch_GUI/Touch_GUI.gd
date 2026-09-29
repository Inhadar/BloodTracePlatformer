extends Node2D




func _on_Left_pressed():
	Input.action_press("Left")

func _on_Left_released():
	Input.action_release("Left")

func _on_Right_pressed():
	Input.action_press("Right")

func _on_Right_released():
	Input.action_release("Right")

func _on_Jump_pressed():
	Input.action_press("Jump")
func _on_Jump_released():
	Input.action_release("Jump")







func _on_Up_pressed():
	Input.action_press("Up")


func _on_Up_released():
	Input.action_release("Up")




func _on_Down_pressed():
		Input.action_press("Down")


func _on_Down_released():
	Input.action_release("Down")


func _on_shoot_pressed():
	Input.action_press("Shoot")


func _on_shoot_released():
	Input.action_release("Shoot")

func _on_crouch_pressed():
	Input.action_press("Crouch")


func _on_crouch_released():
		Input.action_release("Crouch")
