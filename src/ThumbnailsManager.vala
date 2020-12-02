public class PGallery.ThumbnailsManager
{
    private PGallery.Utils utils = new PGallery.Utils ();

    // User's Pictures folder
    public string pictures_folder = Environment.get_home_dir ()+"/Pictures/";

    public string thumbnails_folder = Environment.get_home_dir ()+"/.cache/thumbnails/large/";

    // Scanned / detected images
    private string[] scanned_images = {};

    private PGallery.Thumbnail[] thumbnails = {};


    public ThumbnailsManager(){
       
    }

    public void generate_thumbnails(){

         // Create a thumb for each found image
        foreach (string filename in scanned_images) {

             // Get / create thumbnail
            Gdk.Pixbuf pix = new Gdk.Pixbuf.from_file ("/home/joan/default.png");
            PGallery.Thumbnail thumb = new PGallery.Thumbnail(pix, filename);

            // Add to list
            thumbnails += thumb;
        }
    } 

    // Scans Pictures folder looking for image files 
    public async void scan_pictures_folder () {
    
        stdout.printf ("Start scanning Pictures directory\n");

        // Get user's Pictures folder
        File dir = File.new_for_path (Environment.get_home_dir ()+"/Pictures");
        

        try {
            // Asynchronous call, to get directory entries
            var e = yield dir.enumerate_children_async (FileAttribute.STANDARD_NAME,
                                                        0, Priority.DEFAULT);
            while (true) {
                // Asynchronous call, to get entries so far
                var files = yield e.next_files_async (10, Priority.DEFAULT);
                
                if (files == null) {
                    break;
                }
    
                // For each found file
                foreach (var info in files) {

                    // Get file name
                    string filename = info.get_name ();

                    // Check if is an image
                    if (".jpg" in filename || ".png" in filename || ".jpeg" in filename || ".gif" in filename ) {						
                        // Push file to scanned images
                        scanned_images += filename;
                    }
                }
            }
        } catch (Error err) {
            stderr.printf ("Error: scan_pictures_folder failed: %s\n", err.message);
        }
    }

    public string[] get_scanned_images(){
        return scanned_images;
    }

    public PGallery.Thumbnail[] get_thumbnails(){
        return thumbnails;
    }
}