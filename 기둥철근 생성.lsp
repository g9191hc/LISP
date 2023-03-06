; 20230119
; made by ��ö

; CR : ��� ö�ٱ׸� ���� (Create Rebar)
(defun c:CR ()
  (rebarCreate)
  (princ)
)

;----------------- ��� -------------------
;----------------- ��� -------------------

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

;�� ����
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
		(cons 10 pt) ;������ġ
		(cons 40 rr) ;������
		(cons 62 col)
		)
	)
	(entlast)
)

;��ü���̾� ����
(defun changeLayer(ent layerName / entinfo) 
	(setq entinfo (entget ent))
	(entmod (subst (cons 8 layerName) (assoc 8 entinfo) entinfo)) ;
	ent
)

; 2���� ���� 4����ǥ ����Ʈ ��ȯ(���ʻ���� ù��°�� �ð�������� �ԷµǾ��� ����Ʈ)
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

; �簢���� �� ������ ����Ʈ�� �޾Ƽ� �ܺ�, �庯 ���� ����Ʈ�� ��ȯ (�ܺ� , �庯)
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

; �Էµ� �� �� ���̸� �յ�����ϴ� �� n��(�Է� �� �� ���� ����)�� ��ǥ�� �̷���� ��ǥ����Ʈ�� ��ȯ
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


;----------------- �����Լ� -------------------
;----------------- �����Լ� -------------------



;ö�ٱ׸���
(defun drawRebar (ptlist / rebar)
  (while (car ptlist)
    (setq rebar (makeCircle (car ptlist) rebar_radius "bylayer"))
    (changeLayer rebar "REBAR-T")
    (setq ptlist (cdr ptlist))
  )
)



;----------------- �����Լ� -------------------
;----------------- �����Լ� -------------------


; �����Լ�
(defun rebarCreate (/ rebar_num rebar_row_num rebar_column_num vertical_tiebar_num horizontal_tiebar_num outline_points tem_pt rebar_radius)
	
  ;�׸𼭸� ��ǥ����Ʈ ȹ��
  (princ "\n����� ö���� �׸� ������ ���� �� �ּ���")
	(setq outline_points (cornerCoordinates (setq tem_pt (getpoint)) (getcorner tem_pt)))
  
	;�ʿ� ����
	(setq rebar_num (getint "\n�ֱ��� ������ �Է� �� �ּ��� : ") ;�ֱٰ���
		rebar_row_num (getint "\n��(Row) ���� �Է� �� �ּ��� : ") ;�హ��
		rebar_column_num (+ (/ (- rebar_num (* rebar_row_num 2)) 2) 2) ;������
		;vertical_tiebar_num (getint "\n���ι��� Ÿ�̹��� ������ �Է� �� �ּ��� : ") ;Ⱦ���� Ÿ�̹�
		;horizontal_tiebar_num (getint "\n���ι��� Ÿ�̹��� ������ �Է� �� �ּ��� : ") ;������ Ÿ�̹�
	)
	

	
	;����� �ܺ��� �庯���� ȹ��
	(setq shorter_side_length (car (lengthsOfRectangle outline_points)))
	(setq longer_side_length (cadr (lengthsOfRectangle outline_points)))
	
	;�ֱ��� ������ ����(�ܺ����� * 0.04)
	(setq rebar_radius (* (car (lengthsOfRectangle outline_points)) 0.04))
  
  ;�׸𼭸� ö���� �߽� ��ǥ����Ʈ ȹ��
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
  
  ;4���� ö����ġ ����Ʈ ȹ��(����->������, �Ʒ�->��)
  (setq top_rebar (balancedDevidePoints (car corner_rebar_points) (cadr corner_rebar_points) rebar_column_num))
  (setq bottom_rebar (balancedDevidePoints (cadddr corner_rebar_points) (caddr corner_rebar_points) rebar_column_num))
  (setq left_rebar (balancedDevidePoints (cadddr corner_rebar_points) (car corner_rebar_points) rebar_row_num))
  (setq right_rebar (balancedDevidePoints (caddr corner_rebar_points) (cadr corner_rebar_points) rebar_row_num))
  
  ;���̾� ����
  (layerMake "REBAR-T" 2)
  
  ;ö�ٱ׸���
  (drawRebar top_rebar)
  (drawRebar bottom_rebar)
  (drawRebar left_rebar)
  (drawRebar right_rebar)
)