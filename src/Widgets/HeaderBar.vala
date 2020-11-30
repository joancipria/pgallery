public class PGallery.HeaderBar : Gtk.HeaderBar {

    public HeaderBar() {
        title = "PGallery";
        //subtitle = "Viewing image";

        show_close_button = true;
    }

    public void add_back_button (PGallery.ViewImageWindow window_reference){
        // Create back button
        Gtk.Button back_button = new Gtk.Button.from_icon_name("go-previous-symbolic");

        // Vertically align button
        back_button.valign = Gtk.Align.CENTER;

        // On click, close window
        back_button.clicked.connect (() => {
            window_reference.close();
        });

        // Add at start
        pack_start(back_button); 
    }

    public void add_settings_button (){
        // Create settings button
        Gtk.Button settings_button = new Gtk.Button.from_icon_name("settings");

        // Set suggested style
        settings_button.get_style_context().add_class("suggested-action");

        // Vertically align button
        settings_button.valign = Gtk.Align.CENTER;

        // On click, close window
        settings_button.clicked.connect (() => {
            //window_reference.close();
        });

        // Add at start
        pack_end(settings_button); 
    }
}
