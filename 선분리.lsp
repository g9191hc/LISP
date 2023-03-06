; 20230128
; made by 현철

; DV : 한 선을 다른 선을 기준으로 분리(DiVide)

;--------------------------------------
(defun c:DV ()
	(while T
		(divideLine)
	)
)


;-------------------------------------------------------------
;--------------------모듈--------------------------------------

; 선의 두 점 리스트를 반환(시작점, 끝점)
(defun getLinePoints (ent / entinfo)
	(setq entinfo (entget ent))
	(list
		(cdr (assoc 10 entinfo))
		(cdr (assoc 11 entinfo))
	)
)



; 두 점 리스트를 받아서, 두 점이 이루는 선이 늘어나는 방향으로, 각 점에서 dist만큼 떨어진 두 점의 좌표를 반환
(defun getOpsetPoints (ptlist dist / pt1 pt2 ang)
	(setq pt1 (car ptlist))
	(setq pt2 (cadr ptlist))
	(setq ang (angle pt1 pt2))
	(list
		(polar pt1 (+ ang PI) dist)
		(polar pt2 ang dist)
	)
)

; 두 선의 교차점 반환
(defun getLinesCrossPoint(ent1 ent2 / ent1info ent2info)
	(setq ent1info (entget ent1))
	(setq ent2info (entget ent2))
	(setq ent2info (getOpsetPoints (list (cdr (assoc 10 ent2info)) (cdr (assoc 11 ent2info))) 10000))
	(inters (cdr (assoc 10 ent1info)) (cdr (assoc 11 ent1info)) (car ent2info) (cadr ent2info))
)

; 객체네임 획득
(defun getEntName(message)
	(car (entsel message))
)

;선 객체인지 여부 반환
(defun isLine (ent / entinfo)
	(setq entinfo (entget ent))
	(if (= (strcase (cdr (assoc 0 entinfo))) "LINE") T nil)
)

;LW폴리선 객체인지 여부 반환
(defun isLWPolyline (ent / entinfo)
	(setq entinfo (entget ent))
	(if (= (strcase (cdr (assoc 0 entinfo))) "LWPOLYLINE") T nil)
)

;선 객체의 각도(라디안. 시작점->끝점) 획득
(defun getLineAngle(ent / entinfo)
	(setq entinfo (entget ent))
	(angle (cdr (assoc 10 entinfo)) (cdr (assoc 11 entinfo)))
)

;폴리선을 분해하고 폴리선 선택할 때 지정한 좌표에 있는 선 객체의 이름을 반환
(defun getExSelectedLine(entselv / ent entco)
	(setq ent (car entselv))
	(setq entco (cadr entselv))
	(princ "\n폴리선을 분해합니다.")
	(command "explode" ent)
	(ssname (ssget entco) 0)
)

;----------------------------------------------------------------------
;--------------------SubFunctions--------------------------------------


(defun divideLine (/ ent1 ent2 cpt ang brpt entselv)
	(setq entselv (entsel "\n분리할 선(또는 폴리선)을 선택 해 주세요.(폴리선은 선으로 분해됩니다.)"))
	(setq ent1 (car entselv))
	(if (isLWPolyline ent1)			
		(setq ent1 (getExSelectedLine entselv))
	)
	(if (= nil (isLine ent1))
		(princ "\n선이 아닙니다. 선 객체를 선택 해 주세요.")
		(progn
			(setq entselv (entsel "\n기준선(또는 폴리선)을 선택 해 주세요.(폴리선은 선으로 분해됩니다.)"))
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
	(princ "\n선이 분리되었습니다.")
	(princ)
)