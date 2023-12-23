extends Screen

signal try_again_clicked();


func on_screen_enter() -> void:
	if GlobalState.is_signed_in_google_play:
		%ViewLeaderboard.show();
	else:
		%ViewLeaderboard.hide();

	if GlobalState.allow_extra_life and Ads.is_loaded(Ads.AdType.RewardedInterstitial):
		%TryAgainExtraLife.show();
	else:
		%TryAgainExtraLife.hide();


func _ready():
	_connect_scores();


func _connect_scores() -> void:
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


func _on_view_leaderboard_button_up():
	LeaderboardsClient.show_all_leaderboards();
