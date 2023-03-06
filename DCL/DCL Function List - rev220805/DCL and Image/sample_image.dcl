sample_image
: dialog {
label = "image sample";
     : row {
          : image {height = 1;width = 2;color = 1;} : image {height = 1;width = 2;color = 2;}
          : image {height = 1;width = 2;color = 3;} : image {height = 1;width = 2;color = 4;} : image {height = 1;width = 2;color = 5;}
     }
     : row {
          : image {height = 1;width = 2;color = red;} : image {height = 1;width = 2;color = yellow;}
          : image {height = 1;width = 2;color = green;} : image {height = 1;width = 2;color = cyan;} : image {height = 1;width = 2;color = blue;}
     }
     : row {
          : image {height = 1;width = 2;color = dialog_line;} : image {height = 1;width = 2;color = dialog_foreground;}
          : image {height = 1;width = 2;color = dialog_background;} : image {height = 1;width = 2;color = graphics_background;}
          : image {height = 1;width = 2;color = graphics_foreground;}
     }
     : row {
          : image {height = 1;width = 2;color = 0;} : image {height = 1;width = 2;color = black;}
          : image {height = 1;width = 2;color = 7;} : image {height = 1;width = 2;color = white;}
          : image {height = 1;width = 2;color = magenta;}
     }
     ok_cancel;
}