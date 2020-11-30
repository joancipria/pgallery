public class PGallery.HeaderBar : Gtk.HeaderBar {
    
    public HeaderBar(PGallery.ViewImageWindow window) {
        title = "PGallery";
        //subtitle = "Viewing image";

        show_close_button = true;

        // Create back button
        Gtk.Button back_button = new Gtk.Button.from_icon_name("back");

        // Set suggested style
        back_button.get_style_context().add_class("suggested-action");

        // Vertically align button
        back_button.valign = Gtk.Align.CENTER;

        // On click, close window
        back_button.clicked.connect (() => {
			window.close();
		});

        // Add at start
        pack_start(back_button);        
    }
}
