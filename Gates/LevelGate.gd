extends Area2D

var color1 = Color(1, 1, 0)
var color2 = Color(0.552941, 0.552941, 0.552941)

export(String, "menu", "level", "room") var gate_type


func _ready():
	set_gate_type()


func set_star(stars_data):
	for i in $Stars.get_children().size():
		if stars_data[i] ==0:
			$Stars.get_children()[i].modulate = color2
		else:
			$Stars.get_children()[i].modulate = color1




func set_gate_type():
	if gate_type == "menu":
		$Stars.queue_free()
		$Sprite.frame = 1
	elif gate_type == "level":
		$Sprite.frame = 0
		pass
		#do nothing
	elif gate_type == "room":
		pass
		$Sprite.frame = 3
		#do nothing for now,but maybe you need this in future for in game rooms
