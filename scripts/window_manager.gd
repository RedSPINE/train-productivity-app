extends Node
class_name WindowMananger



const WINDOW_SIZE = 32
@onready var game_manager = $".."
var collision_shapes: Array[WindowExtend] = []


## Called after everything is instantiated.
func _ready() -> void:
	adjust_window_height(Events.config.window_height)
	Events.height_changed.connect(adjust_window_height)
	for child in get_tree().root.get_children(true):
		_recursive_get_polygon_children(child)


func adjust_window_height(value: int) -> void:
	var prim_index = DisplayServer.get_primary_screen()
	get_window().position.y = DisplayServer.screen_get_size(prim_index).y\
	 - WINDOW_SIZE\
	 - value


func _recursive_get_polygon_children(node: Node) -> void:
	if node is WindowExtend:
		collision_shapes.append(node)
	for child in node.get_children(true):
		_recursive_get_polygon_children(child)


## Called every physical frame.
func _physics_process(_delta) -> void:
	var click_polygon: PackedVector2Array = []
	var min_x: int = 9999
	var max_x: int = -9999
	var min_y: int = 9999
	var max_y: int = -9999
	# iterate over collision shapes
	for i in collision_shapes.size():
		var col = collision_shapes[i]
		if col.disabled:
			continue
		var vectors: PackedVector2Array = col.polygon
		for vector in vectors:
			var adjusted = col.to_global(vector)
			if min_x == 9999 or adjusted.x < min_x:
				min_x = adjusted.x
			if max_x == -9999 or adjusted.x > max_x:
				max_x = adjusted.x
			if min_y == 9999 or adjusted.y < min_y:
				min_y = adjusted.y
			if max_y == -9999 or adjusted.y > max_y:
				max_y = adjusted.y
	# create and apply click_polygon
	click_polygon.append(Vector2i(min_x, min_y))
	click_polygon.append(Vector2i(max_x, min_y))
	click_polygon.append(Vector2i(max_x, max_y))
	click_polygon.append(Vector2i(min_x, max_y))
	get_window().mouse_passthrough_polygon = click_polygon
