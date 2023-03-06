; 20230116
; made by 현철

; ---- 벽체(기본값 : 기준선 중앙에서 상부로 50 띄워서 생성) ----
; WW : W1 생성 (Wall Name)
; CW : CW1 생성
; EW : EW1 생성
; W0 : W0 생성
; W0A : W0A 생성
; PW2 : PW2 생성(영역보조선 포함 - 기본값(생성))
; NW10 : NW10 생성
; NW12 : NW12 생성

; ---- 기타부재 ----
; BN : AB0 생성 (Beam Name) (영역보조선 포함 - 기본값(생성안함))
; SN : AS1(기본)/SS1/ARS1/PHS1/PHRS1 생성 (Slab Name)






; (memberNameCreate 입력할부재네임 부재네임색상 부재네임크기 부재네임방향 생성할부재레이어이름 생성할부재레이어색상)
;---------------벽체--------------------
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



;---------------빔/거더--------------------
(defun c:BN ()
	(while T
		(memberNameCreate "AB0" "bylayer" 250 "down" "Z-MARK B" 6)
	)
)

;---------------슬라브--------------------
(defun c:SN ()
	(while T
		(memberNameCreate "AS1" "bylayer" 200 "center" "Z-MARK S" 231)
	)
)


;-------------------------------------------------------------
;--------------------모듈--------------------------------------


;두 좌표가 거의 일치하는지(두 좌표의 정수부가 일치하는지) 여부를 반환
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

;betterAngle과 orthoLeft 모듈 필요
(defun modiAngle (radi)
	(orthoLeft (betterAngle radi))
)

;두 점의 중점 획득 : (좌표, 좌표) => (좌표)
(defun centPoint (pt1 pt2)
	(list
		(/ (+ (car pt1) (car pt2)) 2)
		(/ (+ (cadr pt1) (cadr pt2)) 2)
	)
)

;레이어 생성
(defun layerMake(layerName layerColor)	
	;같은 이름의 레이어가 없을경우만 생성
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

;폴리라인 생성
(defun makeLWPolyline (ptList closedFlag col / dxfList)
	(if (= (type col) 'STR)
		(if (= (strcase col) "BYLAYER")
			(setq col 256)
			(setq col 0)
		)
	)
	(setq dxflist (list
		(cons 0 "lwpolyline")
		(cons 90 (length ptList)) ;점 갯수
		(cons 70 closedFlag) ;닫힘 여부
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

;텍스트 생성
(defun makeText (pt hei radi txt col)
	(if (= (type col) 'STR)
		(if (= (strcase col) "BYLAYER")
			(setq col 256)
			(setq col 0)
		)
	)
	(entmake (list
		(cons 0 "text")
		(cons 1 txt) ;입력문자 
		(cons 40 hei) ;문자높이 
		(cons 50 radi) ;라디안
		(cons 10 pt) ;점(위치)
		(cons 62 col)
		)
	)
	(entlast)
)

;타원 생성
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
		(cons 10 pt) ;중점위치
		(list 11 lr 0.0 0.0) ;장축반지름
		(cons 40 rr) ;반지름비율
		(cons 62 col)
		)
	)
	(entlast)
)

;텍스트 정렬점 변경
(defun textMove2nd(ent hpos vpos / entinfo) 
	(setq entinfo (entget ent))
	(setq entinfo (subst (cons 72 hpos) (assoc 72 entinfo) entinfo)) ; 수평정렬방식변경
	(setq entinfo (subst (cons 73 vpos) (assoc 73 entinfo) entinfo)) ; 수직정렬방식변경
	(setq entinfo (subst (cons 11 (cdr (assoc 10 entinfo))) (assoc 11 entinfo) entinfo)) ; 새정렬점의 좌표를 문자의 좌측하단좌표로 변경
	(entmod entinfo) ;객체에 반영(이동)
	ent
)

; 객체의 레이어 변경
(defun changeLayer(ent layerName / entinfo) 
	(setq entinfo (entget ent))
	(entmod (subst (cons 8 layerName) (assoc 8 entinfo) entinfo)) ;
	ent
)

; 객체의 색상 변경
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
	(setq ent (car (entsel (strcat "\n선택한 선으로 부터 50을 띄워 부재명 \"" memName "\"을 생성합니다. 기준선을 선택 해 주세요"))))
	(setq entinfo (entget ent))
	(setq pt1 (cdr (assoc 10 entinfo)))
	(setq pt2 (cdr (assoc 11 entinfo)))
	(setq ang (modiAngle (angle pt1 pt2)))
	
	(if (= (strcase textDir) "DOWN")
		(progn
			(initget "2 U 2u u2")
			(setq kw (getkword (strcat "\n아랫쪽에 네임생성(기본값) / 윗쪽에 네임생성(U) / 기준선대신 길이를지정할 2점선택(2) / 혼합사용가능 <기본값> : ")))
		)
		(progn
			(initget "2 D 2d d2")
			(setq kw (getkword (strcat "\n윗쪽에 네임생성(기본값) / 아랫쪽에 네임생성(D) / 기준선대신 길이를지정할 2점선택(2) / 혼합사용가능 <기본값> : ")))
		)
	)
	
	(if kw (progn
		(if (wcmatch kw "*2*")
			(progn
				;두 점(pt1, pt2)과 기준선으로 띄울경우, 기준선으로 양 점을 프로젝션시킨 후 그 중점을 사용함
				;기준선에 프로젝션 시킬 두 점을 선택
				(setq inpt1 (getpoint "\n 첫 번째 점을 입력하세요."))
				(setq inpt2 (getpoint "\n 두 번째 점을 입력하세요."))
				
				;가상의 선을 위한 두 점을 생성
				(setq vpt1 (polar pt1 (+ ang PI) 100000))
				(setq vpt2 (polar pt1 ang 100000))
				
				;양 점에서 기준선의 직각방향으로 가상의 선과 교차하는 점을 획득
				(setq pt1 (inters vpt1 vpt2 (polar inpt1 (+ ang (/ PI 2)) -100000) (polar inpt1 (+ ang (/ PI 2)) 100000)))
				(setq pt2 (inters vpt1 vpt2 (polar inpt2 (+ ang (/ PI 2)) -100000) (polar inpt2 (+ ang (/ PI 2)) 100000)))
			)
		)
		(if (wcmatch (strcase kw) "*D*") (setq textDir "down"))
		(if (wcmatch (strcase kw) "*U*") (setq textDir "up"))
		)
	)

	(setq cpt (centPoint pt1 pt2)) ; 중점 획득

	;텍스트가 생성될 위치 설정
	(if (= (strcase textDir) "DOWN")
		(setq textpt (polar cpt (- ang (/ PI 2)) 50))
		(setq textpt (polar cpt (+ ang (/ PI 2)) 50))
	)
	
	; 생성할 부재네임의 레이어가 없을경우 추가
	(layerMake layName layCol)


	; 부재네임 생성
	(setq newMem (makeText textpt textHei ang memName textCol))
	
	; 부재네임 레이어 수정
	(changeLayer newMem layName)
	
	; 부재네임 정렬점 수정
	(if (= (strcase textDir) "DOWN")
		(textMove2nd newMem 1 3)
		(textMove2nd newMem 1 1)
	)
	
	; PW2일 경우 보조선 추가
	(if (= (strcase memName) "PW2")
		(progn
			(initget "No")
			(setq kw (getkword (strcat "\n영역보조선을 추가하시겠습니까? 네(기본값), 아니요(N) <기본값> : ")))
			(if (not kw)
				(makeSubLine pt1 pt2 textDir)
			)
					
		)
	)
	; AB0일 경우 보조선 추가
	(if (= (strcase memName) "AB0")
		(progn
			(initget "Yes")
			(setq kw (getkword (strcat "\n영역보조선을 추가하시겠습니까? 아니요(기본값), 네(Y) <기본값> : ")))
			(if kw
				(makeSubLine pt1 pt2 textDir)
			)
					
		)
	)
	
			
)

(defun slabNameCreate (memName textCol textHei textDir layName layCol / kw textpt newName newEllipse)

	(setq textpt (getpoint "\n슬라브 네임을 생성할 위치를 선택 해 주세요.")) ; 텍스트가 생성될 위치
	(initget "Ss1 aRs1 Phs1 PhRs1")(setq kw (getkword "\n부재명 \"AS1\"생성(기본값) / \"SS1\"생성(S) / \"ARS1\"생성(R) / \"PHS1\"생성(P) / \"PHRS1\"생성(PR) <기본값> : "))
	(cond
		((= kw "Ss1")(setq memName "SS1"))
		((= kw "aRs1")(setq memName "ARS1"))
		((= kw "Phs1")(setq memName "PHS1"))
		((= kw "PhRs1")(setq memName "PHRS1"))
		(T (setq memName "AS1"))
	)
	
	; 생성할 부재네임의 레이어가 없을경우 추가
	(layerMake layName layCol)
	
	; 부재네임 생성
	(setq newName (makeText textpt textHei 0 memName textCol))
	
	; 부재네임 정렬점 수정
	(textMove2nd newName 4 0)
	
	; 네임 주위의 타원생성
	(setq newEllipse (makeEllipse textpt 536 0.4235 "bylayer"))
	
	; 부재네임의 레이어 변경
	(changeLayer newName layName)
	(changeLayer newEllipse layName)
)

; pt1과 pt2로부터 dir방향으로 200띄운 영역보조선 생성(보조선 중심으로부터 
(defun makeSubLine (pt1 pt2 dir / ang len tempt diagpt1 diagpt2 cent)
	(setq ang (modiAngle (angle pt1 pt2)))
	(setq len (distance pt1 pt2))
	
	;현재 각도에서 두 점을 잇는 선의 끝점이 pt1이면 pt1을 시작점으로 변경
	(if (isSameIntegerCoordinate pt1 (polar pt2 ang len))
		(progn
			(setq tempt pt1)
			(setq pt1 pt2)
			(setq pt2 tempt)
		)
	)
	
	(if (< (distance pt1 pt2) 1060)
		(princ "\n길이가 너무 짧아서 영역보조선을 생성할 수 없습니다.")
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