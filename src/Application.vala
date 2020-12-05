public class Application : Gtk.Application {

	PGallery.FolderWindow window; 

	// Thumbnails manager
	private PGallery.ThumbnailsManager thumbnails_manager = new PGallery.ThumbnailsManager ();
	
	private PGallery.Utils utils = new PGallery.Utils ();

	public Application () {
		Object (
			application_id: "com.github.joancipria.pgallery",
			flags: ApplicationFlags.FLAGS_NONE
		);
	}

	protected override void activate () {
		window = new PGallery.FolderWindow (this);

		// Load custom styles
		style_provider();

		thumbnails_manager.scan_pictures_folder.begin((obj, res) => {
			stdout.printf ("Finished scanning Pictures directory\n");
			thumbnails_manager.generate_thumbnails();
			create_grid();
		});

		add_window (window);
	}

	private void style_provider () {
		var css_provider = new Gtk.CssProvider ();

		// TODO: Load css provicer from external file
		//css_provider.load_from_resource (path);
		css_provider.load_from_data(".thumbnail { border: none; padding: 0; }");

		Gtk.StyleContext.add_provider_for_screen (
			Gdk.Screen.get_default (),
			css_provider,
			Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
		);
	}

	private void create_grid(){
		stdout.printf ("Creating grid ... \n");
		int counter = 0;

		// For each found file
		int row = 0;
		int column = 0;

		foreach (PGallery.Thumbnail thumb in thumbnails_manager.get_thumbnails()) {
	
			// Attach thumbnail to grid
			window.grid.attach (thumb.button, column, row, 1, 1);

			// Increase counter
			counter++;
			column++;
			if(column == 3){
				column = 0;
				row++;
			}
			
		}
		stdout.printf ("Finished creating grid\n");
	}
}
