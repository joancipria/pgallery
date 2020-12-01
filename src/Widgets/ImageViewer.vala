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
		create_widgets (path);
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
	private void create_widgets (string imagePath) {

		Gtk.Image image = new Gtk.Image ();

		// Create a Pixbuf from imagePath
		renderedPix = new Gdk.Pixbuf.from_file (imagePath);

		// Scale image
		renderedPix = utils.scale_image(renderedPix,360, Gdk.InterpType.BILINEAR);

		// Set scaled image
		image.set_from_pixbuf (renderedPix);

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
