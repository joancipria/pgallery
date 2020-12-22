public class PGallery.ThumbnailsManager
{
    // User's Pictures folder
    public string pictures_folder = Environment.get_home_dir ()+"/Pictures/";

    public string thumbnails_folder = Environment.get_home_dir ()+"/.cache/thumbnails/large/";

    // Scanned / detected images
    private List<FileInfo> scanned_images = new List<FileInfo> ();

    private PGallery.Thumbnail[] thumbnails = {};


    public ThumbnailsManager(){
        // Check thumbs folder
        // Create file object for cache folder
        GLib.File cache_folder_file = File.new_for_path (thumbnails_folder);

        // Check if cache folder exists
        if (cache_folder_file.query_exists ()) {
            // If file object exist, check if it is a folder
            if (!(cache_folder_file.query_file_type (0) == FileType.DIRECTORY)){
                create_directory(cache_folder_file);
            }
        }else{
            create_directory(cache_folder_file);
        }
    }

    public void generate_thumbnails(){
        stdout.printf ("Start generating thumbnails\n");
         // Create a thumb for each found image
        foreach (FileInfo file in scanned_images) {

             // Get / create thumbnail
            PGallery.Thumbnail thumb = new PGallery.Thumbnail(file.get_name ());

            // Add to list
            thumbnails += thumb;
        }
        stdout.printf ("Finished generating thumbnails\n");

    } 

    // Scans Pictures folder looking for image files 
    public async void scan_pictures_folder () {
    
        stdout.printf ("Start scanning Pictures directory\n");

        // Get user's Pictures folder
        File dir = File.new_for_path (Environment.get_home_dir ()+"/Pictures");
        

        try {
            // Asynchronous call, to get directory entries
            var e = yield dir.enumerate_children_async (FileAttribute.TIME_MODIFIED,
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
                        scanned_images.append(info);
                    }
                }
            }

        } catch (Error err) {
            stderr.printf ("Error: scan_pictures_folder failed: %s\n", err.message);
        }

        // Sort images by modification time
        scanned_images.sort(compare_modification_time);
    }

    // Creates a directory from a given GLib.File
	public void create_directory(GLib.File folder){
		try{
			folder.make_directory();
		}catch ( GLib.Error e ) {
			GLib.error (e.message);
		}
    }
    
    // Sort by modification time function
    private CompareFunc<FileInfo> compare_modification_time = (a, b) => {
        int64 c = a.get_modification_date_time().to_unix ();
        int64 d = b.get_modification_date_time().to_unix ();
        return (int) (c > d) - (int) (c < d);
    };
    

    public PGallery.Thumbnail[] get_thumbnails(){
        return thumbnails;
    }
}