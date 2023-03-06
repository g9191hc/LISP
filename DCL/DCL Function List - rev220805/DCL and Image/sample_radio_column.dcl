sample_radio_column
: dialog {
label = "radio_column sample";
     : radio_column { children_fixed_width = true;children_alignment = right;
          : radio_button { label = "Red"; key = "bt1"; }
          : radio_button { label = "Yellow"; key = "bt2"; }
          : radio_button { label = "Green"; key = "bt3"; }
     }
     ok_cancel;
}
