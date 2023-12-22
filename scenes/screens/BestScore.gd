extends Label

const GLOBAL_LEADERBOARD = "CgkIofn98oIOEAIQAw";

var best_score: int = 0:
	set(new_best_score):
		best_score = new_best_score;
		text = "Best score: " + str(best_score);

signal on_new_best_score(new_best_score: int);

func _ready():
	best_score = 0;
	_connect_game_save_state_best_score();
	_connect_leaderboard_best_score();

func _connect_game_save_state_best_score():
	var set_best_score_gs = func(game_state: Dictionary):
		var saved_best = game_state.get("best_score");
		if saved_best > best_score:
			best_score = saved_best;
			EventBus.on_new_best_score.emit(best_score);

	set_best_score_gs.call(GameSaver.game_state);
	GameSaver.game_loaded.connect(set_best_score_gs);

	EventBus.lost.connect(func(score):
		if score > best_score:
			_on_new_best_score(score);
	);

# Load top score from leaderboard and save
func _connect_leaderboard_best_score():
	LeaderboardsClient.score_loaded.connect(func(leaderboard_id, score):
		var leaderboard_score: int = score.raw_score;
		if leaderboard_id != GLOBAL_LEADERBOARD:
			return;
		if leaderboard_score > best_score:
			best_score = leaderboard_score;
			EventBus.on_new_best_score.emit(best_score);
			_persist_best_score();
	);

	LeaderboardsClient.load_player_score(
		GLOBAL_LEADERBOARD,
		LeaderboardsClient.TimeSpan.TIME_SPAN_ALL_TIME,
		LeaderboardsClient.Collection.COLLECTION_PUBLIC,
	)

func _persist_best_score():
	GameSaver.game_state["best_score"] = best_score;
	GameSaver.save_game();

func _on_new_best_score(new_best_score: int) -> void:
	best_score = new_best_score;
	EventBus.on_new_best_score.emit(best_score);

	_persist_best_score();

	LeaderboardsClient.submit_score(GLOBAL_LEADERBOARD, best_score);
