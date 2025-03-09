extends Window
class_name SettingsWindow


@export var loops_label: Label
@export var loops_slider: HSlider
@export var loop_time_label: Label
@export var loop_time_slider: HSlider
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
	loops_label.text = str(loops_slider.value as int)
	# loop time
	var minutes: int = int(loop_time_slider.value)/60
	var seconds: int = int(loop_time_slider.value)%60
	var str_min = "" if minutes == 0 else str(minutes)+"min "
	var str_s = "" if seconds == 0 else str(seconds)+"s"
	loop_time_label.text = str_min + str_s
	# pause_time
	minutes = int(pause_time_slider.value)/60
	seconds = int(pause_time_slider.value)%60
	str_min = "" if minutes == 0 else str(minutes)+"min "
	str_s = "" if seconds == 0 else str(seconds)+"s"
	pause_time_label.text = str_min + str_s
	
	var height_value = window_height_slider.value
	window_height_label.text = str(int(window_height_slider.value))+"px"
	Events.height_changed.emit(int(window_height_slider.value))


func _on_texture_button_pressed():
	_reset_values()
