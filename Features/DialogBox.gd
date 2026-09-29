extends Node2D

export var dialogs = [
	"text1",
	"text2",
	"text3"
]

onready var text_label = $ColorRect/RichTextLabel
onready var text_tween = $Tween
var dialogue_index = 0
var finished = false



func _ready():
	get_tree().current_scene.get_node("player").canMove = false
	get_tree().current_scene.dialog_box_is_active = true
	get_tree().current_scene.get_node("HUD/Touch_GUI").hide()
	
	
	load_digalue()
	
func _process(delta):
	if Input.is_action_just_pressed("MouseLeft"):
		load_digalue()



func load_digalue():
	if dialogue_index < dialogs.size():
		text_label.bbcode_text = dialogs[dialogue_index]
		text_label.percent_visible = 0.5
		text_tween.interpolate_property(text_label,"percent_visible",0,1,0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		text_tween.start()
	else:
		queue_free()
		get_tree().current_scene.get_node("player").canMove = true
		get_tree().current_scene.dialog_box_is_active = false
		get_tree().current_scene.get_node("HUD/Touch_GUI").show()
	
	
	dialogue_index +=1
		


func _on_Tween_tween_all_completed():
	finished = true
	print("finished")
