tabs_example
: dialog {
label = "tabs_example";
     : list_box {
width = 50;
     list = "test\t1\t-\t2\t-\t3\nThis is test\t10\t-\t20\t-\t30\ntest\t100\t-\t200\t-\t300";
     tabs = "5";
     tab_truncate = true;
     }
     ok_cancel;
}