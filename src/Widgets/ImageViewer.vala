public class PGallery.ImageViewer : Gtk.ApplicationWindow {

	// gsettings
	public GLib.Settings settings;
	private PGallery.Utils utils = new PGallery.Utils ();

	// Pix of the rendered image
	private Gdk.Pixbuf renderedPix;

	public ImageViewer (Application app, string path) {
		Object (
			application: app
		);

		// Create widgets
		create_widgets.begin(path);
	}

	construct {

	 	window_position = Gtk.WindowPosition.CENTER;
		set_default_size (360, 288); // Pinephone resolution
		 
	 	settings = new GLib.Settings ("com.github.joancipria.pgallery");

	 	//move (settings.get_int ("pos-x"), settings.get_int ("pos-y"));
	 	//resize (settings.get_int ("window-width"), settings.get_int ("window-height"));

	 	delete_event.connect (e => {
	 		return before_destroy ();
	 	});

		// Add header bar
		PGallery.HeaderBar headerbar = new PGallery.HeaderBar ();
		headerbar.add_back_button(this);
		set_titlebar (headerbar);
		
	 	show_all ();
	}

	// Create widgets (dialog content)
	private async void create_widgets (string image_path) {

		Gtk.Image image = new Gtk.Image ();

		GLib.File file = GLib.File.new_for_commandline_arg (image_path);

		try {
            // Async read image
            GLib.InputStream stream = yield file.read_async ();
            Gdk.Pixbuf pixbuf = yield new Gdk.Pixbuf.from_stream_at_scale_async (stream, 360, -1, true);
            
			// Set scaled image
			image.set_from_pixbuf (pixbuf);
        
        } catch ( GLib.Error e ) {
          GLib.error (e.message);
        }

		// Add image
		this.add(image);
		show_all ();
	}

	public bool before_destroy () {
		int width, height, x, y;

		get_size (out width, out height);
		get_position (out x, out y);

		settings.set_int ("pos-x", x);
		settings.set_int ("pos-y", y);
		settings.set_int ("window-width", width);
		settings.set_int ("window-height", height);

		return false;
	}
}
