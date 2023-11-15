extends Node

var game_state = {};

const _save_file_location = "user://savegame.save";

func save_game():
	var save_file = FileAccess.open(_save_file_location, FileAccess.WRITE);
	var game_state_string = JSON.stringify(game_state);
	save_file.store_string(game_state_string);

func load_game():
	if not FileAccess.file_exists(_save_file_location):
		print_debug("No save file")
		return {};

	var save_file = FileAccess.open(_save_file_location, FileAccess.READ);
	var game_state_json_string = save_file.get_as_text();

	var saved_game_state = JSON.parse_string(game_state_json_string);
	if not saved_game_state:
		print_debug("Error reading game state");
		return {};

	game_state = saved_game_state;
	return game_state;
