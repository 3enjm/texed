class_name Canvas
extends Node2D

@export var fg_colour := Color.WHITE : set = set_fg_colour
@export var canvas_mode: EditMode = EditMode.SPRITE_EDIT

@onready var brush: Node2D = $Brush
@onready var fg_tile_map_layer: TileMapLayer = $FGTileMapLayer
@onready var active_tile_map: TileMapLayer = fg_tile_map_layer

enum PaintMode {
	NONE,
	PAINT,
	ERASE
}

enum EditMode {
	SPRITE_EDIT,
	ROOM_EDIT
}

var is_mouse_btn_held := false
var paint_mode: PaintMode = PaintMode.NONE

func _ready() -> void:
	var default_pos := get_viewport_rect().get_center()
	#TODO: Put the brush in a default position
	brush.position = active_tile_map.map_to_local(active_tile_map.local_to_map(default_pos))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: 
		var mpos := get_global_mouse_position()
		var tile_cellv := active_tile_map.local_to_map(to_local(mpos))
		brush.position = active_tile_map.map_to_local(tile_cellv)
		if paint_mode == PaintMode.PAINT:
			paint_tile(tile_cellv)
		elif paint_mode == PaintMode.ERASE:
			erase_tile(tile_cellv)
			
	if event is InputEventMouseButton:
		if event.is_released():
			is_mouse_btn_held = false
			paint_mode = PaintMode.NONE
		else:
			is_mouse_btn_held = true

		var selected_cellv = active_tile_map.local_to_map(brush.position)
		if event.is_action_pressed("paint"):
			paint_tile(selected_cellv)
			paint_mode = PaintMode.PAINT
		if event.is_action_pressed("erase"):
			erase_tile(selected_cellv)
			paint_mode = PaintMode.ERASE

func paint_tile(cellv: Vector2i) -> void:
	active_tile_map.set_cell(cellv, 1, Vector2.ZERO)

func erase_tile(cellv: Vector2i) -> void:
	active_tile_map.erase_cell(cellv)

func set_fg_colour(colour: Color) -> void:
	fg_colour = colour
	active_tile_map.modulate = colour
