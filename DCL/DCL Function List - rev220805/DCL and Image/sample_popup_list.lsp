(defun c:test(/ dcl_id)
     (setq dcl_id (load_dialog "sample_popup_list.dcl"))
     (if (not (new_dialog "sample_popup_list" dcl_id))
          (progn
               (princ "\nCannot find sample_popup_list.dcl")
               (exit)
          )
     )
     (setq popup_list_lst (list "Test_1" "Test_2" "Test_3"))
     (start_list "option_list")
     (mapcar 'add_list popup_list_lst)
     (end_list)
     (action_tile "accept" "(done_dialog)")
     (action_tile "cancel" "(done_dialog)")
     (start_dialog)
     (unload_dialog dcl_id)
)
