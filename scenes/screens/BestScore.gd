extends Label

var best_score := 0;

signal on_new_best_score(new_best_score: int);

func _ready():
	GameSaver.game_loaded.connect(func(game_state):
		best_score = game_state.get("best_score") or best_score;
	);

	EventBus.lost.connect(func(score):
		if score > best_score:
			_on_new_best_score(score);
	);

func _on_new_best_score(new_best_score: int) -> void:
	best_score = new_best_score;
	EventBus.on_new_best_score.emit(best_score);

	text = str("Best Score: " + str(best_score));

	GameSaver.game_state["best_score"] = best_score;
	GameSaver.save_game();
