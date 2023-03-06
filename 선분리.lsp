; 20230128
; made by ��ö

; DV : �� ���� �ٸ� ���� �������� �и�(DiVide)

;--------------------------------------
(defun c:DV ()
	(while T
		(divideLine)
	)
)


;-------------------------------------------------------------
;--------------------���--------------------------------------

; ���� �� �� ����Ʈ�� ��ȯ(������, ����)
(defun getLinePoints (ent / entinfo)
	(setq entinfo (entget ent))
	(list
		(cdr (assoc 10 entinfo))
		(cdr (assoc 11 entinfo))
	)
)



; �� �� ����Ʈ�� �޾Ƽ�, �� ���� �̷�� ���� �þ�� ��������, �� ������ dist��ŭ ������ �� ���� ��ǥ�� ��ȯ
(defun getOpsetPoints (ptlist dist / pt1 pt2 ang)
	(setq pt1 (car ptlist))
	(setq pt2 (cadr ptlist))
	(setq ang (angle pt1 pt2))
	(list
		(polar pt1 (+ ang PI) dist)
		(polar pt2 ang dist)
	)
)

; �� ���� ������ ��ȯ
(defun getLinesCrossPoint(ent1 ent2 / ent1info ent2info)
	(setq ent1info (entget ent1))
	(setq ent2info (entget ent2))
	(setq ent2info (getOpsetPoints (list (cdr (assoc 10 ent2info)) (cdr (assoc 11 ent2info))) 10000))
	(inters (cdr (assoc 10 ent1info)) (cdr (assoc 11 ent1info)) (car ent2info) (cadr ent2info))
)

; ��ü���� ȹ��
(defun getEntName(message)
	(car (entsel message))
)

;�� ��ü���� ���� ��ȯ
(defun isLine (ent / entinfo)
	(setq entinfo (entget ent))
	(if (= (strcase (cdr (assoc 0 entinfo))) "LINE") T nil)
)

;LW������ ��ü���� ���� ��ȯ
(defun isLWPolyline (ent / entinfo)
	(setq entinfo (entget ent))
	(if (= (strcase (cdr (assoc 0 entinfo))) "LWPOLYLINE") T nil)
)

;�� ��ü�� ����(����. ������->����) ȹ��
(defun getLineAngle(ent / entinfo)
	(setq entinfo (entget ent))
	(angle (cdr (assoc 10 entinfo)) (cdr (assoc 11 entinfo)))
)

;�������� �����ϰ� ������ ������ �� ������ ��ǥ�� �ִ� �� ��ü�� �̸��� ��ȯ
(defun getExSelectedLine(entselv / ent entco)
	(setq ent (car entselv))
	(setq entco (cadr entselv))
	(princ "\n�������� �����մϴ�.")
	(command "explode" ent)
	(ssname (ssget entco) 0)
)

;----------------------------------------------------------------------
;--------------------SubFunctions--------------------------------------


(defun divideLine (/ ent1 ent2 cpt ang brpt entselv)
	(setq entselv (entsel "\n�и��� ��(�Ǵ� ������)�� ���� �� �ּ���.(�������� ������ ���ص˴ϴ�.)"))
	(setq ent1 (car entselv))
	(if (isLWPolyline ent1)			
		(setq ent1 (getExSelectedLine entselv))
	)
	(if (= nil (isLine ent1))
		(princ "\n���� �ƴմϴ�. �� ��ü�� ���� �� �ּ���.")
		(progn
			(setq entselv (entsel "\n���ؼ�(�Ǵ� ������)�� ���� �� �ּ���.(�������� ������ ���ص˴ϴ�.)"))
			(setq ent2 (car entselv))
			(if (isLWPolyline ent2)			
				(setq ent2 (getExSelectedLine entselv))
			)
			(setq cpt (getLinesCrossPoint ent1 ent2))
			(setq ang (getLineAngle ent1))
			(setq brpt (polar cpt ang 0.1))
			(command "break" brpt cpt)
			;(command "extend" ent2 "" ent1 "")
			(setq entinfo (entget ent1))
			(entmod (subst (cons 10 cpt) (assoc 10 entinfo) entinfo))
		)
	)
	(princ "\n���� �и��Ǿ����ϴ�.")
	(princ)
)