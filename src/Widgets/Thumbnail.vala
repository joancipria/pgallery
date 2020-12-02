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
    public async void generate_thumbnail () {
        stdout.printf ("Generating thumb\n");
        // Get file
        GLib.File file = GLib.File.new_for_commandline_arg (image_path);

        try {
            // Async read image
            GLib.InputStream stream = yield file.read_async ();
            Gdk.Pixbuf pixbuf = yield new Gdk.Pixbuf.from_stream_at_scale_async (stream, 120, -1, true);
            
            // Update thumb
            thumb_picture = pixbuf;
            image.set_from_pixbuf (pixbuf);

            // Save to disk
            string cache_folder = Environment.get_home_dir ()+"/.cache/thumbnails/large/";
            pixbuf.save(cache_folder+md5_name+".png", "png");
        
        } catch ( GLib.Error e ) {
          GLib.error (e.message);
        }
      }
}