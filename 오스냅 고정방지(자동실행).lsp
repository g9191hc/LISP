;오스넵 고정하기 ⓒ Kor_Storm 2013
(vl-load-com)
(defun sl-get-osmode (reactorObject Listofsomething) (setq *osmode* (getvar "osmode")))
(defun sl-set-osmode (reactorObject Listofsomething) (setvar "osmode" *osmode*))
(or *osmode* (setq *osmode* (getvar "osmode")))
(vlr-lisp-reactor nil '((:vlr-lispwillstart . sl-get-osmode)(:vlr-lispended . sl-set-osmode)(:vlr-lispcancelled . sl-set-osmode)))
(princ)