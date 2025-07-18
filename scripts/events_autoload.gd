extends Node
class_name EventsAutoload


var config: Config:
	get:
		if config == null:
			config = Config.new().load_save()
		return config

var window_length: int = 0

# Config
signal height_changed(new_value: int)
signal settings_changed
# Train
signal train_passing_finished
signal train_paused
signal train_resumed
# Light
signal light_button_pressed
# Other
signal window_adjusted
