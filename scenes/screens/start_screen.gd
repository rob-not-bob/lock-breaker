extends Screen

signal start_button_clicked();
signal credit_button_clicked();

func _ready():
	%ViewLeaderboard.hide();

func on_screen_enter() -> void:
	if GlobalState.is_signed_in_google_play:
		%ViewLeaderboard.show();
	else:
		%ViewLeaderboard.hide();

func _on_start_button_up():
	start_button_clicked.emit();


func _on_credits_button_up():
	credit_button_clicked.emit();


func _on_view_leaderboard_button_up():
	LeaderboardsClient.show_all_leaderboards();
