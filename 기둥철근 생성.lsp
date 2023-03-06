; 20230119
; made by 현철

; CR : 기둥 철근그림 생성 (Create Rebar)
(defun c:CR ()
  (rebarCreate)
  (princ)
)

;----------------- 모듈 -------------------
;----------------- 모듈 -------------------

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

;원 생성
(defun makeCircle (pt rr col)
	(if (= (type col) 'STR)
		(if (= (strcase col) "BYLAYER")
			(setq col 256)
			(setq col 0)
		)
	)
	(entmake (list
		(cons 0 "CIRCLE") 
		(cons 100 "AcDbEntity")
		(cons 100 "AcDbCircle")
		(cons 10 pt) ;중점위치
		(cons 40 rr) ;반지름
		(cons 62 col)
		)
	)
	(entlast)
)

;객체레이어 변경
(defun changeLayer(ent layerName / entinfo) 
	(setq entinfo (entget ent))
	(entmod (subst (cons 8 layerName) (assoc 8 entinfo) entinfo)) ;
	ent
)

; 2점에 대한 4점좌표 리스트 반환(왼쪽상단이 첫번째로 시계방향으로 입력되어진 리스트)
(defun cornerCoordinates (pt1 pt2)
	(setq x1 (car pt1))
	(setq x2 (car pt2))
	(setq y1 (cadr pt1))
	(setq y2 (cadr pt2))
	(setq greaterX (if (> x1 x2) x1 x2))
	(setq lessX (if (= greaterX x1) x2 x1))
	(setq greaterY (if (> y1 y2) y1 y2))
	(setq lessY (if (= greaterY y1) y2 y1))
	(list 
		(list lessX greaterY)
		(list greaterX greaterY)
		(list greaterX lessY)
		(list lessX lessY)
	)
)

; 사각형의 네 꼭지점 리스트를 받아서 단변, 장변 길이 리스트를 반환 (단변 , 장변)
(defun lengthsOfRectangle (corner_lists / dist1 dist2 shorter_length longer_length)
	(setq dist1 (distance (car corner_lists) (cadr corner_lists))
		dist2 (distance (cadr corner_lists) (caddr corner_lists))
	)
	(setq shorter_length
		(if (< dist1 dist2)
			dist1
			dist2
		)
	)
	(setq longer_length
		(if (= dist1 shorter_length)
			dist2
			dist1
		)
	)
	(list shorter_length longer_length)	
)

; 입력된 두 점 사이를 균등분할하는 총 n개(입력 된 두 점을 포함)의 좌표로 이루어진 좌표리스트를 반환
(defun balancedDevidePoints (pt1 pt2 pt_num / num ang dist ptlist)
  (setq num 1
        ang (angle pt1 pt2)
        dist (/ (distance pt1 pt2) (- pt_num 1))
        ptlist (list pt1)
  )
  (setq pt_num (1- pt_num))
  (while (< num pt_num)
    (setq ptlist (append ptlist (list (polar pt1 (angle pt1 pt2) (* dist num)))))
    (setq num (1+ num))
  )
  (append ptlist (list pt2))
)


;----------------- 서브함수 -------------------
;----------------- 서브함수 -------------------



;철근그리기
(defun drawRebar (ptlist / rebar)
  (while (car ptlist)
    (setq rebar (makeCircle (car ptlist) rebar_radius "bylayer"))
    (changeLayer rebar "REBAR-T")
    (setq ptlist (cdr ptlist))
  )
)



;----------------- 메인함수 -------------------
;----------------- 메인함수 -------------------


; 메인함수
(defun rebarCreate (/ rebar_num rebar_row_num rebar_column_num vertical_tiebar_num horizontal_tiebar_num outline_points tem_pt rebar_radius)
	
  ;네모서리 좌표리스트 획득
  (princ "\n기둥의 철근을 그릴 영역을 선택 해 주세요")
	(setq outline_points (cornerCoordinates (setq tem_pt (getpoint)) (getcorner tem_pt)))
  
	;필요 정보
	(setq rebar_num (getint "\n주근의 갯수를 입력 해 주세요 : ") ;주근갯수
		rebar_row_num (getint "\n행(Row) 수를 입력 해 주세요 : ") ;행갯수
		rebar_column_num (+ (/ (- rebar_num (* rebar_row_num 2)) 2) 2) ;열갯수
		;vertical_tiebar_num (getint "\n가로방향 타이바의 갯수를 입력 해 주세요 : ") ;횡방향 타이바
		;horizontal_tiebar_num (getint "\n세로방향 타이바의 갯수를 입력 해 주세요 : ") ;종방향 타이바
	)
	

	
	;기둥의 단변과 장변길이 획득
	(setq shorter_side_length (car (lengthsOfRectangle outline_points)))
	(setq longer_side_length (cadr (lengthsOfRectangle outline_points)))
	
	;주근의 반지름 결정(단변길이 * 0.04)
	(setq rebar_radius (* (car (lengthsOfRectangle outline_points)) 0.04))
  
  ;네모서리 철근의 중심 좌표리스트 획득
  (setq corner_rebar_points
    (cornerCoordinates
        (list
          (+ (caar outline_points) rebar_radius)
          (- (cadar outline_points) rebar_radius)
        )
        (list
          (- (caaddr outline_points) rebar_radius)
          (+ (car (cdaddr outline_points)) rebar_radius)
        )
    )
  )
  
  ;4방향 철근위치 리스트 획득(왼쪽->오른쪽, 아래->위)
  (setq top_rebar (balancedDevidePoints (car corner_rebar_points) (cadr corner_rebar_points) rebar_column_num))
  (setq bottom_rebar (balancedDevidePoints (cadddr corner_rebar_points) (caddr corner_rebar_points) rebar_column_num))
  (setq left_rebar (balancedDevidePoints (cadddr corner_rebar_points) (car corner_rebar_points) rebar_row_num))
  (setq right_rebar (balancedDevidePoints (caddr corner_rebar_points) (cadr corner_rebar_points) rebar_row_num))
  
  ;레이어 생성
  (layerMake "REBAR-T" 2)
  
  ;철근그리기
  (drawRebar top_rebar)
  (drawRebar bottom_rebar)
  (drawRebar left_rebar)
  (drawRebar right_rebar)
)