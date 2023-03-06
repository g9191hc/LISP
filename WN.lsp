;라디안을 각도로 변경(라디안값[Number] => 각도[Real])
(defun rtd(ang) 
	(/ (* ang 180.0) PI)
)

(defun c:WN (/ ent entinfo pt1 pt2 centpt ang easyang textpt)
	
	(setq ent (car (entsel)))
	(setq entinfo (entget ent))
	(setq pt1 (cdr (assoc 10 entinfo)))
	(setq pt2 (cdr (assoc 11 entinfo)))

	;선의 중점 획득
	(setq centpt
		(list
			(/ (+ (car pt1) (car pt2)) 2)
			(/ (+ (cadr pt1) (cadr pt2)) 2)
		)
	)

	;선의 각도 획득
	(setq ang (angle pt1 pt2))
	(setq easyang (- (rem (+ ang (/ PI 2)) PI) (/ PI 2)))

	;각도가 연직일경우, 90도가 되도록(270도 X) 설정
	(if (= (rtos easyang 2 4) (rtos (/ PI -2) 2 4))
		(setq easyang (* easyang -1))
	)

	;텍스트가 생성될 위치 설정
	(setq textpt
		(list
			(- (car centpt) (* 50 (sin easyang)))
			(+ (cadr centpt) (* 50 (cos easyang)))
		)
	)

	; 벽체네임 레이어가 없을경우 추가
	(if (= nil (tblobjname "layer" "Z-MARK W"))
		(entmake
			(list
				(cons 0 "layer")
				(cons 100 "AcDbSymbolTableRecord")
				(cons 100 "AcDbLayerTableRecord")
				(cons 2 "Z-MARK W")
				(cons 70 0)
				(cons 62 3)
			)
		)
	)

	; 벽체레이어로 변경
	(setq sl (getvar "clayer"))
	(setq sc (getvar "cecolor"))
	(setvar "clayer" "Z-MARK W")
	(setvar "cecolor" "BYLAYER")


	(command "-text" "s" "Standard" "j" "bc" textpt "250" (rtd easyang))
	
	;(setvar "clayer" sl)
	;(setvar "cecolor" sc)
)
(initget "setView MoVe")(setq kw (getpoint))