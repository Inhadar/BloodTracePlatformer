extends KinematicBody2D


onready var bullet = preload("res://Blood/BloodBullet.tscn")#<---- for test


#Physcs object variables
export(int,0,200) var inertia = 100



#MOVE-----------------------------------
#move parameters
const ACCELERATION = 3000
const MAX_SPEED = 18000
const MAX_CROUCH_SPEED = 9000
const LIMIT_SPEED_Y = 1200

#move permission
var canMove = true
var moving = false

#JUMP-----------------------------------
#jump parameters
var jump_height = 50000
const MIN_JUMP_HEIGHT = 12000
const MAX_COYOTE_TIME = 6
const JUMP_BUFFER_TIME = 10
#jump value
var coyoteTimer = 0
var jumpBufferTimer = 0
var useable_extra_jump = 1
#jump permissions
var canJump = false
var friction = false
var jumping = false

#crouch parameters
var crouching =false



#GRAVITY-------------------------------
#gravity parameters
var gravity = 2100
#jump permissions
var gravity_permission = true


#OTHER--------------------------------
#position
var velocity = Vector2()

#efects

#BLOOD-------------------------------
var bloodsplashperm = true

onready var tilemap = get_parent().get_node("TileMap")

onready var bloodlayers = get_parent().get_node("BloodLayers").get_children()

#BloodParticles
var bloodparticle = preload("res://Blood/BloodParticle2.tscn")

#--------------------------------------------------------------------------------
#DAMAGE
var taken_damage = 1
var damage_permission = true

#COIN
onready var cointile = null

var snap_vector = Vector2(0, 16)  # Karakterin eğime yapışması için

func _ready():
	randomize()
	if get_tree().current_scene.name != "MainLevel":
		cointile = get_parent().get_node("CoinTile")
		#get_parent().get_node("HUD/Touch_GUI/Interact").hide()
	

func coin_target_calculator():
	var player_pos = position
	var curent_tile_pos = cointile.world_to_map(player_pos)
	var coin_id = cointile.get_cellv(curent_tile_pos)
	if coin_id !=-1:
		cointile.tile_collected(curent_tile_pos.x,curent_tile_pos.y)


func blood():
	var addrect = 32
	var player_pos = position
	var tile_check_pos
	var check_pos_list = []
	var check_cros_to_slope_pos_list = []
	var active_blood_tiles = [0,0,0,0]
	var active_slope_blood_tiles = [0,0,0,0]
	
	
	tile_check_pos = position#right 0
	check_pos_list.append(Vector2(tile_check_pos.x+addrect,tile_check_pos.y))
	tile_check_pos = position#left 1
	check_pos_list.append(Vector2(tile_check_pos.x-addrect,tile_check_pos.y))
	tile_check_pos = position#down 2
	check_pos_list.append(Vector2(tile_check_pos.x,tile_check_pos.y+addrect))
	tile_check_pos = position#up 3
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
			
			
			var random_tile = randi()%3
			var random_corner = 6#randi()%1+8
			
			var tile_id = tilemap.get_cellv(curent_tile_pos)

			
			
			var blood_tile_id = null
			blood_tile_id = bloodlayers[tp].get_cellv(curent_tile_pos)
			
			var tile_world_pos = tilemap.map_to_world(curent_tile_pos)
			
			
			var a =player_pos.distance_to(tile_world_pos)
			#print(a)
			
			
			if tile_id != -1 and blood_tile_id != null:
				
				if tile_id != 4 and blood_tile_id ==-1:

					if tp in [0,2]:
									if a<=64:
										#check side2
										var side_2_id = tilemap.get_cellv(side_2)
										var side_4_id = tilemap.get_cellv(side_4)
										if tp ==0 and side_2_id !=4:
											check_connect_tiles(curent_tile_pos,"noslope","Right")
											bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,false,false,1)
											Globals.blooded_tiles["Left"].append(curent_tile_pos)
										if tp ==2 and side_4_id != 4:
											check_connect_tiles(curent_tile_pos,"noslope","Up")
											bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,false,false,0)
											Globals.blooded_tiles["Up"].append(curent_tile_pos)
					elif tp in [1,3]:
							if a<128:
								#check side1
								var side_1_id = tilemap.get_cellv(side_1)
								var side_3_id = tilemap.get_cellv(side_3)
								if tp ==1 and side_1_id != 4:
									check_connect_tiles(curent_tile_pos,"noslope","Left")
									bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,true,false,1)
									Globals.blooded_tiles["Right"].append(curent_tile_pos)
								if tp ==3 and side_3_id != 4:
									check_connect_tiles(curent_tile_pos,"noslope","Down")
									bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,false,true,0)
									Globals.blooded_tiles["Down"].append(curent_tile_pos)
									
			
func slope_blood():
	var addrect = 32
	var player_pos = position
	var tile_check_pos
	var check_pos_list = []
	var active_blood_tiles = [0,0,0,0]
	
	tile_check_pos = position#right 0
	check_pos_list.append(Vector2(tile_check_pos.x+addrect,tile_check_pos.y))
	tile_check_pos = position#left 1
	check_pos_list.append(Vector2(tile_check_pos.x-addrect,tile_check_pos.y))
	tile_check_pos = position#down 2
	check_pos_list.append(Vector2(tile_check_pos.x,tile_check_pos.y+addrect))
	tile_check_pos = position#up 3
	check_pos_list.append(Vector2(tile_check_pos.x,tile_check_pos.y-addrect))
	
	
	#check tiles
	if check_pos_list.size()>=4:
		for tp in range(4):
			var curent_tile_pos = tilemap.world_to_map(check_pos_list[tp])
			
			
			var random_slope_tile = randi()%3+3
			var random_corner = 6#randi()%1+8
			
			var tile_id = tilemap.get_cellv(curent_tile_pos)
			
			
			var blood_tile_id = null
			blood_tile_id = bloodlayers[tp].get_cellv(curent_tile_pos)

			var tile_world_pos = tilemap.map_to_world(curent_tile_pos)
			var a =player_pos.distance_to(tile_world_pos)
			
			
			
			if tile_id != -1 and blood_tile_id != null:
				var dir_1 = tilemap.is_cell_x_flipped(curent_tile_pos.x, curent_tile_pos.y)
				var dir_2 = tilemap.is_cell_y_flipped(curent_tile_pos.x, curent_tile_pos.y)
				
				if tile_id == 4 and blood_tile_id ==-1:
					check_connect_tiles(curent_tile_pos,"slope",Vector2(dir_1,dir_2))
					if tp in [0,2]:
								if a<=64:
									if tp ==2:
										bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_slope_tile,dir_1,dir_2,0)
										Globals.blooded_tiles["Slope"].append(curent_tile_pos)
					elif tp in [1,3]:
							if a<=128:
								if tp ==3:
									bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_slope_tile,dir_1,dir_2,0)
									Globals.blooded_tiles["Slope"].append(curent_tile_pos)
	

	
func check_connect_tiles(pos,tile_type,tile_dir):
	if tile_type == "slope":
		#target tile poses
		var up_left = Vector2(pos.x-1,pos.y-1) #Up Left
		var up_right = Vector2(pos.x+1,pos.y-1) #Up Right
		var down_left = Vector2(pos.x-1,pos.y+1) #Down Left
		var down_right = Vector2(pos.x+1,pos.y+1) #Down Right
		
		var tile_current_direction = null
		
		if tile_dir.x == 0 and tile_dir.y == 0:
			tile_current_direction = "DownLeft"
		elif tile_dir.x == 1 and tile_dir.y == 0:
			tile_current_direction = "DownRight"
		elif tile_dir.x == 0 and tile_dir.y == 1:
			tile_current_direction = "UpLeft"
		elif tile_dir.x == 1 and tile_dir.y == 1:
			tile_current_direction = "UpRight"
		
		
		#check tile for connection
		var connect_left_tile = Vector2(pos.x-1,pos.y) #Left
		var connect_right_tile = Vector2(pos.x+1,pos.y) #Right
		var connect_down_tile = Vector2(pos.x,pos.y+1) #Down
		var connect_up_tile = Vector2(pos.x,pos.y-1) #Up
		
		#print(tile_current_direction)
	
		#1 __ 
		if tile_current_direction == "DownLeft":
			#first connect
			if up_right in Globals.blooded_tiles["Left"]  or up_right in Globals.blooded_tiles["Slope"]:#Left directional blood splash
				if  !connect_right_tile in Globals.blooded_tiles["ConnectSlope"]:
					var tile_id = tilemap.get_cellv(connect_right_tile)#check connect tile exsist or not
					if tile_id != -1:# if tile is null or slope dont connect 
						Globals.blooded_tiles["ConnectSlope"].append(connect_right_tile)#if tile available for connection add to "Connect" list
						bloodlayers[4].set_cell(connect_right_tile.x,connect_right_tile.y,6,tile_dir.x,tile_dir.y,0)
				pass
			#second connect
			if down_left in Globals.blooded_tiles["Up"]  or down_left in Globals.blooded_tiles["Slope"]:#Up directional blood splash
				if  !connect_down_tile in Globals.blooded_tiles["ConnectSlope"]:
					var tile_id = tilemap.get_cellv(connect_down_tile)
					if tile_id != -1:
						Globals.blooded_tiles["ConnectSlope"].append(connect_down_tile)
						bloodlayers[4].set_cell(connect_down_tile.x,connect_down_tile.y,6,tile_dir.x,tile_dir.y,0)
				pass
		#2 __ 
		elif tile_current_direction == "DownRight":
			#first connect
			if up_left in Globals.blooded_tiles["Right"]  or up_left in Globals.blooded_tiles["Slope"]:#Right directional blood splash
				if  !connect_left_tile in Globals.blooded_tiles["ConnectSlope"]:
					var tile_id = tilemap.get_cellv(connect_left_tile)
					if tile_id != -1:
						Globals.blooded_tiles["ConnectSlope"].append(connect_left_tile)
						bloodlayers[4].set_cell(connect_left_tile.x,connect_left_tile.y,6,tile_dir.x,tile_dir.y,0)
					pass
				pass
			#second connect
			if down_right in Globals.blooded_tiles["Up"]  or down_right in Globals.blooded_tiles["Slope"]:#Up directional blood splash
				if  !connect_down_tile in Globals.blooded_tiles["ConnectSlope"]:
					var tile_id = tilemap.get_cellv(connect_down_tile)
					if tile_id != -1:
						Globals.blooded_tiles["ConnectSlope"].append(connect_down_tile)
						bloodlayers[4].set_cell(connect_down_tile.x,connect_down_tile.y,6,tile_dir.x,tile_dir.y,0)
					pass
				pass
		#3 __ 
		elif tile_current_direction == "UpLeft":
			#first connect
			if up_left in Globals.blooded_tiles["Down"]  or up_left in Globals.blooded_tiles["Slope"]:#Down directional blood splash
				if  !connect_up_tile in Globals.blooded_tiles["ConnectSlope"]:
					var tile_id = tilemap.get_cellv(connect_up_tile)
					if tile_id != -1:
						Globals.blooded_tiles["ConnectSlope"].append(connect_up_tile)
						bloodlayers[4].set_cell(connect_up_tile.x,connect_up_tile.y,6,tile_dir.x,tile_dir.y,0)
					pass
				pass
			#second connect
			if down_right in Globals.blooded_tiles["Left"]  or down_right in Globals.blooded_tiles["Slope"]:#Left directional blood splash
				if  !connect_right_tile in Globals.blooded_tiles["ConnectSlope"]:
					var tile_id = tilemap.get_cellv(connect_right_tile)
					if tile_id != -1:
						Globals.blooded_tiles["ConnectSlope"].append(connect_right_tile)
						bloodlayers[4].set_cell(connect_right_tile.x,connect_right_tile.y,6,tile_dir.x,tile_dir.y,0)
					pass
				pass
		#4 __ 
		elif tile_current_direction == "UpRight":
			#first connect
			if up_right in Globals.blooded_tiles["Down"]  or up_right in Globals.blooded_tiles["Slope"]:#Right directional blood splash
				if  !connect_up_tile in Globals.blooded_tiles["ConnectSlope"]:
					var tile_id = tilemap.get_cellv(connect_up_tile)
					if tile_id != -1:
						Globals.blooded_tiles["ConnectSlope"].append(connect_up_tile)
						bloodlayers[4].set_cell(connect_up_tile.x,connect_up_tile.y,6,tile_dir.x,tile_dir.y,0)
					pass
				pass
			#second connect
			if down_left in Globals.blooded_tiles["Right"]  or down_left in Globals.blooded_tiles["Slope"]:#Down directional blood splash
				if  !connect_left_tile in Globals.blooded_tiles["ConnectSlope"]:
					var tile_id = tilemap.get_cellv(connect_left_tile)
					if tile_id != -1:
						Globals.blooded_tiles["ConnectSlope"].append(connect_left_tile)
						bloodlayers[4].set_cell(connect_left_tile.x,connect_left_tile.y,6,tile_dir.x,tile_dir.y,0)
					pass
	
	
	
	else:#Nearly close to complated....
		#target tile poses
		var up_left = Vector2(pos.x-1,pos.y-1) #Up Left 
		var up_right = Vector2(pos.x+1,pos.y-1) #Up Right 
		var down_left = Vector2(pos.x-1,pos.y+1) #Down Left 
		var down_right = Vector2(pos.x+1,pos.y+1) #Down Right 
		
		
		#check tile for connection
		var connect_left_tile = Vector2(pos.x-1,pos.y) #Left
		var connect_right_tile = Vector2(pos.x+1,pos.y) #Right
		var connect_down_tile = Vector2(pos.x,pos.y+1) #Down
		var connect_up_tile = Vector2(pos.x,pos.y-1) #Up
		
		
		if tile_dir == "Right":
			if up_left in Globals.blooded_tiles["Down"] or up_left in Globals.blooded_tiles["Slope"]:
				var tile_id = tilemap.get_cellv(up_left)
				if tile_id != 4:
					if !connect_up_tile in Globals.blooded_tiles["ConnectTile1"]:
						var connect_tile_id = tilemap.get_cellv(connect_up_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectTile1"].append(connect_up_tile)
							bloodlayers[6].set_cell(connect_up_tile.x,connect_up_tile.y,6,false,true,0)
							
				else:
					if !connect_up_tile in Globals.blooded_tiles["ConnectSlope"]:
						var connect_tile_id = tilemap.get_cellv(connect_up_tile)
						if connect_tile_id != -1 and connect_tile_id != 4:
							Globals.blooded_tiles["ConnectSlope"].append(connect_up_tile)
							bloodlayers[4].set_cell(connect_up_tile.x,connect_up_tile.y,6,false,true,0)
			
	
	
			if down_left in Globals.blooded_tiles["Up"] or down_left in Globals.blooded_tiles["Slope"]:
				var tile_id = tilemap.get_cellv(down_left)
				if tile_id != 4:
					if !connect_down_tile in Globals.blooded_tiles["ConnectTile1"]:
						var connect_tile_id = tilemap.get_cellv(connect_down_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectTile1"].append(connect_down_tile)
							bloodlayers[6].set_cell(connect_down_tile.x,connect_down_tile.y,6,false,false,0)
							
				else:
					if !connect_down_tile in Globals.blooded_tiles["ConnectSlope"]:
						var connect_tile_id = tilemap.get_cellv(connect_down_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectSlope"].append(connect_down_tile)
							bloodlayers[4].set_cell(connect_down_tile.x,connect_down_tile.y,6,false,false,0)
			#print(Globals.blooded_tiles["Right"])
	
		if tile_dir == "Left":
			if up_right in Globals.blooded_tiles["Down"] or up_right in Globals.blooded_tiles["Slope"]:
				var tile_id = tilemap.get_cellv(up_right)
				if tile_id != 4:
					if !connect_up_tile in Globals.blooded_tiles["ConnectTile2"]:
						var connect_tile_id = tilemap.get_cellv(connect_up_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectTile2"].append(connect_up_tile)
							bloodlayers[7].set_cell(connect_up_tile.x,connect_up_tile.y,6,true,true,0)
							
				else:
					if !connect_up_tile in Globals.blooded_tiles["ConnectSlope"]:
						var connect_tile_id = tilemap.get_cellv(connect_up_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectSlope"].append(connect_up_tile)
							bloodlayers[4].set_cell(connect_up_tile.x,connect_up_tile.y,6,true,true,0)
			
			
			
			
			if down_right in Globals.blooded_tiles["Up"] or down_right in Globals.blooded_tiles["Slope"] :
				var tile_id = tilemap.get_cellv(down_right)
				if tile_id != 4:
					if !connect_down_tile in Globals.blooded_tiles["ConnectTile2"]:
						var connect_tile_id = tilemap.get_cellv(connect_down_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectTile2"].append(connect_down_tile)
							bloodlayers[7].set_cell(connect_down_tile.x,connect_down_tile.y,6,true,false,0)
							
				else:
					if !connect_down_tile in Globals.blooded_tiles["ConnectSlope"]:
						var connect_tile_id = tilemap.get_cellv(connect_down_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectSlope"].append(connect_down_tile)
							bloodlayers[4].set_cell(connect_down_tile.x,connect_down_tile.y,6,true,false,0)
		
		if tile_dir == "Down" :
			if down_left in Globals.blooded_tiles["Right"] or down_left in Globals.blooded_tiles["Slope"]:
				var tile_id = tilemap.get_cellv(down_left)
				if tile_id != 4:
					if !connect_left_tile in Globals.blooded_tiles["ConnectTile3"]:
						var connect_tile_id = tilemap.get_cellv(connect_left_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectTile3"].append(connect_left_tile)
							bloodlayers[8].set_cell(connect_left_tile.x,connect_left_tile.y,6,true,true,0)
							
				else:
					if !connect_left_tile in Globals.blooded_tiles["ConnectSlope"]:
						var connect_tile_id = tilemap.get_cellv(connect_left_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectSlope"].append(connect_left_tile)
							bloodlayers[4].set_cell(connect_left_tile.x,connect_left_tile.y,6,true,true,0)
		
					
					
			if down_right in Globals.blooded_tiles["Left"] or down_right in Globals.blooded_tiles["Slope"]:
				var tile_id = tilemap.get_cellv(down_right)
				if tile_id != 4:
					if !connect_right_tile in Globals.blooded_tiles["ConnectTile3"]:
						var connect_tile_id = tilemap.get_cellv(connect_right_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectTile3"].append(connect_right_tile)
							bloodlayers[8].set_cell(connect_right_tile.x,connect_right_tile.y,6,false,true,0)
							
				else:
					if !connect_right_tile in Globals.blooded_tiles["ConnectSlope"]:
						var connect_tile_id = tilemap.get_cellv(connect_right_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectSlope"].append(connect_right_tile)
							bloodlayers[4].set_cell(connect_right_tile.x,connect_right_tile.y,6,false,true,0)
		
		if tile_dir == "Up":
			if up_left in Globals.blooded_tiles["Right"] or up_left in Globals.blooded_tiles["Slope"]:
				var tile_id = tilemap.get_cellv(up_left)
				if tile_id != 4:
					if !connect_left_tile in Globals.blooded_tiles["ConnectTile4"]:
						var connect_tile_id = tilemap.get_cellv(connect_left_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectTile4"].append(connect_left_tile)
							bloodlayers[9].set_cell(connect_left_tile.x,connect_left_tile.y,6,true,false,0)
							
				else:
					if !connect_left_tile in Globals.blooded_tiles["ConnectSlope"]:
						var connect_tile_id = tilemap.get_cellv(connect_left_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectSlope"].append(connect_left_tile)
							bloodlayers[4].set_cell(connect_left_tile.x,connect_left_tile.y,6,true,false,0)
		
					
			if up_right in Globals.blooded_tiles["Left"] or up_right in Globals.blooded_tiles["Slope"]:
				var tile_id = tilemap.get_cellv(up_right)
				if tile_id != 4:
					if !connect_right_tile in Globals.blooded_tiles["ConnectTile4"]:
						var connect_tile_id = tilemap.get_cellv(connect_right_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectTile4"].append(connect_right_tile)
							bloodlayers[9].set_cell(connect_right_tile.x,connect_right_tile.y,6,false,false,0)
							
				else:
					if !connect_right_tile in Globals.blooded_tiles["ConnectSlope"]:
						var connect_tile_id = tilemap.get_cellv(connect_right_tile)
						if connect_tile_id != -1:
							Globals.blooded_tiles["ConnectSlope"].append(connect_right_tile)
							bloodlayers[4].set_cell(connect_right_tile.x,connect_right_tile.y,6,false,false,0)
	
	
		
func ground_checker():
	var check_datas = [false,false,false]
	
	for i in $GroundChecker.get_children().size():
		if $GroundChecker.get_children()[i].is_colliding():
			check_datas[i] = true
		else:
			check_datas[i] = false
	
	return check_datas





var slope_checker = false
var barie_value = 200 # for rotation bug




func set_sprite_to_ground():

	var sprite = $Rotatable/Sprite
	var player_pos = position
	var pos = Vector2(position.x,position.y+32)
	var curent_tile_pos = tilemap.world_to_map(pos)
	var under_id = tilemap.get_cellv(curent_tile_pos)
	var dir_1 = tilemap.is_cell_x_flipped(curent_tile_pos.x, curent_tile_pos.y)
	var dir_2 = tilemap.is_cell_y_flipped(curent_tile_pos.x, curent_tile_pos.y)
	

	if under_id == 4 and ground_checker() == [true,true,true]:
		
		slope_checker = true
	else:
		if ground_checker() == [true,true,true]:
			if under_id != 4 and under_id != -1:
				slope_checker = false
		else:
			slope_checker = false
	
	var input_value = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	if slope_checker:
		if crouching:
			$Rotatable/Sprite.position.y = 12#<-Crouch offset for Sprite on slope tiles
		else:
			$Rotatable/Sprite.position.y = 0#<- Stand offset for Sprite on slope tiles
	else:
		if crouching:
			$Rotatable/Sprite.position.y = 12 #<-Crouch offset for Sprite on normal tiles
		else:
			$Rotatable/Sprite.position.y = 0 #<- Stand offset for Sprite on normal tiles
			####################################^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^######################
			########################### Why did I add these here instead of in the crouch function? ########
		"""
		-If I did that, I would have to redo all the calculations. 
		While this wouldn't significantly affect optimization, it could impair code readability.
		
		-Note: Furthermore, in Crouch mechanics, 
		changing parameters with animation yields much better results.
		However, for this I need to write an animation_handler.
		
		-If I have time, I'll write it for you free of charge and improve the code.
		"""
		
	"""
	if slope_checker:
		if input_value != 0:
			if !$Rotatable/RayCast2D.is_colliding():
				if crouching:
					$Rotatable/Sprite.position.y = 24#<-Crouch offset for Sprite on slope tiles
				else:
					$Rotatable/Sprite.position.y = 0#<- Stand offset for Sprite on slope tiles
				
				
			#if dir_1 and dir_2==false:
			#	sprite.rotation =45*(PI/180) * ($Rotatable.scale.x* sign(velocity.x))
					
			#elif dir_1==false and dir_2==false:
			#	sprite.rotation =-45*(PI/180) * $Rotatable.scale.x* sign(velocity.x)
				
				
				#if velocity.y > 200 and input_value == sign(velocity.x):
				#	sprite.rotation =45*(PI/180)
				#elif velocity.y < 0 and input_value == sign(velocity.x):
				#	sprite.rotation =-45*(PI/180)
				
		else:
			if crouching:
				$Rotatable/Sprite.position.y = 24#<-Crouch offset for Sprite on slope tiles
			else:
				$Rotatable/Sprite.position.y = 0#<- Stand offset for Sprite on slope tiles
			
			
			#if dir_1 and dir_2==false:
			#	sprite.rotation =-45*(PI/180) * $Rotatable.scale.x
			#			
			#elif dir_1==false and dir_2==false:
			#	sprite.rotation =45*(PI/180) * $Rotatable.scale.x
			
			
			if velocity.y > 0:
				print(velocity.x)
				if velocity.x > 0:
					if $Rotatable.scale.x == sign(velocity.x):
						if sprite.rotation_degrees != -45:
							sprite.rotation =45*(PI/180)
					else:
						sprite.rotation =-45*(PI/180)
				elif velocity.x < 0:
					
					if $Rotatable.scale.x == sign(velocity.x):
						if sprite.rotation_degrees != -45:
							sprite.rotation =45*(PI/180)
					else:
						sprite.rotation =45*(PI/180)
				
				else:
					if $Rotatable.scale.x == sign(velocity.x):
						if sprite.rotation_degrees != 45:
							sprite.rotation =-45*(PI/180)
					else:
						sprite.rotation =45*(PI/180)
						
						
			elif velocity.y < 0:
				if abs(velocity.x) > 0:
					if $Rotatable.scale.x == sign(velocity.x):
						sprite.rotation =-45*(PI/180)
					else:
						if sprite.rotation_degrees != -45:
							sprite.rotation =45*(PI/180)
		
		
		
		
		
		
		
		
	else:
		if crouching:
			$Rotatable/Sprite.position.y = 12 #<-Crouch offset for Sprite on normal tiles
		else:
			$Rotatable/Sprite.position.y = 0 #<- Stand offset for Sprite on normal tiles
			####################################^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^######################
			########################### Why did I add these here instead of in the crouch function? ########
			
			#-If I did that, I would have to redo all the calculations. 
			#While this wouldn't significantly affect optimization, it could impair code readability.
			
			-Note: Furthermore, in Crouch mechanics, 
			changing parameters with animation yields much better results.
			However, for this I need to write an animation_handler.
			
			-If I have time, I'll write it for you free of charge and improve the code.
			
		"""
		
		
		#sprite.rotation = 0
	#print("TEST VELOCITY: ", velocity)



func crouch():
	if Input.is_action_just_pressed("Crouch"):
		crouching = !crouching
	if crouching:
		pass
		$CollisionShape2D.shape.extents = Vector2(20,10)
		$CollisionShape2D.position.y =16
		$HitBox/CollisionShape2D.shape.extents = Vector2(32,16)
		$HitBox/CollisionShape2D.position.y =10
		$Rotatable/Sprite.scale.y = 0.45

	else:
		pass
		$CollisionShape2D.shape.extents = Vector2(20,20)
		$CollisionShape2D.position.y =0
		$HitBox/CollisionShape2D.shape.extents = Vector2(32,32)
		$HitBox/CollisionShape2D.position.y =0
		$Rotatable/Sprite.scale.y = 0.9



var shooting_sension = false
var shooting_direction = "Vertical"
var unlimited_ammo = false

func spawn_bullet(charge_factor):
	if Globals.coins >0 or unlimited_ammo:
		var new_bullet = bullet.instance()
		get_parent().add_child(new_bullet)
		
		#x is speed y is angle for curvy move
		var impulse_factor = Vector2(clamp(charge_factor*1500,300,1500),clamp(charge_factor*500,50,500))
		
		var new_bullet_direction  = Vector2.ZERO
	
		if shooting_direction == "Vertical":
			new_bullet_direction.x = impulse_factor.x * sign($Rotatable.scale.x)
			new_bullet_direction.y = -impulse_factor.y
			new_bullet.global_position = $Rotatable/ShootBase/VerticalNozzle.global_position
		elif shooting_direction == "Horizontal":
			new_bullet_direction.x = 0#impulse_factor.y 
			new_bullet_direction.y = -impulse_factor.x * sign($Rotatable.scale.x)
			new_bullet.global_position = $Rotatable/ShootBase/HorizontalNozzle.global_position
			
			
		#print(new_bullet_direction)
		new_bullet.apply_impulse(Vector2.ZERO,new_bullet_direction)
		var size = clamp(charge_factor*20,10,20)
		new_bullet.get_node("CollisionShape2D").shape.radius = size
		new_bullet.get_node("MeshInstance2D").scale = Vector2(size,size)
		new_bullet.projectile_count = round(clamp(charge_factor*30,3,30))
		if !unlimited_ammo:
			Globals.coins -= 1
			get_tree().current_scene.get_node("HUD").calculate_coin()
		


func shoot():
	if Input.is_action_just_pressed("Shoot"):
		#start_charge
		shooting_sension = true
		$Rotatable/ShootBase/ChargeTween.interpolate_property($Rotatable/ShootBase/ProgressBar,"value",0,100,1,Tween.TRANS_LINEAR,Tween.EASE_OUT)
		$Rotatable/ShootBase/ChargeTween.start()
		$Rotatable/ShootBase/ChargeTimer.start()
		pass
	elif Input.is_action_just_released("Shoot"):
		spawn_bullet(abs($Rotatable/ShootBase/ChargeTimer.time_left-$Rotatable/ShootBase/ChargeTimer.wait_time))
		$Rotatable/ShootBase/ChargeTween.stop_all()
		$Rotatable/ShootBase/ProgressBar.value = 0
		shooting_sension = false
		
	#if $Rotatable/ShootBase/ChargeTimer.time_left == 0 and shooting_sension:
	#	pass
	#	print("FULL CHARGE")
		#shooting_sension = false
##############################################################################






var stomping = false
export var stomp_power = 3
func stomp():
	if Input.is_action_pressed("Down"):
		if Input.is_action_just_pressed("Jump") and ground_checker() !=[true,true,true] :
			velocity.y += 1500
			stomping = true	
	
	if stomping:
		if ground_checker() == [true,true,true]:
			#print("on ground")
			#calculate blood impact
			stomp_blood_impact(Vector2.DOWN)
			stomping =false
			canMove =false
			#stomp_cooldown
			$StompCooldown.start()
			
	
	

func _on_StompCooldown_timeout():
	canMove = true

onready var stomp_effect  = preload("res://Effects/StompEffect.tscn")

func stomp_blood_impact(direction):
	var addrect = 64
	var player_pos = position
	var impact_area = {"left":[],"right":[]}
	
	
	var tile_check_pos

	
	#-we are starting from down tile
	tile_check_pos = position#down 2
	#-It allows us to select the direction of the impact. You can do this with "velocity",
	#-but I preferred to use it manually for better testing.
	var impact_core = Vector2(tile_check_pos.x,tile_check_pos.y+addrect)
	
	#check impact_core
	var under_tile = tilemap.get_cellv(tilemap.world_to_map(impact_core))
	
	
	var under_tile_is_slope = false
	
	var core_index = tilemap.world_to_map(impact_core)
	var last_tile_datas_r = []
	var last_tile_datas_l = []
	#What is breaking the stomp?
	
	
	if under_tile ==1:#normal
		under_tile_is_slope = false
		last_tile_datas_r = [ core_index,"noslope"]
		last_tile_datas_l = [ core_index,"noslope"]
		impact_area["right"].append([core_index,"noslope"])
	elif under_tile== 4:#slope
		under_tile_is_slope = true
		last_tile_datas_r = [ core_index,"slope"]
		last_tile_datas_l = [ core_index,"slope"]
		impact_area["right"].append([core_index,"slope"])
		
			
			
	var impact_tile_datas = []#tile ids

	#if under_tile_is_slope:
	#	pass
	#else:
		
		
	if last_tile_datas_l != [] and last_tile_datas_r != []:
		for i in stomp_power:
			#check right specific direction
			var current_slope_index_R = last_tile_datas_r[0]
			var current_slope_ID_R = tilemap.get_cellv(current_slope_index_R)
			var cross_UP_R = tilemap.get_cellv(Vector2(current_slope_index_R.x+1,current_slope_index_R.y-1))
			var cross_DOWN_R = tilemap.get_cellv(Vector2(current_slope_index_R.x+1,current_slope_index_R.y+1))
			var right_tile = tilemap.get_cellv(Vector2(current_slope_index_R.x+1,current_slope_index_R.y))
			
			#check left spesific direction
			var current_slope_index_L = last_tile_datas_l[0]
			var current_slope_ID_L = tilemap.get_cellv(current_slope_index_L)
			var cross_UP_L = tilemap.get_cellv(Vector2(current_slope_index_L.x-1,current_slope_index_L.y-1))
			var cross_DOWN_L = tilemap.get_cellv(Vector2(current_slope_index_L.x-1,current_slope_index_L.y+1))
			var left_tile = tilemap.get_cellv(Vector2(current_slope_index_L.x-1,current_slope_index_L.y))
			
			
			
			#RIGHT CALCULATOR
			#Make decision by looking at the last tile
			if last_tile_datas_r[1] == "slope":
				#check slope direction
				var dir_1 = tilemap.is_cell_x_flipped(last_tile_datas_r[0].x, last_tile_datas_r[0].y)#check slope direction horizontal
				var dir_2 = tilemap.is_cell_y_flipped(last_tile_datas_r[0].x, last_tile_datas_r[0].y)#check slope direction vertical
				
				#RIGHT CALCUCULATOR
				if !dir_1 and !dir_2:
					#rigt up slope
					if cross_UP_R !=-1:
						if cross_UP_R == 4:
							last_tile_datas_r = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y-1),"slope"]
							var current_tile_data = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y-1),"slope"]
							if !current_tile_data in impact_area["right"]:
								impact_area["right"].append(current_tile_data)
						else:
							last_tile_datas_r = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y),"noslope"]
							var current_tile_data = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y),"noslope"]
							if !current_tile_data in impact_area["right"]:
								impact_area["right"].append(current_tile_data)
							break
					else:
						if !right_tile in [4,-1]:
							last_tile_datas_r = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y),"noslope"]

							var current_tile_data = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y),"noslope"]
							if !current_tile_data in impact_area["right"]:
								impact_area["right"].append(current_tile_data)
								
				elif dir_1 and !dir_2:
					#rigt down slope
					if cross_DOWN_R != -1:
						if cross_DOWN_R == 4:
							last_tile_datas_r = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y+1),"slope"]
							var current_tile_data = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y+1),"slope"]
							if !current_tile_data in impact_area["right"]:
								impact_area["right"].append(current_tile_data)
							
						else:
							if right_tile ==-1:
								last_tile_datas_r = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y+1),"noslope"]
								var current_tile_data = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y+1),"noslope"]
								if !current_tile_data in impact_area["right"]:
									impact_area["right"].append(current_tile_data)
			if last_tile_datas_r[1] == "noslope":
				if current_slope_ID_R != -1:
					if cross_UP_R ==-1:
						if right_tile !=-1:
							if right_tile in [4]:
								last_tile_datas_r = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y),"slope"]
								var current_tile_data = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y),"slope"]
								if !current_tile_data in impact_area["right"]:
									impact_area["right"].append(current_tile_data)
							else:
								last_tile_datas_r = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y),"noslope"]
								var current_tile_data = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y),"noslope"]
								if !current_tile_data in impact_area["right"]:
									impact_area["right"].append(current_tile_data)
									
									
									
					elif cross_UP_R ==4:
						#check slope direction
						var dir_1 = tilemap.is_cell_x_flipped(current_slope_index_R.x+1,current_slope_index_R.y-1)#check slope direction horizontal
						var dir_2 = tilemap.is_cell_y_flipped(current_slope_index_R.x+1,current_slope_index_R.y-1)#check slope direction vertical
						
						
						
						#if Slopes face is reverse stomp attack doesn't work.
						if !dir_1 and !dir_2 :
							last_tile_datas_r = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y-1),"slope"]
							var current_tile_data = [Vector2(current_slope_index_R.x+1,current_slope_index_R.y-1),"slope"]
							if !current_tile_data in impact_area["right"]:
								impact_area["right"].append(current_tile_data)
							
							
							#If there is a slope adjacent to the first calculated slope, it calculates that slope as well.
							##This only happens with the last tile noslopes
							if tilemap.get_cellv(Vector2(current_slope_index_R.x+2,current_slope_index_R.y-1)) in [4]:
								last_tile_datas_r = [Vector2(current_slope_index_R.x+2,current_slope_index_R.y-1),"slope"]
								current_tile_data = [Vector2(current_slope_index_R.x+2,current_slope_index_R.y-1),"slope"]
								if !current_tile_data in impact_area["right"]:
									impact_area["right"].append(current_tile_data)
					
			#LEFT CALCULATOR
			#Make decision by looking at the last tile
			if last_tile_datas_l[1] == "slope":
				#check slope direction
				var dir_1 = tilemap.is_cell_x_flipped(last_tile_datas_l[0].x, last_tile_datas_l[0].y)#check slope direction horizontal
				var dir_2 = tilemap.is_cell_y_flipped(last_tile_datas_l[0].x, last_tile_datas_l[0].y)#check slope direction vertical
				
				#RIGHT CALCUCULATOR
				if dir_1 and !dir_2:
					#rigt up slope
					if cross_UP_L !=-1:
						if cross_UP_L == 4:
							last_tile_datas_l = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y-1),"slope"]
							var current_tile_data = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y-1),"slope"]
							if !current_tile_data in impact_area["left"]:
								impact_area["left"].append(current_tile_data)
						else:
							last_tile_datas_l = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y),"noslope"]
							var current_tile_data = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y),"noslope"]
							if !current_tile_data in impact_area["left"]:
								impact_area["left"].append(current_tile_data)
							break
					else:
						if !left_tile in [4,-1]:
							last_tile_datas_l = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y),"noslope"]

							var current_tile_data = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y),"noslope"]
							if !current_tile_data in impact_area["left"]:
								impact_area["left"].append(current_tile_data)
								
				elif !dir_1 and !dir_2:
					#rigt down slope
					if cross_DOWN_L != -1:
						if cross_DOWN_L == 4:
							last_tile_datas_l = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y+1),"slope"]
							var current_tile_data = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y+1),"slope"]
							if !current_tile_data in impact_area["left"]:
								impact_area["left"].append(current_tile_data)
							
						else:
							if left_tile ==-1:
								last_tile_datas_l = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y+1),"noslope"]
								var current_tile_data = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y+1),"noslope"]
								if !current_tile_data in impact_area["left"]:
									impact_area["left"].append(current_tile_data)
			
			
			if last_tile_datas_l[1] == "noslope":
				if current_slope_ID_L != -1:
					if cross_UP_L ==-1:
						if left_tile !=-1:
							if left_tile in [4]:
								last_tile_datas_l = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y),"slope"]
								var current_tile_data = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y),"slope"]
								if !current_tile_data in impact_area["left"]:
									impact_area["left"].append(current_tile_data)
							else:
								last_tile_datas_l = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y),"noslope"]
								var current_tile_data = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y),"noslope"]
								if !current_tile_data in impact_area["left"]:
									impact_area["left"].append(current_tile_data)
									
									
									
					elif cross_UP_L ==4:
						#check slope direction
						var dir_1 = tilemap.is_cell_x_flipped(current_slope_index_L.x-1,current_slope_index_L.y-1)#check slope direction horizontal
						var dir_2 = tilemap.is_cell_y_flipped(current_slope_index_L.x-1,current_slope_index_L.y-1)#check slope direction vertical
						
						
						#if Slopes face is reverse stomp attack doesn't work.
						if dir_1 and !dir_2 :
							last_tile_datas_l = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y-1),"slope"]
							var current_tile_data = [Vector2(current_slope_index_L.x-1,current_slope_index_L.y-1),"slope"]
							if !current_tile_data in impact_area["left"]:
								impact_area["left"].append(current_tile_data)
							
							
							#If there is a slope adjacent to the first calculated slope, it calculates that slope as well.
							##This only happens with the last tile noslopes
							if tilemap.get_cellv(Vector2(current_slope_index_L.x-2,current_slope_index_L.y-1)) in [4]:
								last_tile_datas_l = [Vector2(current_slope_index_L.x-2,current_slope_index_L.y-1),"slope"]
								current_tile_data = [Vector2(current_slope_index_L.x-2,current_slope_index_L.y-1),"slope"]
								if !current_tile_data in impact_area["left"]:
									impact_area["left"].append(current_tile_data)

		for t in impact_area:
			for t_data in impact_area[t]:
				impact_tile_datas.append([t_data[0],t_data[1]])

		for sd_data in impact_tile_datas:
				var side_4 = sd_data[0]
				side_4.y -=1
				var tile_id = tilemap.get_cellv(sd_data[0])
				#check up_tile
				var uptile = tilemap.get_cellv(Vector2(sd_data[0].x,sd_data[0].y-1))
				
				
				var blood_tile_id = null
				blood_tile_id = bloodlayers[2].get_cellv(sd_data[0])
				
				var tile_world_pos = tilemap.map_to_world(sd_data[0])
				
				
				var player_tile_distance =player_pos.distance_to(tile_world_pos)
				#print(a)
				
				var random_tile = randi()%3
				var random_slope_tile = randi()%3+3
				#var random_corner = 6#randi()%1+8
				if sd_data[1] == "noslope":
					if uptile ==-1:
						if tile_id != -1 and blood_tile_id != null:
							####add_effect
							var new_effect = stomp_effect.instance()
							get_tree().current_scene.add_child(new_effect)
							new_effect.global_position = tilemap.map_to_world(Vector2(sd_data[0].x,sd_data[0].y-1))
							new_effect.set_stomp_type(sd_data[1],0)
							new_effect.global_position.y+= addrect/2
							new_effect.global_position.x+= addrect/2
							
							if blood_tile_id ==-1:
								#if player_tile_distance<128:
								#check side2
								var side_4_id = tilemap.get_cellv(side_4)
								if side_4_id != 4:
									if side_4_id != 4:
										check_connect_tiles(sd_data[0],sd_data[1],"Up")
										bloodlayers[2].set_cell(sd_data[0].x,sd_data[0].y,random_tile,false,false,0)
										Globals.blooded_tiles["Up"].append(sd_data[0])
								
										
					
				else:
					if tile_id != -1 and blood_tile_id != null:
						
						var dir_1 = tilemap.is_cell_x_flipped(sd_data[0].x, sd_data[0].y)
						var dir_2 = tilemap.is_cell_y_flipped(sd_data[0].x, sd_data[0].y)
						check_connect_tiles(sd_data[0],"slope",Vector2(dir_1,dir_2))
						
						
						var new_effect = stomp_effect.instance()
						get_tree().current_scene.add_child(new_effect)
						new_effect.global_position = tilemap.map_to_world(Vector2(sd_data[0].x,sd_data[0].y))
						
						#new_effect.centered = true
						

						
						if !dir_1 and !dir_2:
							new_effect.set_stomp_type(sd_data[1],dir_1)
							#new_effect.rotation_degrees = -45
							new_effect.global_position.y+= addrect/2
							new_effect.global_position.x+= addrect/2
							pass

						elif dir_1 and !dir_2:
							new_effect.set_stomp_type(sd_data[1],dir_1)
							#new_effect.rotation_degrees = 45
							new_effect.global_position.y+= addrect/2
							new_effect.global_position.x+= addrect/2
							pass
						
						
						#if tile_id != 4:
						####add_effect
						#var new_effect = stomp_effect.instance()
						#get_tree().current_scene.add_child(new_effect)
						#new_effect.global_position = tilemap.map_to_world(Vector2(sd_data[0].x,sd_data[0].y-1))
						if blood_tile_id ==-1:
							#if player_tile_distance<128:
							#check side2
							#var side_4_id = tilemap.get_cellv(side_4)
						#	if side_4_id != 4:
								#if side_4_id != 4:
								#	check_connect_tiles(sd_data[0],sd_data[1],"Up")
								#	bloodlayers[2].set_cell(sd_data[0].x,sd_data[0].y,random_tile,false,false,0)
								#	Globals.blooded_tiles["Up"].append(sd_data[0])
							bloodlayers[2].set_cell(sd_data[0].x,sd_data[0].y,random_slope_tile,dir_1,dir_2,0)
							Globals.blooded_tiles["Slope"].append(sd_data[0])

					

				
										
				#slope deyene qeder davam ele biten tilein üstü slope olana qeder
				#eger slopdusa geriye qalan power qeder directiona uyqun olacak sekil 
				#slopun (x+,y+) ve x+ sini buluyoruz
				#eger slopun  (x+,y+)si normal tilesa slope orda bitir
				  
		#print(impact_tile_datas)


func _physics_process(delta):
	#just for cheking tile splash
	#print(Globals.blooded_tiles)

	set_sprite_to_ground()
	"""
	pass
	if Input.is_action_just_pressed("Mouse"):
		spawn_blood_particle(false)
	elif Input.is_action_just_pressed("Mouse2"):
		spawn_blood_particle(true)
	"""
	
	if canMove:
		#new mechanics
		shoot()
		crouch()
		stomp()
		#print("CROUCHING: ",crouching)
		#####################################
		if !is_on_floor():
			velocity.y += gravity * delta
			
			
		if bloodsplashperm and get_tree().current_scene.name != "MainLevel":
			coin_target_calculator()
		blood()
		slope_blood()
		horizontalMovement(delta)
		
		if crouching == false:
			if !canJump:
				if velocity.y >= 0:
					$AnimationPlayer.play( "Fall")
					$StateMachine.text = "Fall"
				elif velocity.y < 0:
					$AnimationPlayer.play( "Jump")
					$StateMachine.text = "Jump"

			#jumping mechanics and coyote time
			if is_on_floor():
				useable_extra_jump =1
				canJump = true
				coyoteTimer = 0
			else:
				coyoteTimer += 1
				if coyoteTimer > MAX_COYOTE_TIME:
					canJump = false
					coyoteTimer = 0
						
				friction = true
				
			
			jumpBuffer(delta)

			if Input.is_action_just_pressed("Jump"):
				if canJump:
					jump(delta)
					frictionOnAir()
				else:
					if useable_extra_jump > 0:
						canJump = true
						useable_extra_jump -=1
						jump(delta)
				
			setJumpHeight(delta)
			jumpBuffer(delta)
	
		velocity = move_and_slide(velocity,Vector2.UP,false,4,PI/4,false)
	#else:
	#	velocity = Vector2.ZERO
	
	
	#Slope angle
	#var ray = $GroundChecker/RayCast2D2
	var current_target_rotation = 0.0
	
	
	
	
	#check under tile
	#var curent_tile_pos = tilemap.world_to_map( Vector2(position.x,position.y+32))
	#var under_id = tilemap.get_cellv(curent_tile_pos)
	
	#print(
	#	"a: ",$GroundChecker.get_children()[0].get_collision_normal(),
	#	"b: ",$GroundChecker.get_children()[1].get_collision_normal(),
	#	"c: ",$GroundChecker.get_children()[2].get_collision_normal()
	#)
	
	
	
	var all_value= Vector2.ZERO
	for t in $GroundChecker.get_children():
		all_value += t.get_collision_normal()
	print("all_value: ", all_value)
	
	if abs(all_value.x) > 1.4 and abs(all_value.y)>2:#slope
		current_target_rotation = all_value.angle() + PI/2
		rotation = lerp_angle(rotation, current_target_rotation, 0.2)
	else:
		current_target_rotation = 0.0
		rotation = lerp_angle(rotation, 0, 0.1)
	
	#Old slope angle rotator
	"""
	for ray_index in ground_checker().size():
		if ground_checker()[ray_index] == true:
		
			var n =  $GroundChecker.get_children()[ray_index].get_collision_normal()
		#	print("NNN:",n)
			# Slope
			if abs(n.x) > 0.4:
				slope_value +=1 
				#current_target_rotation = n.angle() + PI/2
			# floor
			elif abs(n.x) < 0.1:
				slope_value -=1
				
				#current_target_rotation = 0.0
			
			#rotation = lerp_angle(rotation, current_target_rotation, 0.1)
		else:
		#	rotation = lerp_angle(rotation, 0, 0.1)
			#continue
			pass
		#####
	#print(slope_value)
	if slope_value >=2:
		var n =  $GroundChecker.get_children()[1].get_collision_normal()
		current_target_rotation = n.angle() + PI/2
		rotation = lerp_angle(rotation, current_target_rotation, 0.2)
		#print("on_slope")
		pass
	else:
		#print("on_floor")
		current_target_rotation = 0.0
		rotation = lerp_angle(rotation, 0, 0.1)
		pass
	"""
	
	#physics integration
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * inertia)
	
	


func check_jump_and_move():
	if velocity.x != 0:
		moving = true
	else:
		moving = false
	if velocity.y < 0 and !is_on_floor():
		jumping = true
	else:
		 jumping = false
		
func jump(delta):
	velocity.y = -jump_height * delta
	

func frictionOnAir():
	if friction:
		velocity.x = lerp(velocity.x, 0, 0.01)

func jumpBuffer(delta):
	if jumpBufferTimer > 0:
		if is_on_floor():
			jump(delta)
		jumpBufferTimer -= 1

func setJumpHeight(delta):
	if Input.is_action_just_released("Jump"):
		if velocity.y < -MIN_JUMP_HEIGHT * delta:
			velocity.y = -MIN_JUMP_HEIGHT * delta















func horizontalMovement(delta):
	if Input.is_action_pressed("Right"):
		if $Rotatable/RayCast2D.is_colliding():
			yield(get_tree().create_timer(0.1),"timeout")
			if crouching:
				velocity.x = min(velocity.x + ACCELERATION * delta, MAX_CROUCH_SPEED * delta)
			else:
				velocity.x = min(velocity.x + ACCELERATION * delta, MAX_SPEED * delta)
			$Rotatable.scale.x = 1
			if canJump:
				$AnimationPlayer.play("Run")
				$StateMachine.text = "Run"
		else:
			if crouching:
				velocity.x = min(velocity.x + ACCELERATION * delta, MAX_CROUCH_SPEED * delta)
			else:
				velocity.x = min(velocity.x + ACCELERATION * delta, MAX_SPEED * delta)
			$Rotatable.scale.x = 1
			if canJump:
				$AnimationPlayer.play("Run")
				$StateMachine.text = "Run"

	elif Input.is_action_pressed("Left"):
		if $Rotatable/RayCast2D.is_colliding():
			yield(get_tree().create_timer(0.1),"timeout")
			if crouching:
				velocity.x = max(velocity.x - ACCELERATION * delta, -MAX_CROUCH_SPEED * delta)
			else:
				velocity.x = max(velocity.x - ACCELERATION * delta, -MAX_SPEED * delta)
			$Rotatable.scale.x = -1
			if canJump:
				$AnimationPlayer.play("Run")
				$StateMachine.text = "Run"
		else:
			if crouching:
				velocity.x = max(velocity.x - ACCELERATION * delta, -MAX_CROUCH_SPEED * delta)
			else:
				velocity.x = max(velocity.x - ACCELERATION * delta, -MAX_SPEED * delta)
			$Rotatable.scale.x = -1
			if canJump:
				$AnimationPlayer.play("Run")
				$StateMachine.text = "Run"
	else:
		velocity.x = lerp(velocity.x, 0, 0.4)
		if canJump:
			$AnimationPlayer.play("Idle")
			$StateMachine.text = "Idle"


func produce_blood_particle(count):
	for _i in range(count):
		var newblood = bloodparticle.instance()
		get_parent().call_deferred("add_child", newblood)
		newblood.global_position = global_position




func spawn_blood_particle(dir):
	var new_blood = bloodparticle.instance()
	new_blood.random_perm = false
	new_blood.reverse_gravity = dir
	get_parent().add_child(new_blood)
	new_blood.global_position = get_global_mouse_position()



func _on_DeadActivator_timeout():
	#get_parent().player_was_dead()
	pass

func _on_HitCooldown_timeout():
	damage_permission = true



func _on_AdaptTimer_timeout():
	pass




func take_a_damage():
	if damage_permission:
		stomping = false
		if Globals.extra_health >0:
			Globals.extra_health -=1
			
			
			if Globals.extra_health == 0:
				Globals.max_extra_health = 0
				
			hide()
			canMove = false
			#$CollisionShape2D.set_deferred("disabled",true)
			#$HitBox/CollisionShape2D.set_deferred("disabled",true)
			get_parent().player_pos_resetter("take_a_damage")
			bloodsplashperm = false
			
			
			
			get_parent().get_node("HUD").check_heart()
			
			produce_blood_particle(12)
			damage_permission = false
			
			#$HitCooldown.start()
			$EffectAnim.play("HitEffect")

		elif Globals.health >1:
			Globals.health -=1
			hide()
			canMove = false
			#$CollisionShape2D.set_deferred("disabled",true)
			#$HitBox/CollisionShape2D.set_deferred("disabled",true)
			get_parent().player_pos_resetter("take_a_damage")
			bloodsplashperm = false
			
			
			
			get_parent().get_node("HUD").check_heart()
			produce_blood_particle(12)
			damage_permission = false
			
			#$HitCooldown.start()
			$EffectAnim.play("HitEffect")
		else:
			died()

	
	
	
func died():
	hide()
	
	canMove = false
	$AnimationPlayer.stop()
	#$EffectAnim.play("DeadEffect")
	
	Globals.health -=1
	get_parent().get_node("HUD").check_heart()
	produce_blood_particle(30)
	$DeadActivator.start()
	get_parent().player_pos_resetter("died")


func _on_HitBox_area_entered(area):
	if area.is_in_group("Damager"):
		if area.is_in_group("Spike"):
			area.painted("player")
			take_a_damage()



