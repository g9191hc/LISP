;최종수정 221231
;made by HyunChul Go

;----------------------------- general sub function ---------------------

;특정 타입의 객체 획득(객체타입[Str] => 객체네임[EName])
(defun getSpObj(objtype / ent entdxf) 
	(while (= nil (setq ent (car (entsel (strcat "\n" (strcase objtype) "형 객체를 선택 해 주세요."))))))
	(setq entdxf (entget ent))
	(while (/= (cdr (assoc 0 entdxf)) (strcase objtype))
		(setq ent (car (entsel (strcat "\n" (strcase objtype) "형 객체를 선택 해 주세요."))))
		(setq entdxf (entget ent))
	)
	ent
)


;라디안을 각도로 변경(라디안값[Number] => 각도[Real])
(defun rtd(ang) 
	(/ (* ang 180.0) pi)
)

;각도를 라디안으로 변경(각도[Nuber] => 라디안값[Number])
(defun dtr(ang)
	(* (/ ang 180.0) pi)
)


;입력받은 각도를 보기편하게(-90~90도 영역에 들어오도록)변환(각도[Real] => 각도[Real])
(defun comfortAng (ag) 
	(- (rem (+ ag 90) 180) 90)
)


;두 점의 중간점 좌표를 반환(좌표1[List] 좌표2[List] => 좌표[List])
(defun tpCenter(p1 p2) 
	(list
		(/ (+ (car p1) (car p2)) 2)
		(/ (+ (cadr p1) (cadr p2)) 2)
	)
)


;폴리선의 정점리스트를 반환(폴리선네임[EName] => 정점리스트[List])
(defun getPlPtList(pl / entinfo isPlClosed ptlst) 
	(setq entinfo (entget pl))
	(setq isPlClosed (= (logand (cdr (assoc 70 entinfo)) 1) 1)) ;닫혀있는경우(dxf 70 = 1) T, 아니면 nil)
	(while entinfo
		(if (= (caar entinfo) 10)
			(setq ptlst (cons (cdar entinfo) ptlst)) ;(cons 요소 nil)일경우 요소 하나짜리 리스트 생성되므로 ptlst초기화 전에도 nil로서 사용됨.
		)
		(setq entinfo (cdr entinfo))
	)
	(if isPlClosed
		(setq ptlst (append ptlst (list (car ptlst)))) ;ptlist의 첫번째 요소를 마지막에 덧붙임
	)
	ptlst
)


;문자 정렬 변경 및 문자의 변경된 정렬점에 맞춰서 이동하는 함수 (객체네임[EName] 수평정렬방식[정수] 수직정렬방식[정수])
(defun textSetMove2nd(ent hpos vpos / entinfo) 
	(setq entinfo (entget ent))
	(setq entinfo (subst (cons 72 hpos) (assoc 72 entinfo) entinfo)) ; 수평정렬방식변경
	(setq entinfo (subst (cons 73 vpos) (assoc 73 entinfo) entinfo)) ; 수직정렬방식변경
	(setq entinfo (subst (cons 11 (cdr (assoc 10 entinfo))) (assoc 11 entinfo) entinfo)) ; 새정렬점의 좌표를 문자의 좌측하단좌표로 변경
	(entmod entinfo) ;객체에 반영(이동)
)


;문자(text)객체 생성(위치좌표[List]/높이[Real]/라디안각도[Real]/문자내용[Str] => 객체네임[Ename])
(defun makeText (ps ht ag tx / ent) 
	(entmake (list
		(cons 0 "text") ;text 타입
		(cons 1 tx) ;입력문자 
		(cons 40 ht) ;문자 높이 
		(cons 50 (dtr ag)) ;각도 
		(cons 10 ps) ;위치
		)
	)
	(entlast)
)





;--------------------------- project sub functions ------------------------------

(defun putLengthOnLine(ht / pl plptlist pt1 pt2 dist ang cen txt) ;폴리선 각 중점에 길이 입력 (문자높이[Real])
	(setq pl (getSpObj "lwpolyline")) ;폴리선 객체 선택
	(setq plptlist (getPlPtList pl)) ;폴리선의 정점리스트 획득
	(while plptlist
		(setq pt1 (car plptlist))
		(setq pt2 (cadr plptlist))
		(setq dist (rtos (distance pt1 pt2) 2 2)) ;distance 기본함수 사용
		(setq ang (comfortAng (rtd (angle pt1 pt2)))) ;angle 기본함수 사용
		(setq cen (tpCenter pt1 pt2)) ;중점 획득
		(setq txt (makeText cen ht ang dist)) ; 텍스트 생성
		(textSetMove2nd txt 4 0) ;텍스트 정렬
		(setq plptlist (cdr plptlist))
	)
)
		

;-------------------------------ㅡ main ---------------------------------
(defun c:cd(/ ht) ;선택한 선의 길이를 선 중간에 생성하는 리습
	(setq ht (getreal (strcat "\n 문자의 높이를 입력 해 주세요. <" (rtos (getvar "textsize")) "> : "))) ;문자 높이 입력받기
	(if (= ht nil) (setq ht (getvar "textsize")) ) ;문자높이 미입력시 기본값 사용
	(putLengthOnLine ht) ; 서브함수 실행
	(princ)
)