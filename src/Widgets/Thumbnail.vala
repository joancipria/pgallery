public class PGallery.Thumbnail
{
    private PGallery.Utils utils = new PGallery.Utils ();
    private PGallery.ThumbnailsManager thumbnails_manager = new PGallery.ThumbnailsManager ();

    // Thumb pix and name
    public Gdk.Pixbuf thumb_picture;
    public string thumb_name;
    public string md5_name;
    public string image_path;

    // Thumb Gtk image (rendered image)
	public Gtk.Image image = new Gtk.Image ();		


    public Thumbnail(string file_name){
        // Default thumb icon (to show while generating thumbnail)
        thumb_picture = new Gdk.Pixbuf.from_file ("/home/joan/default.png");
        image.set_from_pixbuf (thumb_picture);

        // Set filename
        thumb_name = file_name;

        // Image file path
        image_path = thumbnails_manager.pictures_folder+thumb_name;


        // Check if there is already a generated thumbnail
        // Get MD5 of file
        try {
            md5_name = utils.get_md5(image_path);
        }
        catch (Error err){
            stderr.printf ("Error: failed to get file_md5 in scan_thumbnails(): %s\n", err.message);
        }

        // Check if thumb exists in cache
        try {
            // Try getting thumbnail from system cache
            thumb_picture = new Gdk.Pixbuf.from_file (thumbnails_manager.thumbnails_folder+md5_name+".png");
            image.set_from_pixbuf (thumb_picture);
        }
        catch {
            // In case of fail, generate own thumbnail (async)
            generate_thumbnail.begin();
        }

    }

    // Generates a thumbnail from the original image
    public async void generate_thumbnail(){
        print("%s\n", "Generating "+image_path);

        GLib.Idle.add(this.generate_thumbnail.callback);
        yield;
        
        // Get original image
        Gdk.Pixbuf pix = new Gdk.Pixbuf.from_file (image_path);

        // Scale to 120 width
        pix = utils.scale_image(pix,120, Gdk.InterpType.NEAREST);

        // Update thumbnail
        thumb_picture = pix;
        image.set_from_pixbuf (thumb_picture);
        print("%s\n", "Done!");

        // Save to disk
		string cache_folder = Environment.get_home_dir ()+"/.cache/thumbnails/large/";
		pix.save(cache_folder+md5_name+".png", "png");
    }
}