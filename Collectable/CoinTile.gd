extends TileMap

var tile_indices = [1, 2, 3, 4, 5, 6] # Kullandığınız tile ID'lerini burada tanımlayın.
var current_tile_index = 0
var delay = 0.1 # Saniye cinsinden gecikme

func _ready():
	$delay_timer.wait_time = delay
	animate_used_tiles()

func animate_used_tiles():
	var used_cells = get_used_cells()
	for cell in used_cells:
		var x = cell.x
		var y = cell.y
		set_cell(x, y, tile_indices[current_tile_index])
	current_tile_index = (current_tile_index + 1) % (tile_indices.size()-1)
	$delay_timer.start()

func tile_collected(x,y):
	set_cell(x, y, -1)
	Globals.coins +=1
	get_parent().get_node("HUD").calculate_coin()
	pass


func _on_delay_timer_timeout():
	animate_used_tiles()
