sample_boxed_column
: dialog {
label = "boxed_column sample" ;
     :boxed_column {
     label = "Toggle buttons";
     height = 7;
          : toggle { key = "toggle1"; label = "Toggle1"; value = "1"; }
          : toggle { key = "toggle2"; label = "Toggle2"; value = "1"; }
          : toggle { key = "toggle3"; label = "Toggle3"; value = "0"; }
     }
     ok_cancel;
}