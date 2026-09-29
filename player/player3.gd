extends KinematicBody2D

"""

var tromboline_jump_force = 2000
var tromboline_direction = 0


var floor_ice = false #ice floor detector
onready var healt_bar = get_tree().current_scene.get_node("CanvasLayer").get_node("AnimatedSprite")
#Player_run_assets

onready var run1 = preload("res://player_anim/Run_1.png")
onready var run2 = preload("res://player_anim/run_2.png")
onready var run3 = preload("res://player_anim/Run_3.png")
onready var run4 = preload("res://player_anim/Run_4.png")
onready var run5 = preload("res://player_anim/Run_5.png")
#Player_idle_assets
onready var idle1 = preload("res://player_anim/idle_1.png") 
onready var idle2 = preload("res://player_anim/idle_2.png") 
onready var idle3 = preload("res://player_anim/idle_3.png") 
onready var idle4 = preload("res://player_anim/idle_4.png") 
onready var idle5 = preload("res://player_anim/idle_5.png") 
#Player_jump_assets
onready var jump1 = preload("res://player_anim/jump_1.png")
onready var jump2 = preload("res://player_anim/jump_2.png")
onready var jump3 = preload("res://player_anim/jump_3.png")
onready var jump4 = preload("res://player_anim/jump_4.png")
onready var jump5 = preload("res://player_anim/jump_5.png")

#onready var player5 = preload("res://Sprites/player5.png")
#onready var player_container = [player1,player2,player3,player4,player5]

onready var Next_level_menu = get_tree().current_scene.get_node("CanvasLayer")
onready var current_lvl = get_tree().current_scene
onready var bullet = preload("res://Bullets/Bullet.tscn")


#Boost vars
var inmortality_perm  = false
var endless_shoot_perm = false
var speed_boost_perm = false
var extra_hearts_perm = false

#use for seting under timer vars
export var speed_time =5
export var ammo_time =5
export var shield_time =5


#use for timer
var speed_boost = 0
var endless_ammo_boost = 0
var shield_boost = 0
"""



#Movement_Varuables
var velocity = Vector2()
var gravity 
var move_direction
var check_floor
var move_permission = true

#--> double jump variable
export var extra_jump_count = 2
var useable_extra_jump = 2
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


export var knockback = 1500
export var knockup = 300

const UP = Vector2(0,-1)
const SLOPE_STOP = 64.0
const DEFAULT_MAX_FLOOR_ANGLE = deg2rad(5)
var max_slope_angle = 0.785398

"""

onready var SM = $SM
onready var Look = $Lookray

onready var player_anim = $Animations

#State_Machine 
var is_jumping = false
var is_grounded = false
var is_wall_sliding = false #doesn't matter just for future
var is_dodging = false #doesn't matter just for future
var is_dead = false
signal graunded_updated

#var knocback_side


var d = true

export (int,0,2000) var inertia = 1000 #Rigidbody to Staticbody

var look_scale = 3

var alma = true
#var  trampoline = true


#shine effect vars for check immortality
var shine_effect_tween = Tween.new()
const SHINE_TIME = 0.4
var shine_time_start = false

var damage = 5#given damage to enemy

#flipdead vars
var tween_flip_count =0#check for tween action counter
onready var target_flipper = self
var reverse_jump_height = 1000
var flip_fall_distance = 3000
export var flip_duration_dict = {"reverse":0.05,"rev_jump":0.15,"fall_duration":0.7,"wait_reverse": 0.1,"wait_flipjump":0,"wait_flipfall":0.05}
"""
onready var double_jump_perm = true
var is_jumping = false
var is_grounded = false
onready var Raycasts = $Raycasts
func _ready():
	#This code helps us to close the double jump feature by connecting it to the levels.
	if double_jump_perm == true:
		useable_extra_jump = extra_jump_count
	else:
		useable_extra_jump = 0
	#/////////////////////////////////////////////
		
		
	#add_child(shine_effect_tween)
	
	#set_physics_process(true)
	#randomize()
	gravity = 3 * max_jump_height/pow(jump_duration,2)
	max_jump_velo = -sqrt(2 * gravity * max_jump_height) 
	min_jump_velo = -sqrt(2 * gravity * min_jump_height) 

	#global._load_store()
	"""
	if global.store.selected == 0:
		$Player_set/run.texture = run1
		$Player_set/idle.texture = idle1
		$Player_set/damage.texture = jump1
		$Player_set/jump.texture = jump1
		
	elif global.store.selected == 1:
		$Player_set/run.texture = run2
		$Player_set/idle.texture = idle2
		$Player_set/damage.texture = jump2
		$Player_set/jump.texture = jump2
	
	elif global.store.selected == 2:
		$Player_set/run.texture = run3
		$Player_set/idle.texture = idle3
		$Player_set/damage.texture = jump3
		$Player_set/jump.texture = jump3
	
	elif global.store.selected == 3:
		$Player_set/run.texture = run4
		$Player_set/idle.texture = idle4
		$Player_set/damage.texture = jump4
		$Player_set/jump.texture = jump4
	
	elif global.store.selected == 4:
		$Player_set/run.texture = run5
		$Player_set/idle.texture = idle5
		$Player_set/damage.texture = jump5
		$Player_set/jump.texture = jump5
	"""





#export var length = 30
#var point = Vector2()

func _physics_process(delta):
	"""
	if speed_boost_perm:
		$Trail/Trail_line.global_position = Vector2(0,0)
		$Trail/Trail_line.global_rotation = 0
		point = $Trail/trailpos.global_position
		$Trail/Trail_line.add_point(point)
		while $Trail/Trail_line.get_point_count() > length:
			$Trail/Trail_line.remove_point(0)
	else:
		for i in range($Trail/Trail_line.points.size()-1,-1,-1):
			$Trail/Trail_line.remove_point(i)
	"""
		
	
	"""
	#if is_on_floor():
		#trampoline = true
	#print(move_direction)
	if Input.is_action_just_pressed("K"):
		if global.ammo_1 > 0 or endless_shoot_perm:
			var new_bullet = bullet.instance()
			new_bullet.global_position = $Player_set/Position2D.global_position
			get_tree().current_scene.add_child(new_bullet)
			if endless_shoot_perm == false:
				global.ammo_1 -= 1
			if $Player_set.scale.x > 0:
				new_bullet.scale.x = Look.scale.y 
				#new_bullet.apply_impulse(Vector2(0,0),Vector2(new_bullet.bullet_speed,0))
				new_bullet.current_direction = sign($Player_set.scale.x)
				velocity.x -= 100
			if $Player_set.scale.x < 0:
				new_bullet.scale.x = Look.scale.y 
				#new_bullet.apply_impulse(Vector2(0,0),Vector2(-new_bullet.bullet_speed,0))
				new_bullet.current_direction = sign($Player_set.scale.x)
				velocity.x += 100
	"""
	
	check_floor = check_on_floor()
	
	
	if check_floor:
		if double_jump_perm:
			useable_extra_jump = extra_jump_count
		else:
			useable_extra_jump = 0
		check_extra_jump = false
		
		
		
	out_of_the_world()
	
	_handle_move_input()
	apply_gravity(delta)

	checking_jump()
		
	var snap = Vector2.DOWN * 32 if !check_jump else Vector2.ZERO
	var was_on_floor = is_on_floor()# maybe delete
	if move_direction == 0 and abs(velocity.x) < SLOPE_STOP:
		velocity.x = 0
		
	var stop_on_slope = true if get_floor_velocity().x == 0 else false
	

	velocity = move_and_slide_with_snap(velocity,snap,UP,stop_on_slope,4,deg2rad(60),false)
	#Slope ayarla
	

	"""
	for index in  get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("block") or collision.collider.is_in_group("lever") or collision.collider.is_in_group("bullet") :
			collision.collider.apply_central_impulse(-collision.normal * inertia)
		
		
		#check floor snow,normal or soulsand
		if collision.collider.is_in_group("SpecialTiles"):
			#dedect for ground
			var pos_id = $Player_set/Position2D2.global_position
			var tile :Vector2 =  collision.collider.world_to_map(pos_id)
			#print(collision.collider.name)
			var ground_id = collision.collider.get_cellv(tile)
			
			var now_id 
			if ground_id == 1:
				floor_ice = true
				now_id = ground_id
			elif ground_id == 2:
				now_id = ground_id
				var_spd = 3 +boost_speed
				move_spd = var_spd * global.UNIT_SIZE
				player_anim.playback_speed = 0.5
				floor_ice = false
			elif ground_id == 0:
				now_id = ground_id
				var_spd = 5 + boost_speed
				move_spd = var_spd * global.UNIT_SIZE
				player_anim.playback_speed = 1
				floor_ice = false
				
			elif ground_id == -1:
				if now_id == -1:
					floor_ice = true
			else:
				floor_ice = false
				var_spd = 5 + boost_speed
				move_spd = var_spd * global.UNIT_SIZE
				player_anim.playback_speed = 1
			#if you add tile type you can add here
		
		
		#floor is platform set parametr like normal 
		if collision.collider.is_in_group("Platform"):
			floor_ice = false
			var_spd = 5 + boost_speed
			move_spd = var_spd * global.UNIT_SIZE
			player_anim.playback_speed = 1
		#if you add platform type you can add here
			####
		
		#floor is normaltile set parametr like normal 
		if collision.collider.is_in_group("NormalTile"):
			floor_ice = false
			var_spd = 5 + boost_speed
			move_spd = var_spd * global.UNIT_SIZE
			player_anim.playback_speed = 1
		#if you add platform type you can add here
			####
	
	if !is_on_floor() and was_on_floor and (!check_jump ):
		$Coyote.start()
		velocity.y = 0
	if is_on_floor() and !$Buffer.is_stopped():
		#jump()
		pass
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("graunded_updated",is_grounded)
		
	"""


"""
#state machine and animation compiler system
func animation_station():
	if tween_flip_count !=2:#!player_anim.current_animation == "dead":
		if !player_anim.current_animation == "damage":
			if move_direction > 0 and is_on_floor():
				if $SM.text != "Push":
					$SM.text = "Right"
				player_anim.play("run")
			if move_direction < 0 :#and is_on_floor():
				if $SM.text != "Push":
					$SM.text = "Left"
				player_anim.play("run")
			if move_direction == 0 and is_on_floor():
				$SM.text = "idle"
				player_anim.play("idle")
			if velocity.y < 0 and !is_on_floor():
				if check_extra_jump:
					$SM.text = "DJump"
				else:
					$SM.text = "jump"
					player_anim.play("jump")
			else:
				if !is_on_floor() and check_jump == false:
					$SM.text = "Fall"
"""

	
func checking_jump():
	if check_jump and velocity.y >= 0:
		check_jump = false
				
func _input(event):
	if event.is_action_pressed("jump"):
		jump_system_pressed()
	if event.is_action_released("jump"):
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
			add_dust_instance(8,[5,7],[0.5,1],.1,3)
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
	
	
	
func _handle_move_input():#Dedetc move direction
	#if stun == false:
	if move_permission:
		move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		
		"""
		if floor_ice == true:
			if move_direction != 0:
				velocity.x = lerp(velocity.x,move_spd * move_direction,_get_h_weight())
		else:
			velocity.x = lerp(velocity.x,move_spd * move_direction,_get_h_weight())
		if move_direction != 0:
			if move_direction > 0:
				$Player_set.scale.x = 5
			if move_direction < 0:
				$Player_set.scale.x = -5
		
		if Look.is_colliding():
			if Look.get_collider().name == "TileMap":
				if Look.scale.y  == move_direction:
					move_direction = 0
				else:
					velocity.x = lerp(velocity.x,move_spd * move_direction,_get_h_weight())
			
			
			#for tile push animation and mechanic d
			if Look.get_collider().is_in_group("block") and move_direction != 0:
				var_spd = 1+boost_speed
				move_spd = var_spd * global.UNIT_SIZE
				modulate = Color(1, 0, 0)
				$SM.text = "Push"
			
			else:
				modulate = Color(1, 1, 1)
				var_spd = 5+boost_speed
				move_spd = var_spd * global.UNIT_SIZE
				$SM.text = ""
		else:
			modulate = Color(1, 1, 1)
			var_spd = 5+boost_speed
			move_spd = var_spd * global.UNIT_SIZE
			$SM.text = ""
		#for animation playing and animation direction
		
		if move_direction !=0:
			Look.scale.y = move_direction 
			

		
		animation_station()
		"""
		
"""
func out_of_the_world(): #Fall
	if global.dead_fall == false:
		if global_position.y > 3000:
			Next_level_menu.health_damage()
			#player_anim.play("dead")
			global.dead_fall = true
			deadflip()
"""
"""
func knockhit(dir,power,time):
		var knocback_side = knockback * dir*power#global.hit_side
		$KnockbackTween.interpolate_property(self,"velocity",Vector2.ZERO,Vector2(knocback_side,-knockup),time,Tween.TRANS_EXPO,Tween.EASE_IN)
		$KnockbackTween.start()
		#velocity.x = lerp(velocity.x,knocback_side,0.5)
		#velocity.y -= knockup #lerp(0,knockup,0.6)
		#velocity = move_and_slide(velocity,UP)
		if global.dead_player != true:
			blink()
			if tween_flip_count !=2:#player_anim.current_animation != "dead":
				player_anim.play("damage")
"""
		
"""
func blink()-> void:#Blink animation
	$Player_set.visible = false
	yield(get_tree().create_timer(0.05),"timeout")
	$Player_set.visible = true
	yield(get_tree().create_timer(0.07),"timeout")
	$Player_set.visible = false
	yield(get_tree().create_timer(0.1),"timeout")
	$Player_set.visible = true
	if tween_flip_count!= 2:#player_anim.current_animation != "dead":
		player_anim.current_animation = "idle"
"""
	
	
"""
func create_jump_fx_timer():
	var jump_effect_timer = Timer.new()
	add_child(jump_effect_timer)
	jump_effect_timer.wait_time = 0.1
	jump_effect_timer.one_shot = true
	$Jump_effect.visible = true
	jump_effect_timer.connect("timeout",self,"Jump_fx_timeout",[$Jump_effect])
	jump_effect_timer.start()

func Jump_fx_timeout(jump_fx):
	jump_fx.visible = false
"""



"""
func simple_dust_maker():
	var new_dust = Sprite.new()
	get_tree().current_scene.add_child(new_dust)
	new_dust.global_position = $Player_set/Position2D2.global_position
	new_dust.texture = load("res://Lock_lvl_sys/Smoke.png")
	new_dust.hframes = 4
	new_dust.vframes = 2
	new_dust.frame= 0
	new_dust.scale = Vector2(4,4)


#dust generator prototype for future(not work for now)

func add_dust_instance(dust_count,dust_random_size,random_life_time,dust_speed,anim_frame):
	var dust_position = $Player_set/Position2D2
	for i in range(1):
		var new_spite = Sprite.new()
		new_spite.name = str(i)
		new_spite.texture = load("res://Lock_lvl_sys/Smoke.png")
		get_tree().current_scene.add_child(new_spite)
		new_spite.global_position = dust_position.global_position
		new_spite.hframes = 4
		new_spite.vframes = 2
		new_spite.frame = 0
		
		#we add twens for improve to dust
		
		var dir_list = [1,-1]
		randomize()
		var random_dir = dir_list[randi()%dir_list.size()]
		var new_dust_move_tween = Tween.new()
		new_dust_move_tween.name = "tween"+str(i)+"pos"
		get_tree().current_scene.add_child(new_dust_move_tween)
		new_dust_move_tween.interpolate_property(new_spite,"global_position",new_spite.global_position,Vector2((new_spite.global_position.x)*random_dir,new_spite.global_position.y),dust_speed,Tween.TRANS_EXPO,Tween.EASE_OUT_IN)
		


		var random_time = rand_range(random_life_time[0],random_life_time[1])
		var new_dust_anim_tween = Tween.new()
		new_dust_anim_tween.name = "tween"+str(i)+"anim"
		get_tree().current_scene.add_child(new_dust_anim_tween)
		new_dust_anim_tween.interpolate_property(new_spite,"frame",0,anim_frame,random_time,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		
		
		var random_scale = rand_range(dust_random_size[0],dust_random_size[1])
		var new_dust_scale_tween = Tween.new()
		new_dust_scale_tween.name = "tween1"+str(i)+"scale"
		get_tree().current_scene.add_child(new_dust_scale_tween)
		new_dust_scale_tween.interpolate_property(new_spite,"scale",Vector2(dust_random_size[1],dust_random_size[1]),Vector2(random_scale,random_scale),random_time,Tween.TRANS_EXPO,Tween.EASE_OUT_IN)
		
		
		var new_dust_life_tween = Tween.new()
		new_dust_life_tween.name = "tween1"+str(i)+"life"
		get_tree().current_scene.add_child(new_dust_life_tween)
		new_dust_life_tween.interpolate_property(new_spite,"modulate",Color(1,1,1,1),Color(1,1,1,0),random_time,Tween.TRANS_EXPO,Tween.EASE_OUT_IN)
		
		new_dust_life_tween.connect("tween_all_completed",self,"Delete_old_dust",[new_spite,new_dust_scale_tween,new_dust_move_tween,new_dust_life_tween,new_dust_anim_tween])
		
		

		
		new_dust_life_tween.start()
		#new_dust_move_tween.start()
		new_dust_scale_tween.start()
		new_dust_anim_tween.start()

func Delete_old_dust(a,b,c,d,e):
	a.queue_free()
	b.queue_free()
	c.queue_free()
	d.queue_free()
	e.queue_free()



func deadflip():
	#move_permission = false
	#velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled",true)
	$HurtBox/CollisionShape2D.set_deferred("disabled",true)
	$WeakBreaker/CollisionShape2D.set_deferred("disabled",true)
	$Animations.play("idle")
	$FlipTween.interpolate_property(target_flipper,"scale",Vector2(target_flipper.scale.x,target_flipper.scale.y),Vector2(target_flipper.scale.x,-target_flipper.scale.y),flip_duration_dict["reverse"],Tween.TRANS_LINEAR,Tween.EASE_OUT,flip_duration_dict["wait_reverse"])
	$FlipTween.start()

func _on_FlipTween_tween_all_completed():
	if tween_flip_count ==0:
		tween_flip_count += 1
		#$FlipTween.interpolate_property(target_flipper,"position",Vector2(position.x,position.y),Vector2(position.x,position.y-reverse_jump_height),flip_duration_dict["rev_jump"],Tween.TRANS_LINEAR,Tween.EASE_OUT,flip_duration_dict["wair_flipjump"])
		$FlipTween.interpolate_property(target_flipper,"velocity",Vector2.ZERO,Vector2(0,-reverse_jump_height),flip_duration_dict["rev_jump"],Tween.TRANS_LINEAR,Tween.EASE_OUT,flip_duration_dict["wait_flipjump"])
		$FlipTween.start()
	elif tween_flip_count ==1:
		tween_flip_count += 1
		#$FlipTween.interpolate_property(target_flipper,"position",Vector2(position.x,position.y),Vector2(position.x,position.y+flip_fall_distance),flip_duration_dict["fall_duration"],Tween.TRANS_LINEAR,Tween.EASE_OUT,flip_duration_dict["wait_flipfall"])
		$FlipTween.interpolate_property(target_flipper,"velocity",Vector2.ZERO,Vector2(0,flip_fall_distance),flip_duration_dict["fall_duration"],Tween.TRANS_LINEAR,Tween.EASE_OUT,flip_duration_dict["wait_flipfall"])
		$FlipTween.start()
	else:
		$FlipTween.stop_all()
		#queue_free()
		Next_level_menu.get_node("Blur").show()
		Next_level_menu.get_node("Blur/Next_level/Button_container/next").hide()
		Next_level_menu.get_node("Blur/Next_level/data_container/time").text = Next_level_menu.get_node("Label").text
		Next_level_menu.get_node("Blur/Next_level/data_container/enemy").text = "Enemy " + str(global.dead_enemy_count)
		Next_level_menu.get_node("Blur/Next_level/data_container/button").text = "Button " + str(global.pushed_button)
		Next_level_menu.get_node("Blur/Next_level/data_container/ammo").text = "Ammo " + str(global.ammo) 
		Next_level_menu.get_node("Blur/Next_level/data_container/caps").text = "Score " + str(global.score)
		#Next_level_menu.get_node("Blur/Next_level/data_container/caps").text = "Caps " + str(global.caps) #if you need caps here 
		#global.load_stars()
		#global._load_levels()
		if global.now_world in ["1","2"]:#you can calculate this automatic from "World" scene 
			if "world"+ global.now_world in global.comp_world:
				if "level"+current_lvl.name in global.comp_world["world"+global.now_world]:
					for a in global.comp_world:
						if "world"+global.now_world == a:
							for b in global.comp_world[a]:
								if b == "level" +current_lvl.name:
									for c in global.comp_world[a][b]:
										global._load_levels()
										for d in Next_level_menu.get_node("Blur/Next_level/Stars").get_children():
											if d.name == c:
												d.modulate = Color(1,1,1)
		if global.now_world in ["b_1","b_2"]:
			if global.now_world in global.comp_world:
				if "level"+current_lvl.name in global.comp_world[global.now_world]:
					for a in global.comp_world:
						if "world"+global.now_world == a:
							for b in global.comp_world[a]:
								if b == "level" +current_lvl.name:
									for c in global.comp_world[a][b]:
										global._load_levels()
										for d in Next_level_menu.get_node("Blur/Next_level/Stars").get_children():
											if d.name == c:
												d.modulate = Color(1,1,1)
			
		if global.dead_fall == false:
			global.dead_player = true
			
		global.complate_lvl = true
		get_tree().paused = true
		Next_level_menu.get_node("Timer").stop()

	

func _on_Stun_timeout():
	stun = false










func _on_visible_detector_body_entered(body):
	if body.is_in_group("Enemy"):
		pass
		#body.visible = true
		#body.activitor = true
		


func _on_visible_detector_body_exited(body):
	if body.is_in_group("Enemy"):
		pass
		#body.visible = false
		#body.activitor = false




func _on_HurtBox_body_entered(body):
	#if body.is_in_group("Enemy"):
	#	if inmortality_perm == false:
	#		$Stun.start()
	#		stun = true
			#print("damage")
			#knockhit(body.direction)
	#		Next_level_menu.health_damage()
	pass
	
	if body.is_in_group("block"):
		if body.linear_velocity.y > 350:
			$Stun.start()
			stun = true
			blink()
			Next_level_menu.health_damage()#damage calculator is in Ui(CAnvaslayer)



func _on_HurtBox_area_entered(area):

	if area.is_in_group("Spike"):
		if inmortality_perm == false:
			blink()
			$Damager_rest_time.start()
			$HurtBox/CollisionShape2D.set_deferred("disabled",true)
			Next_level_menu.health_damage()
	
	if area.is_in_group("Enemy"):
		if inmortality_perm == false:
			$Stun.start()
			stun = true
			#print("damage")
			if global.current_heart[0]>1 or global.current_heart[1]>0:
				if velocity.x !=0:
					knockhit(-sign(velocity.x),1,0.1)
				else:
					knockhit(area.get_parent().direction,1,0.1)
			$HurtBox/CollisionShape2D.set_deferred("disabled",true)
			Next_level_menu.health_damage()
	
	if area.is_in_group("ammo"):
		if global.ammo_1 < 90:
			global.ammo_1 += 5
			if global.ammo_1 > 90:
				global.ammo_1 = 90
			area.queue_free()
		else:
			global.ammo_1 = 90
			area.queue_free()
			
	"""
	if area.is_in_group("Tromboline"):
		if trampoline:
		
			if round(area.rotation_degrees) == 0 or round(area.rotation_degrees) == -90:
				tromboline_direction = -1
			if round(area.rotation_degrees) == -180 or round(area.rotation_degrees) == 90:
				tromboline_direction = 1
			#if body.rotation_degrees == 0:/ #You can much sensitive this direction system
			#	body_direction = 1

			if round(area.rotation_degrees) == 0:
				velocity.y -= tromboline_jump_force
			if round(area.rotation_degrees) == -180:
				velocity.y += tromboline_jump_force
			if round(area.rotation_degrees) == -90:
				velocity.x -= tromboline_jump_force 
			if round(area.rotation_degrees) == 90:
				velocity.x += tromboline_jump_force
			print(round(area.rotation_degrees))
			trampoline = false
	"""


func _on_Animations_animation_finished(anim_name):
	if anim_name== "dead":
		pass


func inmortality_shine_effect():
	$shine_loop_timer.wait_time = 5
	var current_sprite = $Player_set/idle
	if tween_flip_count !=2:#player_anim.current_animation != "dead":
		current_sprite = get_node("Player_set/"+player_anim.current_animation)
		pass
	shine_effect_tween.interpolate_property(current_sprite.material, "shader_param/shine_progress", 
	1.0, 0.0, SHINE_TIME, Tween.TRANS_SINE, Tween.EASE_IN)
	shine_effect_tween.interpolate_property(current_sprite.material, "shader_param/shine_size", 
	0.13, 0.01, SHINE_TIME * 1, Tween.TRANS_CUBIC, Tween.EASE_IN, 
	SHINE_TIME * .25)
	
	"""
	shine_effect_tween.interpolate_property(current_sprite.material, "shader_param/shine_progress", 
	0.0, 1.0, SHINE_TIME, Tween.TRANS_SINE, Tween.EASE_OUT, SHINE_TIME)
	shine_effect_tween.interpolate_property(current_sprite.material, "shader_param/shine_size", 
	null, 0.13, SHINE_TIME * 0.75, Tween.TRANS_CUBIC, Tween.EASE_OUT, 
	SHINE_TIME * .25 + SHINE_TIME)
	"""
	shine_effect_tween.start()







#boost funcs 
func boost_check(current_boost):
	if current_boost == "extra_hearts":
		if !extra_hearts_perm:
			extra_heart()
			global.boost_datas[current_boost] -=1
			Next_level_menu.get_node("Inventory/inventory_slots/"+current_boost+"/item_count").text = "x" + str(global.boost_datas[current_boost])
	elif current_boost== "shield":
		if !inmortality_perm:
			shield(current_boost)
			global.boost_datas[current_boost] -=1
			Next_level_menu.get_node("Boost_Timer").show()
			Next_level_menu.get_node("Inventory/inventory_slots/"+current_boost+"/item_count").text = "x" + str(global.boost_datas[current_boost])
		
	elif current_boost== "endless_ammo":
		if !endless_shoot_perm:
			endless_ammo(current_boost)
			global.boost_datas[current_boost] -=1
			Next_level_menu.get_node("Boost_Timer").show()
			Next_level_menu.get_node("Inventory/inventory_slots/"+current_boost+"/item_count").text = "x" + str(global.boost_datas[current_boost])
		
	elif current_boost== "speed":
		if !speed_boost_perm:
			speed(current_boost)
			global.boost_datas[current_boost] -=1
			Next_level_menu.get_node("Boost_Timer").show()
			Next_level_menu.get_node("Inventory/inventory_slots/"+current_boost+"/item_count").text = "x" + str(global.boost_datas[current_boost])
		
func extra_heart():
	extra_hearts_perm = true
	current_lvl.extra_heart = 3
	global.extra_heart = current_lvl.extra_heart#actualy we are no need global vars for main and extra hearts
	#global.current_heart[0] = global.main_heart
	global.current_heart[1] = global.extra_heart#But I add to system for future.So this should be help you add new things or etc more easy
	Next_level_menu.health_checker()

func shield(cb):
	inmortality_perm =true
	shield_boost = shield_time
	create_boost_timer(0.1,cb,shield_boost) #<--- cb is current boost
	$shine_loop_timer.start()

func endless_ammo(cb):
	endless_ammo_boost =ammo_time
	endless_shoot_perm =true
	create_boost_timer(0.1,cb,endless_ammo_boost)

func speed(cb):
	speed_boost=speed_time
	speed_boost_perm =true
	boost_speed = current_boost_speed
	create_boost_timer(0.1,cb,speed_boost)

	
	
	
func create_boost_timer(wait_time,cb,time_value):
	var new_boost_timer = Timer.new()
	add_child(new_boost_timer)
	new_boost_timer.one_shot = false
	new_boost_timer.wait_time =wait_time
	new_boost_timer.connect("timeout",self,"Boost_timer_timeout",[new_boost_timer,wait_time,cb,time_value])
	new_boost_timer.start()
	
	
func Boost_timer_timeout(current_timer,wait_time,cb,value):
	if cb == "speed":

		if speed_boost >= wait_time:
			speed_boost -= wait_time
			Next_level_menu.get_node("Boost_Timer/Time_label").text = cb + ":" + str(abs(speed_boost))
		else:
			current_timer.stop()
			Next_level_menu.get_node("Boost_Timer").hide()
			boost_speed = 0
			speed_boost_perm = false
			
	
	elif cb == "shield":
		if shield_boost >= wait_time:
			shield_boost -= wait_time
			Next_level_menu.get_node("Boost_Timer/Time_label").text = cb + ":" + str(abs(shield_boost))
		else:
			current_timer.stop()
			Next_level_menu.get_node("Boost_Timer").hide()
			$shine_loop_timer.stop()
			inmortality_perm= false

	elif cb == "endless_ammo":
		if endless_ammo_boost >= wait_time:
			endless_ammo_boost -= wait_time
			Next_level_menu.get_node("Boost_Timer/Time_label").text = cb + ":" + str(abs(endless_ammo_boost))
		else:
			current_timer.stop()
			Next_level_menu.get_node("Boost_Timer").hide()
			endless_shoot_perm = false


func _on_WeakBreaker_body_entered(body):
	if body.is_in_group("weakarea"):
		body.get_parent().weakarea(self)


func _on_KnockbackTween_tween_all_completed():
	pass # Replace with function body.
	$HurtBox/CollisionShape2D.set_deferred("disabled",false)#for now we will add here some blink mechanics


func _on_Damager_rest_time_timeout():
	$HurtBox/CollisionShape2D.set_deferred("disabled",false)
