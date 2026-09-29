extends KinematicBody2D

#Movement_Varuables
var velocity = Vector2()
var gravity 
var move_direction
var check_floor
var move_permission = true

#--> double jump variable
export var extra_jump_count = 1
var useable_extra_jump = 1
var check_extra_jump = false

var check_jump
var max_jump_velo
var min_jump_velo
var stun = false

#Movemen_Parameters
export var current_boost_speed = 5
var boost_speed = 0
var var_spd = 3
var move_spd = var_spd * Globals.UNIT_SIZE

var max_jump_height = 2.5 * Globals.UNIT_SIZE
var min_jump_height = 0.8 * Globals.UNIT_SIZE
var jump_duration = 0.6

#slope settings
const UP = Vector2(0,-1)
const SLOPE_STOP = 64.0
const DEFAULT_MAX_FLOOR_ANGLE = deg2rad(75)
var max_slope_angle = 0.785398

var is_jumping = false
var is_grounded = false
onready var Raycasts = $Raycasts

var damage_permission = true

#BloodParticles
var bloodparticle = preload("res://Blood/BloodParticle2.tscn")

var canMove = true
var canJump = false
#COIN
onready var cointile = get_parent().get_node("CoinTile")

onready var bloodlayers = get_parent().get_node("BloodLayers").get_children()
onready var tilemap = get_parent().get_node("TileMap")


#move parameters
const ACCELERATION = 3000
const MAX_SPEED = 18000
const LIMIT_SPEED_Y = 1200


func _ready():
	useable_extra_jump = extra_jump_count
	
	
	gravity = 3 * max_jump_height/pow(jump_duration,2)
	max_jump_velo = -sqrt(2 * gravity * max_jump_height) 
	min_jump_velo = -sqrt(2 * gravity * min_jump_height) 


func horizontalMovement(delta):
	if Input.is_action_pressed("Right"):
		if $Rotatable/RayCast2D.is_colliding():
			yield(get_tree().create_timer(0.1),"timeout")
			velocity.x = min(velocity.x + ACCELERATION * delta, MAX_SPEED * delta)
			$Rotatable.scale.x = 1
			if canJump:
				$AnimationPlayer.play("Run")
				$StateMachine.text = "Run"
		else:
			velocity.x = min(velocity.x + ACCELERATION * delta, MAX_SPEED * delta)
			$Rotatable.scale.x = 1
			if canJump:
				$AnimationPlayer.play("Run")
				$StateMachine.text = "Run"

	elif Input.is_action_pressed("Left"):
		if $Rotatable/RayCast2D.is_colliding():
			yield(get_tree().create_timer(0.1),"timeout")
			velocity.x = max(velocity.x - ACCELERATION * delta, -MAX_SPEED * delta)
			$Rotatable.scale.x = -1
			if canJump:
				$AnimationPlayer.play("Run")
				$StateMachine.text = "Run"
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


func _physics_process(delta):
	if canMove:
		check_floor = check_on_floor()
		
		
		if check_floor:
			useable_extra_jump = extra_jump_count
			check_extra_jump = false
			
		horizontalMovement(delta)
		if !canJump:
			if velocity.y >= 0:
				$AnimationPlayer.play( "Fall")
				$StateMachine.text = "Fall"
			elif velocity.y < 0:
				$AnimationPlayer.play( "Jump")
				$StateMachine.text = "Jump"

		
		if check_on_floor() == false:
			apply_gravity(delta)

		checking_jump()
			
		var snap = Vector2.DOWN * 32 if !check_jump else Vector2.ZERO
		var was_on_floor = is_on_floor()# maybe delete
		if move_direction == 0 and abs(velocity.x) < SLOPE_STOP:
			velocity.x = 0
			
		var stop_on_slope = true if get_floor_velocity().x == 0 else false
		

		velocity = move_and_slide_with_snap(velocity,snap,UP,stop_on_slope,4,deg2rad(75),false)
		
func checking_jump():
	if check_jump and velocity.y >= 0:
		check_jump = false
				
func _input(event):
	if event.is_action_pressed("Jump"):
		jump_system_pressed()
	if event.is_action_released("Jump"):
		jump_system_released()
		
		
	## Touch Button reflect for emitter
func jump_system_pressed():
	if (is_on_floor() or !$Coyote.is_stopped()):
		if useable_extra_jump >=0:#jump_count == 0 ----> we can disable character jump
			$Coyote.stop()
			jump()
			useable_extra_jump -=1
			#floor jump effect is here
			#add_dust_instance(8,[3,5],[1,3],.1,4)
		else:
			$Buffer.start()
	else:
		if useable_extra_jump >0:#jump_count == 0 ----> we can disable character jump
			$Coyote.stop()
			jump()
			useable_extra_jump -=1
			#add_dust_instance(8,[5,7],[0.5,1],.1,3)
			#create_jump_fx_timer()
			#simple_dust_maker()
			check_extra_jump = true
		else:
			check_extra_jump = false
			$Buffer.start()
		
func jump_system_released():
	if velocity.y < min_jump_velo: 
		velocity.y = min_jump_velo
	##
		
		
		
		
func jump(): 
	if velocity.y > max_jump_velo:
		velocity.y = max_jump_velo
		check_jump = true
	else:
		velocity.y = velocity.y+ max_jump_velo
		check_jump = true

func _get_h_weight():
	if is_on_floor() or !$Coyote.is_stopped():
		return 0.2
	else:
		return 0.1
		
		
		
		
func apply_gravity(delta,modifier = 1.0):
	if $Coyote.is_stopped():
		velocity.y += delta * gravity * modifier
		if check_jump and velocity.y >=0:
			check_jump = false
			return true
			
			
			
func check_on_floor():
	for raycast in Raycasts.get_children():
		if raycast.is_colliding():
			return true
		#print(raycast.get_collider())
	return false
	
	
	
	
func damagehit():
	if damage_permission:
		if Globals.healt >1:
			Globals.healt -=1
			get_parent().get_node("HUD").check_heart()
			produce_blood_particle(15)
			damage_permission = false
			$HitCooldown.start()
			$EffectAnim.play("HitEffect")
		else:
			hide()
			canMove = false
			$AnimationPlayer.stop()
			#$EffectAnim.play("DeadEffect")
			Globals.healt -=1
			get_parent().get_node("HUD").check_heart()
			produce_blood_particle(30)
			$DeadActivator.start()

func coin_target_calculator():
	var player_pos = position
	var curent_tile_pos = cointile.world_to_map(player_pos)
	var coin_id = cointile.get_cellv(curent_tile_pos)
	if coin_id !=-1:
		cointile.tile_collected(curent_tile_pos.x,curent_tile_pos.y)


func blood():
	var addrect = 64
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
			var random_tile = randi()%3
			var random_corner = randi()%1+8
			
			var tile_id = tilemap.get_cellv(curent_tile_pos)
			
	
			
			var blood_tile_id = null
			blood_tile_id = bloodlayers[tp].get_cellv(curent_tile_pos)
			
	
			var tile_world_pos = tilemap.map_to_world(curent_tile_pos)
			
			
			var a =player_pos.distance_to(tile_world_pos)
			#print(a)
			
			
			if tile_id != -1 and blood_tile_id != null:
				if tp in [0,2]:
						if tile_id != 4 and blood_tile_id ==-1:
								if a<=64:
									#check side2
									var side_2_id = tilemap.get_cellv(side_2)
									var side_4_id = tilemap.get_cellv(side_4)
									if tp ==0 and side_2_id !=4:
										bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,false,false,1)
									if tp ==2 and side_4_id != 4:
										bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,false,false,0)
				elif tp in [1,3]:
					if tile_id != 4 and blood_tile_id ==-1:
						if a<128:
							#check side1
							var side_1_id = tilemap.get_cellv(side_1)
							var side_3_id = tilemap.get_cellv(side_3)
							if tp ==1 and side_1_id != 4:
								bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,true,false,1)
							if tp ==3 and side_3_id != 4:
								bloodlayers[tp].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_tile,false,true,0)
		#CHECK CORNERS
		#set active blood tiles
			if blood_tile_id != -1:
				active_blood_tiles[tp] = 1
			else:
				active_blood_tiles[tp] = -1
			#Set blood connected
			if !0 in active_blood_tiles:
				#X
				if active_blood_tiles[1] == 1 and active_blood_tiles[2] == 1:
					var new_blood_tile_pos = curent_tile_pos
					new_blood_tile_pos.x -= 1
					new_blood_tile_pos.y += 2
					var current_blood_tile_id = bloodlayers[tp].get_cellv(new_blood_tile_pos)
					if current_blood_tile_id == - 1:
						bloodlayers[tp].set_cell(new_blood_tile_pos.x,new_blood_tile_pos.y,random_corner,true,false,0)
						print("Test1","/",curent_tile_pos)
						
				if active_blood_tiles[0] == 1 and active_blood_tiles[2] == 1:
					var new_blood_tile_pos = curent_tile_pos
					new_blood_tile_pos.x +=1
					new_blood_tile_pos.y +=2
					var current_blood_tile_id = bloodlayers[tp].get_cellv(new_blood_tile_pos)
					if current_blood_tile_id == - 1:
						bloodlayers[tp].set_cell(new_blood_tile_pos.x,new_blood_tile_pos.y,random_corner,false,false,0)
						print("Test2","/",curent_tile_pos)
				#Y
				if active_blood_tiles[1] == 1 and active_blood_tiles[3] == 1:
					var new_blood_tile_pos = curent_tile_pos
					new_blood_tile_pos.x -=1
					new_blood_tile_pos.y +=0
					var current_blood_tile_id = bloodlayers[tp].get_cellv(new_blood_tile_pos)
					if current_blood_tile_id == - 1:
						bloodlayers[tp].set_cell(new_blood_tile_pos.x,new_blood_tile_pos.y,random_corner,true,true,0)
						print("Test3","/",curent_tile_pos)
			
				if active_blood_tiles[0] == 1 and active_blood_tiles[3] == 1:
					var new_blood_tile_pos = curent_tile_pos
					new_blood_tile_pos.x +=1
					new_blood_tile_pos.y -=0
					var current_blood_tile_id = bloodlayers[tp].get_cellv(new_blood_tile_pos)
					if current_blood_tile_id == - 1:
						bloodlayers[tp].set_cell(new_blood_tile_pos.x,new_blood_tile_pos.y,random_corner,false,true,0)
						print("Test4","/",curent_tile_pos)


func slope_blood():
	var addrect = 64
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
			var random_slope_tile = randi()%3+3
			var random_corner = randi()%1+8
			
			var tile_id = tilemap.get_cellv(curent_tile_pos)
			#print(tilemap.get_cell(curent_tile_pos.x,curent_tile_pos.y))
			
			
			var blood_tile_id = null
			
			blood_tile_id = bloodlayers[4].get_cellv(curent_tile_pos)

			var tile_world_pos = tilemap.map_to_world(curent_tile_pos)
			
			
			var a =player_pos.distance_to(tile_world_pos)
			
			
			
			if tile_id != -1 and blood_tile_id != null:
				if tp in [0,2]:
						if tile_id == 4 and blood_tile_id ==-1:
								if a<=64:
									var dir_1 = tilemap.is_cell_x_flipped(curent_tile_pos.x, curent_tile_pos.y)
									var dir_2 = tilemap.is_cell_y_flipped(curent_tile_pos.x, curent_tile_pos.y)
									
									
									if tp ==2:
										bloodlayers[4].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_slope_tile,dir_1,dir_2,0)
				
				elif tp in [1,3]:
					if tile_id == 4 and blood_tile_id ==-1:
						if a<=128:
							var dir_1 = tilemap.is_cell_x_flipped(curent_tile_pos.x, curent_tile_pos.y)
							var dir_2 = tilemap.is_cell_y_flipped(curent_tile_pos.x, curent_tile_pos.y)
									
							if tp ==3:
								bloodlayers[4].set_cell(curent_tile_pos.x,curent_tile_pos.y,random_slope_tile,dir_1,dir_2,0)
	
		#CHECK CORNERS
		#set active blood tiles
			if blood_tile_id != -1:
				if tile_id != 4:
					active_blood_tiles[tp] = 1
				else:
					active_blood_tiles[tp] = 4
			else:
				active_blood_tiles[tp] = -1
			#Set blood connected
			if !0 in active_blood_tiles:
				#X
				if active_blood_tiles[1] == 1 and active_blood_tiles[2] == 1:
					var new_blood_tile_pos = curent_tile_pos
					new_blood_tile_pos.x -= 1
					new_blood_tile_pos.y += 2
					var current_blood_tile_id = bloodlayers[tp].get_cellv(new_blood_tile_pos)
					if current_blood_tile_id == - 1:
						bloodlayers[tp].set_cell(new_blood_tile_pos.x,new_blood_tile_pos.y,random_corner,true,false,0)
						print("Test1","/",curent_tile_pos)
						
				if active_blood_tiles[0] == 1 and active_blood_tiles[2] == 1:
					var new_blood_tile_pos = curent_tile_pos
					new_blood_tile_pos.x +=1
					new_blood_tile_pos.y +=2
					var current_blood_tile_id = bloodlayers[tp].get_cellv(new_blood_tile_pos)
					if current_blood_tile_id == - 1:
						bloodlayers[tp].set_cell(new_blood_tile_pos.x,new_blood_tile_pos.y,random_corner,false,false,0)
						print("Test2","/",curent_tile_pos)
				#Y
				if active_blood_tiles[1] == 1 and active_blood_tiles[3] == 1:
					var new_blood_tile_pos = curent_tile_pos
					new_blood_tile_pos.x -=1
					new_blood_tile_pos.y +=0
					var current_blood_tile_id = bloodlayers[tp].get_cellv(new_blood_tile_pos)
					if current_blood_tile_id == - 1:
						bloodlayers[tp].set_cell(new_blood_tile_pos.x,new_blood_tile_pos.y,random_corner,true,true,0)
						print("Test3","/",curent_tile_pos)
			
				if active_blood_tiles[0] == 1 and active_blood_tiles[3] == 1:
					var new_blood_tile_pos = curent_tile_pos
					new_blood_tile_pos.x +=1
					new_blood_tile_pos.y -=0
					var current_blood_tile_id = bloodlayers[tp].get_cellv(new_blood_tile_pos)
					if current_blood_tile_id == - 1:
						bloodlayers[tp].set_cell(new_blood_tile_pos.x,new_blood_tile_pos.y,random_corner,false,true,0)
						print("Test4","/",curent_tile_pos)

func produce_blood_particle(count):
	for _i in range(count):
		var newblood = bloodparticle.instance()
		get_parent().call_deferred("add_child", newblood)
		newblood.global_position = global_position

