extends CanvasLayer

var best_score = 0;
func _ready():
	best_score = SceneSwitcher.get_param("best_score", 0);
	if not best_score:
		best_score = 0;
	$VBoxContainer/BestScore.text = "Best Score: " + str(best_score);

func _on_quit_button_up():
	get_tree().quit();

func _on_try_again_button_up():
	SceneSwitcher.change_scene("res://scenes/main.tscn", {"use_game_data": true });
