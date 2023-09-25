extends TileMap

class_name Grid

const CELLS = {
	"BLANK"   : Vector2i(0, 0),
	"X"       : Vector2i(1, 0),
	"OUTLINE" : Vector2i(2, 0),
	"GRASS"   : Vector2i(3, 0),
	"WATER"   : Vector2i(4, 0),
	"SAND"    : Vector2i(5, 0)
}

@export var columns = 8
@export var rows = 8

const TILE_SET_ID = 0
const DEFAULT_LAYER = 0

var placed_cells = []
var mouse_still_down = false
var placing_mode = null
func _input(event : InputEvent):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_layer(DEFAULT_LAYER)
	for i in rows:
		for j in columns:
			var cell_coord = Vector2(i - rows / 2, j - columns / 2)
			set_tile_cell(cell_coord, "BLANK")
			set_cell(1, cell_coord, TILE_SET_ID, CELLS["OUTLINE"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(1):
		var clicked_cell_coordinate = local_to_map(get_local_mouse_position())
		on_cell_clicked(clicked_cell_coordinate, 1)
	else:
		placing_mode = null
	if Input.is_mouse_button_pressed(2):
		var clicked_cell_coordinate = local_to_map(get_local_mouse_position())
		on_cell_clicked(clicked_cell_coordinate, 2)
	
func set_tile_cell(cell_coord, cell_type):
	set_cell(DEFAULT_LAYER, cell_coord, TILE_SET_ID, CELLS[cell_type])
	
func on_cell_clicked(cell_coord : Vector2i, button : int):
	#print(cell_coord)
	var tile_data = get_cell_tile_data(DEFAULT_LAYER, cell_coord)
	if tile_data == null:
		return
	if button == 1:
		if placed_cells.has(cell_coord) and placing_mode != "GRASS":
			placing_mode = "BLANK"
			set_tile_cell(cell_coord, "BLANK")
			placed_cells.erase(cell_coord)
		elif !placed_cells.has(cell_coord) and placing_mode != "BLANK":
			placing_mode = "GRASS"
			placed_cells.append(cell_coord)
			set_tile_cell(cell_coord, "GRASS")
	elif button == 2:
		set_tile_cell(cell_coord, "X")
	check_puzzle()

func check_puzzle():
	pass
