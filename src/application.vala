namespace SoloWay {
	public class Application : Gtk.Application {
		private MainWindow win;

		public Application(string[] args) {
			Object(application_id: "home.dvaganov.soloway");
			PlayerGst.init(args);
		}
		protected override void activate() {
			Settings.init();
			// create_playlist
			var playlist = PlayGList.get_instance();
			playlist.open(Settings.get_param("playlist_path"));
			create_actions();
			var menu = new GLib.Menu();
			//menu.append("Change State", "app.change-state");
			menu.append("Quit", "app.quit");
			app_menu = menu;

			MainWindow.init(this);
			win = MainWindow.get_instance();
			win.on_row_activate.connect((uri) => {
				var player = PlayerGst.get_instance();
				if (player.change_uri(uri)) {
					player.play();
				} else {
					player.stop();
				}
			});
			PlayerGst.get_instance().state_changed.connect(win.change_btn_state_to_play);
			PlayerGst.get_instance().info_changed.connect(win.change_panel_info);
			add_window(win);

			win.show_all();
		}
		private void create_actions() {
			var action = new SimpleAction("next-entry", null);
			action.activate.connect(() =>
			{
				win.activate_next_row();
			});
			add_action(action);
			action = new SimpleAction("prev-entry", null);
			action.activate.connect(() =>
			{
				win.activate_prev_row();
			});
			add_action(action);
			action = new SimpleAction("quit", null);
			action.activate.connect(this.quit);
			add_action(action);
		}
		public static int main(string[] args) {
			var app = new Application(args);
			return app.run(args);
		}
	}
}
