public class PGallery.Thumbnail
{
    private PGallery.Utils utils = new PGallery.Utils ();
    private PGallery.ThumbnailsManager thumbnails_manager = new PGallery.ThumbnailsManager ();

    // Thumb pix and name
    public Gdk.Pixbuf thumb_picture;
    public string thumb_name;

    // Thumb Gtk image (rendered image)
	public Gtk.Image image = new Gtk.Image ();		



    public Thumbnail(Gdk.Pixbuf pix, string name){
        thumb_picture = pix;
        thumb_name = name;

        // Set default thumbnail image
        image.set_from_pixbuf (pix);

        // Load thumb
        load_thumb(name);
    }

    // Looks for the thumb in system cache or creates a new one
    public void load_thumb(string name){
        
        // Get MD5 of file
        string file_md5 = "";
        try {
            file_md5 = utils.get_md5(thumbnails_manager.pictures_folder+name);
        }
        catch (Error err){
            stderr.printf ("Error: failed to get file_md5 in scan_thumbnails(): %s\n", err.message);
        }

        // Check if thumb exists in cache
        try {
            // Try getting thumbnail from system cache
            thumb_picture = new Gdk.Pixbuf.from_file (thumbnails_manager.thumbnails_folder+file_md5+".png");
            image.set_from_pixbuf (thumb_picture);
        }
        catch {
            // In case of fail, generate own thumbnail (async)
            generate_thumbnail.begin(thumbnails_manager.pictures_folder+name,(obj, res)=>{
                // On finished, render thumb
                thumb_picture =generate_thumbnail.end(res);
                image.set_from_pixbuf (thumb_picture);
            });
        }
    }

    // Generates a Pixbuf thumbnail of the given image
	private async Gdk.Pixbuf generate_thumbnail(string image_path){
		stdout.printf ("Generating thumbnail ... Please wait\n");
		// Reade image file
		Gdk.Pixbuf pix = new Gdk.Pixbuf.from_file (image_path);

		// Scale image
		pix = utils.scale_image(pix,120, Gdk.InterpType.NEAREST);

		// Folders
		string cache_folder = Environment.get_home_dir ()+"/.cache/thumbnails/large/";
		string file_name = utils.get_md5(image_path);

		// Save to disk
		pix.save(cache_folder+file_name+".png", "png");
		// Return thumbnail
		return pix;
	}
}