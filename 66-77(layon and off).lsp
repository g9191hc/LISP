(defun c:66(/ ss laname lalist ladata)
	(prompt "\nSelect objects on the layer to be turned off")
	(setq ss (ssget))
	(foreach x (ssnamex ss)
		(if (= 'ename (type (cadr x)))
			(if (= nil (member (setq laname (cdr (assoc 8 (entget (cadr x))))) lalist))
				(setq lalist (cons laname lalist))
			)
		)
	)
	(foreach x lalist
		(setq ladata (entget (tblobjname "layer" x)))
		(entmod (subst (cons 62 (* -1 (cdr (assoc 62 ladata)))) (assoc 62 ladata) ladata))
	)
	(princ "\n꺼진 도면층	:	")
	(setq lastlalist lalist)
)


(defun c:77(/ colist ladata)
	(if lastlalist
		(foreach x lastlalist
			(setq colist (cons (if (< 0 (cdr (assoc 62 (entget (tblobjname "layer" x)))))
					        T
					        nil
					      )
		      			colist)
			)
		)
		(princ "\nUSE 11 COMMAND FIRST")
	)
	(if colist
		(if (member nil colist)
			(if (member T colist)
				(foreach x lastlalist
					(if (> 0 (cdr (assoc 62 (setq ladata (entget (tblobjname "layer" x))))))
						(entmod (subst (cons 62 (* -1 (cdr (assoc 62 ladata)))) (assoc 62 ladata) ladata))
					)
				)
				(foreach x lastlalist
					(setq ladata (entget (tblobjname "layer" x)))
					(entmod (subst (cons 62 (* -1 (cdr (assoc 62 ladata)))) (assoc 62 ladata) ladata))
				)
			)
			(foreach x lastlalist
				(setq ladata (entget (tblobjname "layer" x)))
				(entmod (subst (cons 62 (* -1 (cdr (assoc 62 ladata)))) (assoc 62 ladata) ladata))
			)
		)
	)
	(princ)
)


