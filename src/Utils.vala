public class PGallery.Utils
{
    // Scales an image to the given width keeping aspect ratio
	public Gdk.Pixbuf scale_image(Gdk.Pixbuf pix,int width, Gdk.InterpType mode){
		
		// Get heigth for the target width
		int height = get_new_heigth(pix.get_width(),pix.get_height(), width);

		// Scale image using BILINEAR algorithm (use NEAREST for less quality & fastest)
		Gdk.Pixbuf rescaledImage = pix.scale_simple(width, height, BILINEAR);
		return rescaledImage;
	}

	private int get_new_heigth(int oldWidth, int oldHeight, int newWidth){
		double aspectRatio = ( ((double) oldWidth) / oldHeight );

		int newHeight = (int)( newWidth / aspectRatio );

		return newHeight;
	}

	// Calculates the MD5 hash og the given image
	public string get_md5(string image_path){
		Checksum checksum = new Checksum (ChecksumType.MD5);

		FileStream stream = FileStream.open(image_path, "rb");

		uint8 fbuf[100];

		size_t size;

		while ((size = stream.read(fbuf)) > 0){
			checksum.update(fbuf,size);
		}
		
		unowned string file_md5 = checksum.get_string();
		//print("%s: %s\n", imagePath, file_md5);
		return file_md5;
	}
}