extends Node

const UNIT_SIZE = 96

var max_extra_health =0
var max_health = 3
var health  = 3
var extra_health  = 0




var coins = 0
var filledpoints = {}


var blooded_tiles = {}


#levels
var current_level = 0
var level_count = 0
var unlocked_levels = [0]
var complated_levels = []


var level_datas = {}










#save_data
var save_file = "user://savefile.save"


func save_file():
	var save_data = File.new()
	save_data.open(save_file,File.WRITE)
	save_data.store_var(unlocked_levels)
	save_data.store_var(complated_levels)
	save_data.store_var(current_level)
	save_data.store_var(coins)
	save_data.store_var(level_datas)
	save_data.close()







func load_file():
	var load_save = File.new()
	if load_save.file_exists(save_file):
		load_save.open(save_file,File.READ)
		unlocked_levels = load_save.get_var()
		complated_levels = load_save.get_var()
		current_level = load_save.get_var()
		coins = load_save.get_var()
		level_datas = load_save.get_var()
		load_save.close()
		

