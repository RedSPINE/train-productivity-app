extends Resource
class_name Config

const SAVE_GAME_PATH := "user://gamesave.tres"


## The time elapsed between each train's passing.
@export_range(0,50,1,"suffix:loops") var loops_for_pause: int = 5
## The time elapsed between each train's passing.
@export_range(0,60*60,1.0,"suffix:s") var loop_duration: float = 60*5
## The time to pass pefore the train can resume.
@export_range(0,60*60,1.0,"suffix:s") var pause_duration: float = 60*5
## Height of the train in pixels
@export_range(0,100,1,"suffix:pixels") var window_height: int = 32


func save_to_file() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)


func load_save() -> Config:
	if not ResourceLoader.exists(SAVE_GAME_PATH):
		save_to_file()
	return load(SAVE_GAME_PATH)
