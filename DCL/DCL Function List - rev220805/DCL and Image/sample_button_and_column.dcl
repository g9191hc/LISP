sample_button_and_column
: dialog {
label = "button & column sample";
     : column {
     children_alignment = centered;
          : button { key = "button1"; label = "Center"; fixed_width = true; }
          : button { key = "button2"; label = "Left"; alignment = left; fixed_width = true; }
          : button { key = "button3"; label = "right"; alignment = right; fixed_width = true; }
     }
     ok_cancel;
}