;������ ������ ����(���Ȱ�[Number] => ����[Real])
(defun rtd(ang) 
	(/ (* ang 180.0) PI)
)

(defun c:WN (/ ent entinfo pt1 pt2 centpt ang easyang textpt)
	
	(setq ent (car (entsel)))
	(setq entinfo (entget ent))
	(setq pt1 (cdr (assoc 10 entinfo)))
	(setq pt2 (cdr (assoc 11 entinfo)))

	;���� ���� ȹ��
	(setq centpt
		(list
			(/ (+ (car pt1) (car pt2)) 2)
			(/ (+ (cadr pt1) (cadr pt2)) 2)
		)
	)

	;���� ���� ȹ��
	(setq ang (angle pt1 pt2))
	(setq easyang (- (rem (+ ang (/ PI 2)) PI) (/ PI 2)))

	;������ �����ϰ��, 90���� �ǵ���(270�� X) ����
	(if (= (rtos easyang 2 4) (rtos (/ PI -2) 2 4))
		(setq easyang (* easyang -1))
	)

	;�ؽ�Ʈ�� ������ ��ġ ����
	(setq textpt
		(list
			(- (car centpt) (* 50 (sin easyang)))
			(+ (cadr centpt) (* 50 (cos easyang)))
		)
	)

	; ��ü���� ���̾ ������� �߰�
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

	; ��ü���̾�� ����
	(setq sl (getvar "clayer"))
	(setq sc (getvar "cecolor"))
	(setvar "clayer" "Z-MARK W")
	(setvar "cecolor" "BYLAYER")


	(command "-text" "s" "Standard" "j" "bc" textpt "250" (rtd easyang))
	
	;(setvar "clayer" sl)
	;(setvar "cecolor" sc)
)
(initget "setView MoVe")(setq kw (getpoint))