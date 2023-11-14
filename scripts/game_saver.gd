extends Node

var game_state = {};

const _save_file = "user://savegame.save";

func save_game():
	var save_game = FileAccess.open(_save_file, FileAccess.WRITE);
	var game_state_string = JSON.stringify(game_state);
	save_game.store_string(game_state_string);
	printt("save_game", game_state_string);

func load_game():
	if not FileAccess.file_exists(_save_file):
		print_debug("No save file")
		return {};

	var load_game = FileAccess.open(_save_file, FileAccess.READ);
	var game_state_json_string = load_game.get_as_text();

	var saved_game_state = JSON.parse_string(game_state_json_string);
	if not saved_game_state:
		print_debug("Error reading game state");
		return {};

	game_state = saved_game_state;
	return game_state;
