extends CanvasLayer

var best_score: int = 0;

@onready var lock = $CenterContainer/SubViewportContainer/SubViewport/lock;

func show_game_over_screen(score: int):
	$TryAgain.set_scores(score, best_score)
	$TryAgain.show();

func load_game():
	var use_game_data = SceneSwitcher.get_param("use_game_data", false);

	if use_game_data:
		var game_state = GameSaver.load_game();
		if game_state.has("best_score"):
			best_score = GameSaver.game_state.best_score;

func _ready():
	load_game();

func _on_lose(score: int):
	if score > best_score:
		best_score = score;
		GameSaver.game_state = {
			"best_score": best_score,
		};
		GameSaver.save_game();

	show_game_over_screen(score);


func _on_try_again_clicked():
	lock.reset();
	$TryAgain.hide();
