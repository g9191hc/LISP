; 20230116
; made by ��ö

; ---- ��ü(�⺻�� : ���ؼ� �߾ӿ��� ��η� 50 ����� ����) ----
; WW : W1 ���� (Wall Name)
; CW : CW1 ����
; EW : EW1 ����
; W0 : W0 ����
; W0A : W0A ����
; PW2 : PW2 ����(���������� ���� - �⺻��(����))
; NW10 : NW10 ����
; NW12 : NW12 ����

; ---- ��Ÿ���� ----
; BN : AB0 ���� (Beam Name) (���������� ���� - �⺻��(��������))
; SN : AS1(�⺻)/SS1/ARS1/PHS1/PHRS1 ���� (Slab Name)






; (memberNameCreate �Է��Һ������ ������ӻ��� �������ũ�� ������ӹ��� �����Һ��緹�̾��̸� �����Һ��緹�̾����)
;---------------��ü--------------------
(defun c:WW ()
	(while T
		(memberNameCreate "W1" "bylayer" 250 "up" "Z-MARK W" 3)
	)
)

(defun c:CW ()
	(while T
		(memberNameCreate "CW1" 1 250 "up" "Z-MARK W" 3)
	)
)

(defun c:EW ()
	(while T
		(memberNameCreate "EW1" 4 250 "up" "Z-MARK W" 3)
	)
)

(defun c:W0 ()
	(while T
		(memberNameCreate "W0" 5 250 "up" "Z-MARK W" 3)
	)
)

(defun c:W0A ()
	(while T
		(memberNameCreate "W0A" 183 250 "up" "Z-MARK W" 3)
	)
)

(defun c:PW2 ()
	(while T
		(memberNameCreate "PW2" 6 250 "up" "Z-MARK W" 3)
	)
)

(defun c:NW10 ()
	(while T
		(memberNameCreate "NW10" "bylayer" 200 "up" "Z-MARK NW" 134)
	)
)

(defun c:NW12 ()
	(while T
		(memberNameCreate "NW12" "bylayer" 200 "up" "Z-MARK NW" 134)
	)
)



;---------------��/�Ŵ�--------------------
(defun c:BN ()
	(while T
		(memberNameCreate "AB0" "bylayer" 250 "down" "Z-MARK B" 6)
	)
)

;---------------�����--------------------
(defun c:SN ()
	(while T
		(memberNameCreate "AS1" "bylayer" 200 "center" "Z-MARK S" 231)
	)
)


;-------------------------------------------------------------
;--------------------���--------------------------------------


;�� ��ǥ�� ���� ��ġ�ϴ���(�� ��ǥ�� �����ΰ� ��ġ�ϴ���) ���θ� ��ȯ
(defun isSameIntegerCoordinate (pt1 pt2)
	(if (and (= (fix (car pt1)) (fix (car pt2))) (= (fix (cadr pt1)) (fix (cadr pt2))))
	T
	nil
	)
)



(defun betterAngle (radi)
	(- (rem (+ radi (/ PI 2)) PI) (/ PI 2))
)

(defun orthoLeft (radi)
	(if (= radi (/ PI -2))
		(* radi -1)
		radi
	)
)

;betterAngle�� orthoLeft ��� �ʿ�
(defun modiAngle (radi)
	(orthoLeft (betterAngle radi))
)

;�� ���� ���� ȹ�� : (��ǥ, ��ǥ) => (��ǥ)
(defun centPoint (pt1 pt2)
	(list
		(/ (+ (car pt1) (car pt2)) 2)
		(/ (+ (cadr pt1) (cadr pt2)) 2)
	)
)

;���̾� ����
(defun layerMake(layerName layerColor)	
	;���� �̸��� ���̾ ������츸 ����
	(if (= nil (tblobjname "layer" layerName))
		(entmake
			(list
				(cons 0 "layer")
				(cons 100 "AcDbSymbolTableRecord")
				(cons 100 "AcDbLayerTableRecord")
				(cons 2 layerName)
				(cons 70 0)
				(cons 62 layerColor)
			)
		)
	)
)

;�������� ����
(defun makeLWPolyline (ptList closedFlag col / dxfList)
	(if (= (type col) 'STR)
		(if (= (strcase col) "BYLAYER")
			(setq col 256)
			(setq col 0)
		)
	)
	(setq dxflist (list
		(cons 0 "lwpolyline")
		(cons 90 (length ptList)) ;�� ����
		(cons 70 closedFlag) ;���� ����
		(cons 62 col)
		)
	)
	(while (car ptList)
		(setq dxfList (append dxfList (list (cons 10 (car ptList)))))
		(setq ptList (cdr ptList))
	)
	(entmake dxflist)
	
	(entlast)
)

;�ؽ�Ʈ ����
(defun makeText (pt hei radi txt col)
	(if (= (type col) 'STR)
		(if (= (strcase col) "BYLAYER")
			(setq col 256)
			(setq col 0)
		)
	)
	(entmake (list
		(cons 0 "text")
		(cons 1 txt) ;�Է¹��� 
		(cons 40 hei) ;���ڳ��� 
		(cons 50 radi) ;����
		(cons 10 pt) ;��(��ġ)
		(cons 62 col)
		)
	)
	(entlast)
)

;Ÿ�� ����
(defun makeEllipse (pt lr rr col)
	(if (= (type col) 'STR)
		(if (= (strcase col) "BYLAYER")
			(setq col 256)
			(setq col 0)
		)
	)
	(entmake (list
		(cons 0 "ELLIPSE") 
		(cons 100 "AcDbEntity")
		(cons 100 "AcDbEllipse")
		(cons 10 pt) ;������ġ
		(list 11 lr 0.0 0.0) ;���������
		(cons 40 rr) ;����������
		(cons 62 col)
		)
	)
	(entlast)
)

;�ؽ�Ʈ ������ ����
(defun textMove2nd(ent hpos vpos / entinfo) 
	(setq entinfo (entget ent))
	(setq entinfo (subst (cons 72 hpos) (assoc 72 entinfo) entinfo)) ; �������Ĺ�ĺ���
	(setq entinfo (subst (cons 73 vpos) (assoc 73 entinfo) entinfo)) ; �������Ĺ�ĺ���
	(setq entinfo (subst (cons 11 (cdr (assoc 10 entinfo))) (assoc 11 entinfo) entinfo)) ; ���������� ��ǥ�� ������ �����ϴ���ǥ�� ����
	(entmod entinfo) ;��ü�� �ݿ�(�̵�)
	ent
)

; ��ü�� ���̾� ����
(defun changeLayer(ent layerName / entinfo) 
	(setq entinfo (entget ent))
	(entmod (subst (cons 8 layerName) (assoc 8 entinfo) entinfo)) ;
	ent
)

; ��ü�� ���� ����
(defun changeColor(ent col / entinfo)
	(if (= (type col) 'STR)
		(if (= (strcase col) "BYLAYER")
			(setq col 256)
			(setq col 0)
		)
	)
	(setq entinfo (entget ent))
	(if (assoc 62 entinfo)
		(progn
			(setq entinfo (vl-remove (assoc 420 entinfo) entinfo))
			(setq entinfo (subst (cons 62 col) (assoc 62 entinfo) entinfo))
		)
		(setq entinfo (cons (cons 62 col) entinfo))
	)
	(entmod entinfo)
	ent
)

;----------------------------------------------------------------------
;--------------------SubFunctions--------------------------------------

(defun memberNameCreate (memName textCol textHei textDir layName layCol)
	(if (= (strcase textDir) "CENTER")
		(slabNameCreate memName textCol textHei textDir layname layCol)
		(wallBeamNameCreate memName textCol textHei textDir layname layCol)
	)
	(princ)
)

(defun wallBeamNameCreate (memName textCol textHei textDir layName layCol / ent entinfo pt1 pt2 ang kw inpt1 inpt2 vpt1 vpt2 cpt textpt newMem)
	(setq ent (car (entsel (strcat "\n������ ������ ���� 50�� ��� ����� \"" memName "\"�� �����մϴ�. ���ؼ��� ���� �� �ּ���"))))
	(setq entinfo (entget ent))
	(setq pt1 (cdr (assoc 10 entinfo)))
	(setq pt2 (cdr (assoc 11 entinfo)))
	(setq ang (modiAngle (angle pt1 pt2)))
	
	(if (= (strcase textDir) "DOWN")
		(progn
			(initget "2 U 2u u2")
			(setq kw (getkword (strcat "\n�Ʒ��ʿ� ���ӻ���(�⺻��) / ���ʿ� ���ӻ���(U) / ���ؼ���� ���̸������� 2������(2) / ȥ�ջ�밡�� <�⺻��> : ")))
		)
		(progn
			(initget "2 D 2d d2")
			(setq kw (getkword (strcat "\n���ʿ� ���ӻ���(�⺻��) / �Ʒ��ʿ� ���ӻ���(D) / ���ؼ���� ���̸������� 2������(2) / ȥ�ջ�밡�� <�⺻��> : ")))
		)
	)
	
	(if kw (progn
		(if (wcmatch kw "*2*")
			(progn
				;�� ��(pt1, pt2)�� ���ؼ����� �����, ���ؼ����� �� ���� �������ǽ�Ų �� �� ������ �����
				;���ؼ��� �������� ��ų �� ���� ����
				(setq inpt1 (getpoint "\n ù ��° ���� �Է��ϼ���."))
				(setq inpt2 (getpoint "\n �� ��° ���� �Է��ϼ���."))
				
				;������ ���� ���� �� ���� ����
				(setq vpt1 (polar pt1 (+ ang PI) 100000))
				(setq vpt2 (polar pt1 ang 100000))
				
				;�� ������ ���ؼ��� ������������ ������ ���� �����ϴ� ���� ȹ��
				(setq pt1 (inters vpt1 vpt2 (polar inpt1 (+ ang (/ PI 2)) -100000) (polar inpt1 (+ ang (/ PI 2)) 100000)))
				(setq pt2 (inters vpt1 vpt2 (polar inpt2 (+ ang (/ PI 2)) -100000) (polar inpt2 (+ ang (/ PI 2)) 100000)))
			)
		)
		(if (wcmatch (strcase kw) "*D*") (setq textDir "down"))
		(if (wcmatch (strcase kw) "*U*") (setq textDir "up"))
		)
	)

	(setq cpt (centPoint pt1 pt2)) ; ���� ȹ��

	;�ؽ�Ʈ�� ������ ��ġ ����
	(if (= (strcase textDir) "DOWN")
		(setq textpt (polar cpt (- ang (/ PI 2)) 50))
		(setq textpt (polar cpt (+ ang (/ PI 2)) 50))
	)
	
	; ������ ��������� ���̾ ������� �߰�
	(layerMake layName layCol)


	; ������� ����
	(setq newMem (makeText textpt textHei ang memName textCol))
	
	; ������� ���̾� ����
	(changeLayer newMem layName)
	
	; ������� ������ ����
	(if (= (strcase textDir) "DOWN")
		(textMove2nd newMem 1 3)
		(textMove2nd newMem 1 1)
	)
	
	; PW2�� ��� ������ �߰�
	(if (= (strcase memName) "PW2")
		(progn
			(initget "No")
			(setq kw (getkword (strcat "\n������������ �߰��Ͻðڽ��ϱ�? ��(�⺻��), �ƴϿ�(N) <�⺻��> : ")))
			(if (not kw)
				(makeSubLine pt1 pt2 textDir)
			)
					
		)
	)
	; AB0�� ��� ������ �߰�
	(if (= (strcase memName) "AB0")
		(progn
			(initget "Yes")
			(setq kw (getkword (strcat "\n������������ �߰��Ͻðڽ��ϱ�? �ƴϿ�(�⺻��), ��(Y) <�⺻��> : ")))
			(if kw
				(makeSubLine pt1 pt2 textDir)
			)
					
		)
	)
	
			
)

(defun slabNameCreate (memName textCol textHei textDir layName layCol / kw textpt newName newEllipse)

	(setq textpt (getpoint "\n����� ������ ������ ��ġ�� ���� �� �ּ���.")) ; �ؽ�Ʈ�� ������ ��ġ
	(initget "Ss1 aRs1 Phs1 PhRs1")(setq kw (getkword "\n����� \"AS1\"����(�⺻��) / \"SS1\"����(S) / \"ARS1\"����(R) / \"PHS1\"����(P) / \"PHRS1\"����(PR) <�⺻��> : "))
	(cond
		((= kw "Ss1")(setq memName "SS1"))
		((= kw "aRs1")(setq memName "ARS1"))
		((= kw "Phs1")(setq memName "PHS1"))
		((= kw "PhRs1")(setq memName "PHRS1"))
		(T (setq memName "AS1"))
	)
	
	; ������ ��������� ���̾ ������� �߰�
	(layerMake layName layCol)
	
	; ������� ����
	(setq newName (makeText textpt textHei 0 memName textCol))
	
	; ������� ������ ����
	(textMove2nd newName 4 0)
	
	; ���� ������ Ÿ������
	(setq newEllipse (makeEllipse textpt 536 0.4235 "bylayer"))
	
	; ��������� ���̾� ����
	(changeLayer newName layName)
	(changeLayer newEllipse layName)
)

; pt1�� pt2�κ��� dir�������� 200��� ���������� ����(������ �߽����κ��� 
(defun makeSubLine (pt1 pt2 dir / ang len tempt diagpt1 diagpt2 cent)
	(setq ang (modiAngle (angle pt1 pt2)))
	(setq len (distance pt1 pt2))
	
	;���� �������� �� ���� �մ� ���� ������ pt1�̸� pt1�� ���������� ����
	(if (isSameIntegerCoordinate pt1 (polar pt2 ang len))
		(progn
			(setq tempt pt1)
			(setq pt1 pt2)
			(setq pt2 tempt)
		)
	)
	
	(if (< (distance pt1 pt2) 1060)
		(princ "\n���̰� �ʹ� ª�Ƽ� ������������ ������ �� �����ϴ�.")
		(progn
			(if (= (strcase dir) "DOWN")
				(progn
					(setq diagpt1 (polar pt1 (- ang (/ PI 4.0)) (sqrt 80000)))
					(setq diagpt2 (polar pt2 (- ang (* 3.0 (/ PI 4.0))) (sqrt 80000)))
				)
				(progn
					(setq diagpt1 (polar pt1 (+ ang (/ PI 4.0)) (sqrt 80000)))
					(setq diagpt2 (polar pt2 (+ ang (* 3.0 (/ PI 4.0))) (sqrt 80000)))
				)
			)
			(setq cutpt1 (polar diagpt1 ang (- (/ len 2) 200 330)))
			(setq cutpt2 (polar diagpt2 (+ ang PI) (- (/ len 2) 200 330)))
			
			(makeLWPolyline (list pt1 diagpt1 cutpt1) 0 1) 
			(makeLWPolyline (list pt2 diagpt2 cutpt2) 0 1)
		)
	)
)