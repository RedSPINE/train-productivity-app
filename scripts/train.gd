extends Node2D
class_name Train


## if [b]true[/b], the train will use the animationPlayer instead of physics.
@export var use_anim: bool = true
## The speed of the train when passing if using the animation.
@export_range(0,3,0.01,"suffix:ratio") var anim_speed: float = 1.0
## The speed of the train when passing.
@export_range(0,1000,1,"suffix:px/s") var speed: float = 1.0

@export_group("Setup")
@export var animation_player: AnimationPlayer
@export var button: Button
@export var audiostream_ding : AudioStreamPlayer2D
@export var audiostream_wheels : AudioStreamPlayer2D
@export var window_extend: WindowExtend

var target_speed: float
var current_speed: float
var length: int
var should_pause: bool = false
var can_resume: bool = false


func _ready() -> void:
	if use_anim:
		animation_player.animation_finished.connect(_on_passing_animation_finished)
	else:
		target_speed = speed
		length = window_extend.polygon[0].x
	
	button.pressed.connect(_on_button_pressed)
	button.disabled = true


func start_passing() -> void:
	if use_anim:
		animation_player.speed_scale = anim_speed
		animation_player.stop()
		animation_player.play("passing")
	else:
		global_position.x = -500
		target_speed = speed
		current_speed = target_speed
	
	audiostream_wheels.play()


func _physics_process(delta: float) -> void:
	if not use_anim:
		current_speed = lerpf(current_speed,target_speed,delta * 5)
		global_position.x += int(current_speed * delta)
		if global_position.x + length*2 > Events.window_length + 500:
			finish_passing()


func pause() -> void:
	if use_anim:
		animation_player.pause()
	else:
		target_speed = 0
		
	should_pause = false
	Events.train_paused.emit()
	button.disabled = false
	audiostream_ding.play()
	audiostream_wheels.stop()


func resume() -> void:
	if use_anim:
		animation_player.play()
	else:
		target_speed = speed
	Events.train_resumed.emit()
	button.disabled = true
	audiostream_wheels.play()


func _on_passing_animation_finished(anim_name: String) -> void:
	if anim_name == "passing":
		finish_passing()


func finish_passing() -> void:
		Events.train_passing_finished.emit()
		audiostream_wheels.stop()


func _on_light_reached() -> void:
	if should_pause:
		pause()


func _on_button_pressed():
	if can_resume:
		resume()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if use_anim: return
	if area.get_parent() is TrainLight and should_pause:
		pause()
