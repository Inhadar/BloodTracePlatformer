extends RigidBody2D

onready var tilemap = get_parent().get_node("TileMap")
onready var bloodlayers = get_parent().get_node("BloodSplashLayers").get_children()

func _ready():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var randomx = random.randi_range(-400,400)
	var randomy = random.randi_range(-400,400)
	apply_impulse( Vector2.ZERO,Vector2(randomx,randomy))


func blood():
	var addrect = 32
	var particlepos = position
	var tile_check_pos
	var check_pos_list = []
	
	tile_check_pos = position
	check_pos_list.append(Vector2(tile_check_pos.x+addrect,tile_check_pos.y))
	tile_check_pos = position
	check_pos_list.append(Vector2(tile_check_pos.x-addrect,tile_check_pos.y))
	tile_check_pos = position
	check_pos_list.append(Vector2(tile_check_pos.x,tile_check_pos.y+addrect))
	tile_check_pos = position
	check_pos_list.append(Vector2(tile_check_pos.x,tile_check_pos.y-addrect))
	
	
	
	#check tiles
	if check_pos_list.size()>=4:
		for tp in range(4):
			var curent_tile_pos = tilemap.world_to_map(check_pos_list[tp])
			
			#check to tile sides
			var side_1 = curent_tile_pos
			side_1.x +=1
			var side_2 = curent_tile_pos
			side_2.x -=1
			var side_3 = curent_tile_pos
			side_3.y +=1
			var side_4 = curent_tile_pos
			side_4.y -=1
			
			
			
			randomize()
			var random_tile = 6 #randi()%3
			
			var tile_id = tilemap.get_cellv(curent_tile_pos)
			#print(tilemap.get_cell(curent_tile_pos.x,curent_tile_pos.y))
			
			
			var blood_tile_id = null
			
			if tile_id == 4:
				blood_tile_id = bloodlayers[4].get_cellv(curent_tile_pos)
			else:
				blood_tile_id = bloodlayers[tp].get_cellv(curent_tile_pos)
				
			var tile_world_pos = tilemap.map_to_world(curent_tile_pos)
			
			
			var a =particlepos.distance_to(tile_world_pos)
			
			
			
			if tile_id != -1 and blood_tile_id != null:
				if tp in [0,2]:
						if tile_id != 4 and blood_tile_id ==-1:
								if a<=48:
									#check side2
									var side_2_id = tilemap.get_cellv(side_2)
									var side_4_id = tilemap.get_cellv(side_4)
									if tp ==0 and side_2_id !=4:
										bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,false,false,1)
									if tp ==2 and side_4_id != 4:
										bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,false,false,0)
				elif tp in [1,3]:
					if tile_id != 4 and blood_tile_id ==-1:
						if a<116:
							#check side1
							var side_1_id = tilemap.get_cellv(side_1)
							var side_3_id = tilemap.get_cellv(side_3)
							if tp ==1 and side_1_id != 4:
								bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,true,false,1)
							if tp ==3 and side_3_id != 4:
								bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,false,true,0)
#Check corners
	
	
	

func slope_blood():
	var addrect = 32
	var particlepos = position
	var tile_check_pos
	var check_pos_list = []
	
	tile_check_pos = position
	check_pos_list.append(Vector2(tile_check_pos.x+addrect,tile_check_pos.y))
	tile_check_pos = position
	check_pos_list.append(Vector2(tile_check_pos.x-addrect,tile_check_pos.y))
	tile_check_pos = position
	check_pos_list.append(Vector2(tile_check_pos.x,tile_check_pos.y+addrect))
	tile_check_pos = position
	check_pos_list.append(Vector2(tile_check_pos.x,tile_check_pos.y-addrect))
	
	#check tiles
	if check_pos_list.size()>=4:
		for tp in range(4):
			var curent_tile_pos = tilemap.world_to_map(check_pos_list[tp])
			
			randomize()
			var random_slope_tile = 7#randi()%3+3
			
			var tile_id = tilemap.get_cellv(curent_tile_pos)
			#print(tilemap.get_cell(curent_tile_pos.x,curent_tile_pos.y))
			
			
			var blood_tile_id = null
			
			if tile_id == 4:
				blood_tile_id = bloodlayers[4].get_cellv(curent_tile_pos)
			else:
				blood_tile_id = bloodlayers[tp].get_cellv(curent_tile_pos)
				
			var tile_world_pos = tilemap.map_to_world(curent_tile_pos)
			
			
			var a =particlepos.distance_to(tile_world_pos)
			
			
			
			if tile_id != -1 and blood_tile_id != null:
				if tp in [0,2]:
						if tile_id == 4 and blood_tile_id ==-1:
								if a<=48:
									var dir_1 = tilemap.is_cell_x_flipped(curent_tile_pos.x, curent_tile_pos.y)
									var dir_2 = tilemap.is_cell_y_flipped(curent_tile_pos.x, curent_tile_pos.y)
									
									
									if tp ==2:
										bloodlayers[4].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_slope_tile,dir_1,dir_2,0)
				elif tp in [1,3]:
					if tile_id == 4 and blood_tile_id ==-1:
						if a<=110:
							var dir_1 = tilemap.is_cell_x_flipped(curent_tile_pos.x, curent_tile_pos.y)
							var dir_2 = tilemap.is_cell_y_flipped(curent_tile_pos.x, curent_tile_pos.y)
									
							if tp ==3:
								bloodlayers[4].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_slope_tile,dir_1,dir_2,0)
	
	
func _on_Blood_body_entered(body):
	if body.is_in_group("Tile"):
		queue_free()
		blood()
		slope_blood()
		pass


