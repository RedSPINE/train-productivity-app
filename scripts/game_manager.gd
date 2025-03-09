extends Node2D
class_name GameManager


@export var conf: Config

@export_group("Setup")
@export var settings_scene: PackedScene
@export var light: TrainLight
@export var train: Train

var settings_window: SettingsWindow
var is_pause: bool = false
var pause_timer: float = .0
var loop_count: int = 0
var loop_timer: float = .0


## Called after everything is instantiated.
func _ready() -> void:
	# Setup internal var
	if conf and OS.has_feature("editor"):
		pass
	else:
		_update_values()
	loop_timer = conf.loop_duration
	loop_count = -1 # first passing doesn't count towards loop
	# Plug signals
	Events.settings_changed.connect(_update_values)
	Events.train_passing_finished.connect(_on_train_finished)
	Events.train_paused.connect(_on_train_paused)
	Events.train_resumed.connect(_on_train_resumed)
	Events.light_button_pressed.connect(_on_light_pressed)


## Called every physical frame.
func _physics_process(delta) -> void:
	# Update internal counter
	if not is_pause:
		loop_timer += delta
	elif pause_timer < conf.pause_duration and not train.can_resume:
		pause_timer += delta
		train.can_resume = pause_timer >= conf.pause_duration
		if train.can_resume:
			light.go()
			train.audiostream_ding.play()
			
	# Launch train if needed
	if loop_timer >= conf.loop_duration:
		loop_timer = 0
		loop_count += 1
		train.should_pause = loop_count >= conf.loops_for_pause
		_launch_passing()


## Called in _physics_process when it's time to pass the train.
func _launch_passing() -> void:
	if not train.should_pause: light.go()
	else:
		light.stop()
		train.can_resume = false
	train.start_passing()


## Called when the train has finished passing.
func _on_train_finished() -> void:
	light.idle()


## Called when the train has finished passing.
func _on_train_paused() -> void:
	is_pause = true
	loop_count = 0
	pause_timer = .0


func _on_train_resumed() -> void:
	is_pause = false
	light.go()


func _on_light_pressed() -> void:
	open_settings()


func open_settings() -> void:
	if is_instance_valid(settings_window):
		return
	settings_window = settings_scene.instantiate() as SettingsWindow
	add_child(settings_window)


func _update_values() -> void:
	conf = Config.new().load_save()
