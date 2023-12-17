extends Label

var best_score: int = 0:
	set(new_best_score):
		best_score = new_best_score;
		text = "Best score: " + str(best_score);

signal on_new_best_score(new_best_score: int);

func _ready():
	var set_best_score_gs = func(game_state: Dictionary):
		var saved_best = game_state.get("best_score");
		if saved_best:
			best_score = saved_best;
	set_best_score_gs.call(GameSaver.game_state);

	GameSaver.game_loaded.connect(set_best_score_gs);

	EventBus.lost.connect(func(score):
		if score > best_score:
			_on_new_best_score(score);
	);

func _on_new_best_score(new_best_score: int) -> void:
	best_score = new_best_score;
	EventBus.on_new_best_score.emit(best_score);

	GameSaver.game_state["best_score"] = best_score;
	GameSaver.save_game();
