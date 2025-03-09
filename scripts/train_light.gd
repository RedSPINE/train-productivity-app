extends Node2D
class_name TrainLight

@export var animation_player: AnimationPlayer
@export var button: Button

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	Events.light_button_pressed.emit()

func idle() -> void:
	animation_player.play("idle")

func go() -> void:
	animation_player.play("go")

func stop() -> void:
	animation_player.play("stop")
