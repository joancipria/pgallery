public class Application : Gtk.Application {

	PGallery.Window window; 

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
		window = new PGallery.Window (this);

		thumbnails_manager.scan_pictures_folder.begin((obj, res) => {
			stdout.printf ("Finished scanning Pictures directory\n");
			thumbnails_manager.generate_thumbnails();
			create_grid();
		});

		add_window (window);
	}

	private void create_grid(){
		int counter = 0;

		// For each found file
		int row = 0;
		int column = 0;

		foreach (PGallery.Thumbnail thumb in thumbnails_manager.get_thumbnails()) {

			// Click event
			Gtk.EventBox eventbox = new Gtk.EventBox();
			eventbox.button_press_event.connect( ()=>{ 
				show_image(thumb.thumb_name); // Show image on click
				return false; 
			});
			eventbox.add(thumb.image);
		
			// Attach grid
			window.grid.attach (eventbox, column, row, 1, 1);
			thumb.image.show();
			eventbox.show();	


			// Increase counter
			counter++;
			column++;
			if(column == 3){
				column = 0;
				row++;
			}
			
		}
	}

	// Create a dialog showing the selected image
	public void show_image (string filename) {
		string image_path = thumbnails_manager.pictures_folder+filename;
		PGallery.ImageViewer dialog = new PGallery.ImageViewer (this, image_path);
	}
}
