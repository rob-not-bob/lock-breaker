extends Control

signal try_again_clicked();


func _ready():
	GameSaver.game_loaded.connect(func(game_state):
		%BestScore.text = "Best Score: " + str(game_state.get("best_score") or 1);
	);

	EventBus.lost.connect(func(score):
		%Score.text = "Score: " + str(score);
	);

	EventBus.on_new_best_score.connect(func(new_best_score):
		%BestScore.text = "Best Score: " + str(new_best_score);
	);


func _on_try_again_button_up():
	try_again_clicked.emit();
	DebugUI.log("Try again clicked");
	%TryAgainExtraLife.show();

func _on_extra_life_try_again():
	DebugUI.log("Extra life try again");
	if Utils.is_mobile():
		Ads.show(Ads.AdType.RewardedInterstitial);
	else:
		if OS.is_debug_build():
			Ads.on_reward_earned.emit("lives", 1);
		else:
			Ads.on_reward_failed_to_earn.emit();

	%TryAgainExtraLife.hide();
