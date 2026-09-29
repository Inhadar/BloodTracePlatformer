extends RigidBody2D

export(String,"sphere","rect","triangle") var object_type = "box"
export var mesh_weight : float = 100.0
export var mesh_height : float = 100.0

onready var current_mesh = $MeshInstance2D


func _ready():
	set_object_type()




func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and !event.pressed:
			selected = false








func set_object_type():
	if object_type == "sphere":
		current_mesh.mesh = SphereMesh.new()
		current_mesh.mesh.radius = mesh_weight
		current_mesh.mesh.height = mesh_height #The radius should be 2x the height.
		var new_sphere_collision= CollisionShape2D.new()
		new_sphere_collision.shape = CircleShape2D.new()
		new_sphere_collision.shape.radius = mesh_weight
		add_child(new_sphere_collision)
		pass
	elif object_type == "rect":
		current_mesh.mesh = QuadMesh.new()
		current_mesh.mesh.size.x = mesh_weight
		current_mesh.mesh.size.y = mesh_height
		var new_square_collision= CollisionShape2D.new()
		new_square_collision.shape = RectangleShape2D.new()
		new_square_collision.shape.extents = Vector2(mesh_weight/2,mesh_height/2)
		add_child(new_square_collision)
		pass
	elif object_type == "triangle":
		current_mesh.mesh = PrismMesh.new()
		current_mesh.mesh.size.x = mesh_weight
		current_mesh.mesh.size.y = mesh_height
		create_collision()
	
	

func test():
	print("AAAA")

	
	

func create_collision():
	var arrays = current_mesh.mesh.surface_get_arrays(0)
	var vertice = arrays[Mesh.ARRAY_VERTEX]
	var new_collison = CollisionPolygon2D.new()
	#var new_area_collison = CollisionPolygon2D.new()
	var points = PoolVector2Array()
	
	for i in vertice:
		#if object_type in ["box","rect"]:
		#	points.append(Vector2(i.x,i.y))
		if object_type == "triangle":
			var p = Vector2(i.x,i.y)
			if not points.has(p):
				points.append(p)
	
	print(points)
	new_collison.polygon = points
	
	#new_area_collison.polygon = points
	add_child(new_collison)
	
	#new_collison.hide()
	#$Area2D.add_child(new_area_collison)

func destroy():
	queue_free()

func _on_PhyscsObjectBase_body_entered(body):
	if body.is_in_group("bullet"):
		destroy()

var selected = false

func _physics_process(delta):
	if selected:
		global_position = lerp(global_position,get_global_mouse_position(),25*delta)




func _on_PhyscsObjectBase_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("MouseLeft"):
		selected = true
	
	






