extends Node2D
class_name Train


## The speed of the train when passing.
@export_range(0,3,0.01,"suffix:ratio") var speed: float = 100

@export_group("Setup")
@export var animation_player: AnimationPlayer
@export var button: Button
@export var audiostream_ding : AudioStreamPlayer2D
@export var audiostream_wheels : AudioStreamPlayer2D


var should_pause: bool = false
var can_resume: bool = false


func _ready() -> void:
	animation_player.animation_finished.connect(_on_passing_animation_finished)
	button.pressed.connect(_on_button_pressed)
	button.disabled = true


func start_passing() -> void:
	animation_player.speed_scale = speed
	animation_player.stop()
	animation_player.play("passing")
	audiostream_wheels.play()


func pause() -> void:
	animation_player.pause()
	Events.train_paused.emit()
	button.disabled = false
	audiostream_ding.play()
	audiostream_wheels.stop()


func resume() -> void:
	animation_player.play()
	Events.train_resumed.emit()
	button.disabled = true
	audiostream_wheels.play()


func _on_passing_animation_finished(anim_name: String) -> void:
	if anim_name == "passing":
		Events.train_passing_finished.emit()
		audiostream_wheels.stop()


func _on_light_reached() -> void:
	if should_pause:
		pause()
		should_pause = false


func _on_button_pressed():
	if can_resume:
		resume()
