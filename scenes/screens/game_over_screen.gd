extends Control

signal try_again_clicked();

func _ready():
	GameSaver.game_loaded.connect(func(game_state):
		%BestScore.text = "Best Score: " + str(game_state.get("best_score") or 0);
	);

	EventBus.lost.connect(func(score):
		%Score.text = "Score: " + str(score);
	);

	EventBus.on_new_best_score.connect(func(new_best_score):
		%BestScore.text = "Best Score: " + str(new_best_score);
	);


func _on_try_again_button_up():
	try_again_clicked.emit();
