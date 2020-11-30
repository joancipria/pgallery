public class PGallery.Utils
{
    // Scales an image to the given width keeping aspect ratio
	public Gdk.Pixbuf scale_image(Gdk.Pixbuf pix,int width){
		
		// Get heigth for the target width
		int height = get_new_heigth(pix.get_width(),pix.get_height(), width);

		// Scale image using BILINEAR algorithm (use NEAREST for less quality & fastest)
		Gdk.Pixbuf rescaledImage = pix.scale_simple(width, height, NEAREST);
		return rescaledImage;
	}

	private int get_new_heigth(int oldWidth, int oldHeight, int newWidth){
		double aspectRatio = ( ((double) oldWidth) / oldHeight );

		int newHeight = (int)( newWidth / aspectRatio );

		return newHeight;
	}
}