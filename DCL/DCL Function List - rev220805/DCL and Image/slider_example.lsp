(defun C:lisp48m ()
;define function	

  (setq lngth 50.0)
  ;preset slot length

  (setq dcl_id (load_dialog "lisp48m.dcl"))
  ;load dialog

  (if (not (new_dialog "lisp48m" dcl_id)
  ;test for dialog

      );not

    (exit)
    ;exit if no dialog

  );if

  (set_tile "eb1" "50")
  ;put data into edit box

  (mode_tile "eb1" 2)
  ;switch focus to edit box

  (action_tile "myslider"
  ;if user moves slider

	 "(slider_action $value $reason)")
         ;pass arguments to slider_action

  (action_tile "eb1"
  ;if user enters slot length

	 "(ebox_action $value $reason)")
         ;pass arguments to ebox_action

  (defun slider_action (val why)
  ;define function

      (if (or (= why 2) (= why 1))
      ;check values

      (set_tile "eb1" val)))
      ;update edit box

  (defun ebox_action (val why)
  ;define function

      (if (or (= why 2) (= why 1))
      ;check values

      (set_tile "myslider" val)))
      ;update slider

  (action_tile
    "accept"
    ;if O.K. pressed

    (strcat	
    ;string 'em together

      "(progn 

      (setq lngth (get_tile \"eb1\"))"
      ;get slot length

      "(done_dialog)(setq userclick T))"
      ;close dialog, set flag

    );strcat

  );action tile

    (action_tile
    "cancel"
    ;if cancel button pressed

    "(done_dialog) (setq userclick nil)"	
    ;close dialog

    );action_tile

  (start_dialog)	
  ;start dialog
				
  (unload_dialog dcl_id)
  ;unload	

   (if userclick
   ;check O.K. was selected

      (alert (strcat "You Selected: " lngth))			
      ;display the selected length.

  );if userclick

 (princ)

);defun
