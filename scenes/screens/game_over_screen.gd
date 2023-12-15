extends Control

signal try_again_clicked(with_extra_life: bool);


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

	Ads.on_reward_failed_to_earn.connect(func():
		DebugUI.log("Reward Failed to Earn");
		try_again_clicked.emit(false);
		Ads.load(Ads.AdType.RewardedInterstitial);
	);

	Ads.on_reward_earned.connect(func(type: String, amount: int):
		DebugUI.log("Reward Earned %s %s" % [type, amount]);
		try_again_clicked.emit(true);
		Ads.load(Ads.AdType.RewardedInterstitial);
	);


func _on_try_again_button_up():
	try_again_clicked.emit(false);
	DebugUI.log("Try again clicked");
	%TryAgainExtraLife.show();

func _on_extra_life_try_again():
	DebugUI.log("Extra life try again");
	if Utils.is_mobile():
		Ads.show(Ads.AdType.RewardedInterstitial);
	else:
		try_again_clicked.emit(true);

	%TryAgainExtraLife.hide();
