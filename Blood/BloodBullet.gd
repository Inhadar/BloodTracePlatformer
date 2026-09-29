extends RigidBody2D

onready var tilemap = get_parent().get_node("TileMap")
#onready var bloodlayers = get_parent().get_node("BloodSplashLayers").get_children()
onready var bloodparticle = preload("res://Blood/BloodParticle2.tscn")
var random_perm = true
var reverse_gravity = false
var projectile_count = 5



func _ready():
	$Trail.default_color = $MeshInstance2D.modulate




"""
func _ready():
	#apply_impulse( Vector2.ZERO,Vector2(-500,0))
	#if reverse_gravity:
		#gravity_scale *=-1
	pass
	if random_perm == true:
		var random = RandomNumberGenerator.new()
		random.randomize()
		var randomx = random.randi_range(-400,400)
		var randomy = random.randi_range(-400,400)
		apply_impulse( Vector2.ZERO,Vector2(randomx,randomy))
"""
func add_splash(current_position,rotation_index,curren_frame,rotation_deg):
	var new_splash = Sprite.new()
	new_splash.texture = load("res://Assets/bloodsplash.png")
	get_parent().add_child(new_splash)
	new_splash.centered = false
	new_splash.hframes = 2
	new_splash.frame = curren_frame
	new_splash.position = current_position
	
	new_splash.flip_h =rotation_index[0]
	new_splash.flip_v =rotation_index[1]
	new_splash.rotation_degrees = rotation_deg
	#new_splash.rotation_degrees = current_rotation
"""
func blood():
	var addrect = 16
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
			var tile_id = tilemap.get_cellv(curent_tile_pos)
			var tile_world_pos = tilemap.map_to_world(curent_tile_pos)
			
			#check to tile sides
			var side_1 = curent_tile_pos
			side_1.x +=1
			var side_2 = curent_tile_pos
			side_2.x -=1
			var side_3 = curent_tile_pos
			side_3.y +=1
			var side_4 = curent_tile_pos
			side_4.y -=1
			
			
			
			
			
			
			
			
			
			if tile_id != -1:
				if tp in [0,2]:
						if tile_id != 4:
								#if a<=48:
									#check side2
									var side_2_id = tilemap.get_cellv(side_2)
									var side_4_id = tilemap.get_cellv(side_4)
									
									if tp ==0 and side_2_id !=4:
										#check points which rouched tile
										var point_count =4
										var current_tile = curent_tile_pos
										var current_tile_world_pos = tile_world_pos
										var avaible_points = []
										print(curent_tile_pos)
										for j in range(point_count):
											avaible_points.append(Vector2(current_tile_world_pos.x,current_tile_world_pos.y+(j*16)))
									
										#check nearest point
										for t in range(point_count):
											var distance_point = global_position.distance_to(avaible_points[t])
											
											if distance_point <=16:
												
												if curent_tile_pos in Globals.filledpoints:
													if avaible_points[t] in Globals.filledpoints[curent_tile_pos]:
														pass
													else:
														Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
														add_splash(avaible_points[t],[false,false],0,-90)
												else:
													Globals.filledpoints[curent_tile_pos] = []
													Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
													add_splash(avaible_points[t],[false,false],0,-90)
												break
								
									if tp ==2 and side_4_id != 4:
										#check points which rouched tile
										var point_count =4
										var current_tile = curent_tile_pos
										var current_tile_world_pos = tile_world_pos
										var avaible_points = []
										
										for j in range(point_count):
											avaible_points.append(Vector2((current_tile_world_pos.x)+(j*16),(current_tile_world_pos.y)))
									
										#check nearest point
										for t in range(point_count):
											var distance_point = global_position.distance_to(avaible_points[t])
											
											if distance_point <=16:
												if curent_tile_pos in Globals.filledpoints:
													if avaible_points[t] in Globals.filledpoints[curent_tile_pos]:
														pass
													else:
														Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
														add_splash(avaible_points[t],[false,false],0,0)
												else:
													Globals.filledpoints[curent_tile_pos] = []
													Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
													add_splash(avaible_points[t],[false,false],0,0)
												break
								
				elif tp in [1,3]:
					if tile_id != 4:
						#if a<116:
							#check side1
							var side_1_id = tilemap.get_cellv(side_1)
							var side_3_id = tilemap.get_cellv(side_3)
							
							if tp ==1 and side_1_id != 4:
								#check points which rouched tile
								var point_count =4
								var current_tile = curent_tile_pos
								var current_tile_world_pos = tile_world_pos
								var avaible_points = []
								
								#if dir_1== false and dir_2 == false:
								for j in range(point_count):
									avaible_points.append(Vector2((current_tile_world_pos.x+64),(current_tile_world_pos.y)+(j*16)))
								#check nearest point
								for t in range(point_count):
									var distance_point = global_position.distance_to(avaible_points[t])
									
									if distance_point <=16:
										if curent_tile_pos in Globals.filledpoints:
											if avaible_points[t] in Globals.filledpoints[curent_tile_pos]:
												pass
											else:
												Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
												add_splash(avaible_points[t],[false,false],0,90)
										else:
											Globals.filledpoints[curent_tile_pos] = []
											Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
											add_splash(avaible_points[t],[false,false],0,90)
										break
									#bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,true,false,1)
							if tp ==3 and side_3_id != 4:
								pass
								#check points which rouched tile
								var point_count =4
								var current_tile = curent_tile_pos
								var current_tile_world_pos = tile_world_pos
								var avaible_points = []
								
								#if dir_1== false and dir_2 == false:
								for j in range(point_count):
									avaible_points.append(Vector2((current_tile_world_pos.x)+(j*16),(current_tile_world_pos.y+48)))
								#check nearest point
								for t in range(point_count):
									var distance_point = global_position.distance_to(avaible_points[t])
									print(distance_point)
									if distance_point <=16:
										if curent_tile_pos in Globals.filledpoints:
											if avaible_points[t] in Globals.filledpoints[curent_tile_pos]:
												pass
											else:
												Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
												add_splash(avaible_points[t],[false,true],0,0)
										else:
											Globals.filledpoints[curent_tile_pos] = []
											Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
											add_splash(avaible_points[t],[false,true],0,0)
										break
	
	
func slope_blood():
	var addrect = 16
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
			var tile_id = tilemap.get_cellv(curent_tile_pos)
			var tile_world_pos = tilemap.map_to_world(curent_tile_pos)
			
			if tile_id != -1:
				if tp in [0,2]:
					
						if tile_id == 4:
								#if a<=48:
									var dir_1 = tilemap.is_cell_x_flipped(curent_tile_pos.x, curent_tile_pos.y)
									var dir_2 = tilemap.is_cell_y_flipped(curent_tile_pos.x, curent_tile_pos.y)
									
									
									if tp ==2:
										pass
										#check points which rouched tile
										var point_count =4
										var current_tile = curent_tile_pos
										var current_tile_world_pos = tile_world_pos
										var avaible_points = []
										
										if dir_1== false and dir_2 == false:
											for j in range(point_count):
												avaible_points.append(Vector2(current_tile_world_pos.x+(j*16),(current_tile_world_pos.y+48)-(j*16)))
										
											#check nearest point
											for t in range(point_count):
												var distance_point = global_position.distance_to(avaible_points[t])
												
												if distance_point <=16:
													if curent_tile_pos in Globals.filledpoints:
														if avaible_points[t] in Globals.filledpoints[curent_tile_pos]:
															pass
														else:
															Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
															add_splash(avaible_points[t],[true,false],1,0)
													else:
														Globals.filledpoints[curent_tile_pos] = []
														Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
														add_splash(avaible_points[t],[true,false],1,0)
													break
										
										elif dir_1== true and dir_2 == false:
											for j in range(point_count):
												avaible_points.append(Vector2(current_tile_world_pos.x+(j*16),current_tile_world_pos.y+(j*16)))
											
											#check nearest point
											for t in range(point_count):
												var distance_point = global_position.distance_to(avaible_points[t])
												if distance_point <=16:
													if curent_tile_pos in Globals.filledpoints:
														if avaible_points[t] in Globals.filledpoints[curent_tile_pos]:
															pass
														else:
															Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
															add_splash(avaible_points[t],[false,false],1,0)
													else:
														Globals.filledpoints[curent_tile_pos] = []
														Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
														add_splash(avaible_points[t],[false,false],1,0)
														
														
													break
													
							
			
				elif tp in [1,3]:
					if tile_id == 4:
						#if a<=110:
							var dir_1 = tilemap.is_cell_x_flipped(curent_tile_pos.x, curent_tile_pos.y)
							var dir_2 = tilemap.is_cell_y_flipped(curent_tile_pos.x, curent_tile_pos.y)
									
							if tp ==3:
								pass
								#check points which rouched tile
								var point_count =4
								var current_tile = curent_tile_pos
								var current_tile_world_pos = tile_world_pos
								var avaible_points = []
								
								if dir_1== false and dir_2 == true:
									for j in range(point_count):
										avaible_points.append(Vector2(current_tile_world_pos.x+(j*16),current_tile_world_pos.y+(j*16)))
								
									#check nearest point
									for t in range(point_count):
										var distance_point = global_position.distance_to(avaible_points[t])
										print(distance_point,"///",t)
										if t == 0:
											if distance_point <=24:
											
												if curent_tile_pos in Globals.filledpoints:
													if avaible_points[t] in Globals.filledpoints[curent_tile_pos]:
														pass
													else:
														Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
														add_splash(avaible_points[t],[true,true],1,0)
												else:
													Globals.filledpoints[curent_tile_pos] = []
													Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
													add_splash(avaible_points[t],[true,true],1,0)
												break
										else:
											if distance_point <=16:
												if curent_tile_pos in Globals.filledpoints:
													if avaible_points[t] in Globals.filledpoints[curent_tile_pos]:
														pass
													else:
														Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
														add_splash(avaible_points[t],[true,true],1,0)
												else:
													Globals.filledpoints[curent_tile_pos] = []
													Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
													add_splash(avaible_points[t],[true,true],1,0)
													
												break
								
								elif dir_1== true and dir_2 == true:
									for j in range(point_count):
										avaible_points.append(Vector2(current_tile_world_pos.x+(j*16),(current_tile_world_pos.y+48)-(j*16)))
									
									#check nearest point
									for t in range(point_count):
										var distance_point = global_position.distance_to(avaible_points[t])
										print(distance_point,"///",t)
										if distance_point <=24:
											if curent_tile_pos in Globals.filledpoints:
												if avaible_points[t] in Globals.filledpoints[curent_tile_pos]:
													pass
												else:
													Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
													add_splash(avaible_points[t],[false,true],1,0)
											else:
												Globals.filledpoints[curent_tile_pos] = []
												Globals.filledpoints[curent_tile_pos].append(avaible_points[t])
												add_splash(avaible_points[t],[false,true],1,0)
											
											break
								
"""






func produce_blood_particle(count):
	for _i in range(count):
		var newblood = bloodparticle.instance()
		newblood.get_node("MeshInstance2D").modulate = $MeshInstance2D.modulate
		get_parent().call_deferred("add_child", newblood)
		newblood.global_position = global_position




func spawn_blood_particle(dir):
	var new_blood = bloodparticle.instance()
	new_blood.random_perm = false
	new_blood.reverse_gravity = dir
	get_parent().add_child(new_blood)
	new_blood.global_position = get_global_mouse_position()





func _on_Blood_body_entered(body):
	if body.is_in_group("Tile") or body.is_in_group("bodies"):
		queue_free()
		#blood()
		#slope_blood()
		produce_blood_particle(projectile_count)
		pass


