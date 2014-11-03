using Gtk;
using Gee;

namespace de.sinnix.vala
{
	class MerleProgramm : Window
	{
		
		private Grid grid;
		private Image[] images = {};
		private string[] imageFiles = {};
		private Set<int> usedImageFiles = new HashSet<int>();

		public MerleProgramm ()
		{	
			this.title = "Merle-Bespassungs-Programm";
		    this.set_default_size (300, 50);
		    this.maximize();
		    this.set_hide_titlebar_when_maximized(false);
		    //window.position = WindowPosition.CENTER;
		    this.destroy.connect (Gtk.main_quit);
		    this.key_press_event.connect (onKey);
		    this.button_press_event.connect (onButton);
		    this.set_border_width(20);
		    this.grid = new Grid();
 			this.grid.set_column_spacing(70);
 			this.grid.set_row_spacing(70);
 			
 			var scroll = new ScrolledWindow (null, null);
 			scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        	scroll.add (this.grid);
        	this.add(scroll);
			
			this.imageFiles = getFileNames(".jpg");
			foreach(string f in imageFiles) {
				Image image = new Image();
				image.set_from_file(f);
				images += image;
			};
			randomizeImages();
			paintGrid();
			

			this.fullscreen();
		}

		private void paintGrid() {
			int count = 0;
			for (var i = 1; i <= 4; i++)
			{
				for (var j = 1; j <= 3; j++) 
				{
					this.grid.attach(this.images[count], i-1,j-1,1,1);
					count++;
				}
			}
		}

		private void randomizeImages() 
		{
			this.usedImageFiles = null;
			this.usedImageFiles = new HashSet<int>();
			for (var i = 0; i < images.length; i++) 
			{
				this.images[i].clear();
		    	this.images[i].set_from_file(getRandomImageFile());
				
			}
		}

		private string getRandomImageFile() 
		{
			int i = Random.int_range (0, images.length);			
			if (i in usedImageFiles) 
			{
				return getRandomImageFile();
			}
			else 
			{
				usedImageFiles.add(i);
				return imageFiles[i];
			}
		}

		private string[] getFileNames(string suffix) 
		{
			string[] filenames = {};
			try {
	        	var directory = File.new_for_path (".");
				//directory = File.new_for_commandline_arg (suffix);
	        	var enumerator = directory.enumerate_children (FileAttribute.STANDARD_NAME, 0);

	        	FileInfo file_info;
	        	while ((file_info = enumerator.next_file ()) != null) {
	            	if (file_info.get_name()[-3:-1] == "jp") {
	            		filenames += file_info.get_name ();
	            	}
	        	}

		    } catch (Error e) {
		        stderr.printf ("Error: %s\n", e.message);
		    }
		    return filenames;
		}

		private bool onButton(Gdk.EventButton event)
		{        
		    randomizeImages();
		    return true;
		}		

		private bool onKey(Gdk.EventKey event)
		{        
		    randomizeImages();
		    return true;
		}

		public static int main (string[] args) 
		{

			Gtk.init(ref args);
			
			var window = new MerleProgramm();
			window.show_all();

			Gtk.main();
			return 0;
		}
	}
}
