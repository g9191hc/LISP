sample_boxed_radio_column
: dialog {
label = "boxed_radio_column sample" ;
     :boxed_radio_column {
     label = "Radio buttons";
          : radio_button { key = "radio1"; label = "Radio1"; }
          : radio_button { key = "radio2"; label = "Radio2"; value = "1"; }
          : radio_button { key = "radio3"; label = "Radio3"; }
     }
     ok_cancel;
}