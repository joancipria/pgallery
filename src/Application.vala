public class Application : Gtk.Application {

	// Pictures scanner
	private PGallery.Scan scanner = new PGallery.Scan ();
	
	private PGallery.Utils utils = new PGallery.Utils ();

	public Application () {
		Object (
			application_id: "com.github.joancipria.pgallery",
			flags: ApplicationFlags.FLAGS_NONE
		);
	}

	protected override void activate () {

		PGallery.Window window = new PGallery.Window (this);

		scanner.scan_pictures_folder.begin((obj, res) => {
			stdout.printf ("Finished scanning Pictures directory\n");
			create_grid(window);
		});

		add_window (window);
	}

	private void create_grid(PGallery.Window window){
		int counter = 0;

		// For each found file
		int row = 0;
		int column = 0;

		foreach (string filename in scanner.get_scanned_images()) {

			// Get file name
			string imagePath = scanner.pictures_folder+filename;

			// Check if is an image
			if (".jpg" in filename || ".png" in filename || ".jpeg" in filename || ".gif" in filename ) {						
				
				Gtk.Image image = new Gtk.Image ();
				
				// Create a Pixbuf from imagePath
				Gdk.Pixbuf pix = new Gdk.Pixbuf.from_file (imagePath);

				// Scale image to 240px (3 x 120 = 360)
				pix = utils.scale_image(pix,120, Gdk.InterpType.NEAREST);
				
				// Crop image 
				//pix = new Gdk.Pixbuf.subpixbuf(pix,0,0,240,240);

				// Set scaled image
				image.set_from_pixbuf (pix);

				// Click event
				Gtk.EventBox eventbox = new Gtk.EventBox();
				eventbox.button_press_event.connect( ()=>{ 
					show_image(filename); // Show image on click
					return false; 
				});
				eventbox.add(image);
			
				// Attach grid
				window.grid.attach (eventbox, column, row, 1, 1);
				image.show();
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
	}

	// Create a dialog showing the selected image
	public void show_image (string filename) {
		PGallery.ViewImageWindow dialog = new PGallery.ViewImageWindow (this, scanner.pictures_folder+filename);
	}
}
