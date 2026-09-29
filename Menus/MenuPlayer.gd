extends KinematicBody


var speed = 150
var velocity = Vector3.ZERO

var h_direction = 0
var v_direction = 0

func get_direction():
	h_direction = Input.get_action_strength("Right") -Input.get_action_strength("Left")
	v_direction = Input.get_action_strength("Down") -Input.get_action_strength("Up")
	
func _physics_process(delta):
	get_direction()
	velocity.z = v_direction * speed * delta
	velocity.x = h_direction * speed * delta
		
	velocity = move_and_slide(velocity,Vector3.UP)

