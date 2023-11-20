extends Control

signal try_again_clicked;

func set_scores(score: float, best_score: float):
	$VBoxContainer/BestScore.text = "Best Score: " + str(best_score);
	$VBoxContainer/Score.text = "Score: " + str(score);

func _on_try_again_button_up():
	try_again_clicked.emit();
