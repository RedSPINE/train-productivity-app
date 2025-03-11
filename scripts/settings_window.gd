extends Window
class_name SettingsWindow


@export var loops_label: Label
@export var loops_slider: HSlider

@export var loop_time_label: Label
@export var loop_time_slider: HSlider

@export var preview_label: Label
var preview_base_text: String

@export var pause_time_label: Label
@export var pause_time_slider: HSlider

@export var window_height_label: Label
@export var window_height_slider: HSlider


## Called when everything is instantiated
func _ready():
	# Plug signals
	_reset_values()
	close_requested.connect(_on_close_requested)
	loops_slider.value_changed.connect(_on_slider_value_changed)
	loop_time_slider.value_changed.connect(_on_slider_value_changed)
	preview_base_text = preview_label.text
	pause_time_slider.value_changed.connect(_on_slider_value_changed)
	window_height_slider.value_changed.connect(_on_slider_value_changed)
	# Update
	_reset_values()
	_update()


func _reset_values() -> void:
	loops_slider.value = Events.config.loops_for_pause
	loop_time_slider.value = Events.config.loop_duration
	pause_time_slider.value = Events.config.pause_duration
	window_height_slider.value = Events.config.window_height
	Events.height_changed.emit(Events.config.window_height)


func _on_close_requested() -> void:
	close()


func _on_save_and_quit_pressed() -> void:
	Events.config.loops_for_pause = int(loops_slider.value)
	Events.config.loop_duration = loop_time_slider.value
	Events.config.pause_duration = pause_time_slider.value
	Events.config.window_height = int(window_height_slider.value)
	Events.config.save_to_file()
	Events.settings_changed.emit()
	close()


func close() -> void:
	queue_free()


func _on_slider_value_changed(_value: float) -> void:
	_update()


func _update() -> void:
	var loop_count = loops_slider.value as int
	loops_label.text = str(loop_count)
	# loop time
	var loop_duration = loop_time_slider.value
	loop_time_label.text = seconds_to_text(int(loop_duration))
	# preview
	var total_duration = loop_count * loop_duration
	preview_label.text = preview_base_text.replace("%l",str(loop_count)).replace("%d",seconds_to_text(loop_duration)).replace("%t", seconds_to_text(total_duration))
	# pause_time
	pause_time_label.text = seconds_to_text(int(pause_time_slider.value))
	
	var height_value = window_height_slider.value
	window_height_label.text = str(int(window_height_slider.value))+"px"
	Events.height_changed.emit(int(window_height_slider.value))


func _on_texture_button_pressed():
	_reset_values()


func seconds_to_text(seconds: int) -> String:
	## Compute time
	var hours: int = int(seconds)/3600
	seconds -= hours * 3600
	var minutes: int = int(seconds)/60
	seconds -= minutes * 60
	seconds = seconds % 60
	
	var time = ""
	## Write time
	if hours > 0:
		time += str(hours)+"h "
	if minutes > 0:
		time += str(minutes)+"min "
	if seconds > 0:
		time += str(seconds)+"s"
	
	return time
	
