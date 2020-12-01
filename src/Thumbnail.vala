public class PGallery.Thumbnail
{
    public Gdk.Pixbuf thumb_picture;
    public string thumb_name;


    public Thumbnail(Gdk.Pixbuf pix, string name){
        thumb_picture = pix;
        thumb_name = name;
    }
}