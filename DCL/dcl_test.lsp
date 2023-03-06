(defun c:test(/ dcl_id)
  (if
    (findfile "test.dcl")
    (setq dcl_id (load_dialog "test.dcl"))
    (exit)
  )
  (if 
    (not
      (new_dialog "test_dialog" dcl_id)
    )
    (exit)
  )
  ;---------------------타일 시작 --------------------
  
  (action_tile "accept" "(done_dialog)")
  (action_tile "f1"
    "(done_dialog)(princ \"Hello~\")"
  )
  
  ;---------------------타일 끝 --------------------
  
  (start_dialog)
  (unload_dialog dcl_id)
  (princ)
)