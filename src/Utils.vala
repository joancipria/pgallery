public class PGallery.Utils
{
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