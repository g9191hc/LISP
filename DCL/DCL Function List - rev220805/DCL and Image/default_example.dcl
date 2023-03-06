default_example
: dialog {
label = "default_example";
initial_focus = "bt2";
     : button {
     label = "Yellow";
     action = "(entmake (list (cons 0 \"LINE\") (list 10 0 0 0) (list 11 100 100 0)))";
     key = "bt1";
     }
     : button {
     label = "RED";
     action = "(entmake (list (cons 0 \"LINE\") (list 10 0 100 0) (list 11 100 0 0)))";
     key = "bt2";
     }
     : button {
     label = "Black";
     action = "(entmake (list (cons 0 \"LINE\") (list 10 0 50 0) (list 11 50 50 0)))";
     key = "bt3";
     }
     ok_cancel;
}