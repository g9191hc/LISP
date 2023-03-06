lisp48m : dialog {				//dialog name
          label = "slider" ;			//give it a label

        : edit_box {				//define edit box
         key = "eb1" ;				//give it a name
         label = "Slot &Length (O/All Slot)" ;	//give it a label
         edit_width = 6 ;			//6 characters only
        }					//end edit box

        : slider {				//define slider
        key = "myslider" ;			//give it a name
//        max_value = 100;			//upper value
//        min_value = 0;				//lower value
//        value = "50";				//initial value
        }					//end slider

        ok_cancel ;				//predefined OK/Cancel button

        }					//end dialog