(defun c:BB()
  (setq ent1 (ssget))
  (command "draworder" ent1 "" "b")
)


(defun c:FF()
  (setq ent1 (ssget))
  (command "draworder" ent1 "" "f")
)