extends Node

signal game_loaded(game_state: Dictionary);

var game_state := {};
const _save_file_location := "user://savegame.save";

func _ready() -> void:
	load_game();


func save_game() -> void:
	var save_file: FileAccess = FileAccess.open(_save_file_location, FileAccess.WRITE);
	var game_state_string: String = JSON.stringify(game_state);
	print_debug("Saving game %s" % game_state_string);
	save_file.store_string(game_state_string);


func load_game() -> Dictionary:
	if not FileAccess.file_exists(_save_file_location):
		print_debug("No save file")
		return {};

	var save_file: FileAccess = FileAccess.open(_save_file_location, FileAccess.READ);
	var game_state_json_string: String = save_file.get_as_text();
	print("save game text %s" % game_state_json_string);

	var saved_game_state: Variant = JSON.parse_string(game_state_json_string);
	if not saved_game_state:
		print_debug("Error reading game state");
		game_loaded.emit({});
		return {};

	game_state = saved_game_state;
	print('game loaded %s' % game_state)
	game_loaded.emit(saved_game_state);

	return game_state;
