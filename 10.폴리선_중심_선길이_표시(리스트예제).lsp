;�������� 221231
;made by HyunChul Go

;----------------------------- general sub function ---------------------

;Ư�� Ÿ���� ��ü ȹ��(��üŸ��[Str] => ��ü����[EName])
(defun getSpObj(objtype / ent entdxf) 
	(while (= nil (setq ent (car (entsel (strcat "\n" (strcase objtype) "�� ��ü�� ���� �� �ּ���."))))))
	(setq entdxf (entget ent))
	(while (/= (cdr (assoc 0 entdxf)) (strcase objtype))
		(setq ent (car (entsel (strcat "\n" (strcase objtype) "�� ��ü�� ���� �� �ּ���."))))
		(setq entdxf (entget ent))
	)
	ent
)


;������ ������ ����(���Ȱ�[Number] => ����[Real])
(defun rtd(ang) 
	(/ (* ang 180.0) pi)
)

;������ �������� ����(����[Nuber] => ���Ȱ�[Number])
(defun dtr(ang)
	(* (/ ang 180.0) pi)
)


;�Է¹��� ������ �������ϰ�(-90~90�� ������ ��������)��ȯ(����[Real] => ����[Real])
(defun comfortAng (ag) 
	(- (rem (+ ag 90) 180) 90)
)


;�� ���� �߰��� ��ǥ�� ��ȯ(��ǥ1[List] ��ǥ2[List] => ��ǥ[List])
(defun tpCenter(p1 p2) 
	(list
		(/ (+ (car p1) (car p2)) 2)
		(/ (+ (cadr p1) (cadr p2)) 2)
	)
)


;�������� ��������Ʈ�� ��ȯ(����������[EName] => ��������Ʈ[List])
(defun getPlPtList(pl / entinfo isPlClosed ptlst) 
	(setq entinfo (entget pl))
	(setq isPlClosed (= (logand (cdr (assoc 70 entinfo)) 1) 1)) ;�����ִ°��(dxf 70 = 1) T, �ƴϸ� nil)
	(while entinfo
		(if (= (caar entinfo) 10)
			(setq ptlst (cons (cdar entinfo) ptlst)) ;(cons ��� nil)�ϰ�� ��� �ϳ�¥�� ����Ʈ �����ǹǷ� ptlst�ʱ�ȭ ������ nil�μ� ����.
		)
		(setq entinfo (cdr entinfo))
	)
	(if isPlClosed
		(setq ptlst (append ptlst (list (car ptlst)))) ;ptlist�� ù��° ��Ҹ� �������� ������
	)
	ptlst
)


;���� ���� ���� �� ������ ����� �������� ���缭 �̵��ϴ� �Լ� (��ü����[EName] �������Ĺ��[����] �������Ĺ��[����])
(defun textSetMove2nd(ent hpos vpos / entinfo) 
	(setq entinfo (entget ent))
	(setq entinfo (subst (cons 72 hpos) (assoc 72 entinfo) entinfo)) ; �������Ĺ�ĺ���
	(setq entinfo (subst (cons 73 vpos) (assoc 73 entinfo) entinfo)) ; �������Ĺ�ĺ���
	(setq entinfo (subst (cons 11 (cdr (assoc 10 entinfo))) (assoc 11 entinfo) entinfo)) ; ���������� ��ǥ�� ������ �����ϴ���ǥ�� ����
	(entmod entinfo) ;��ü�� �ݿ�(�̵�)
)


;����(text)��ü ����(��ġ��ǥ[List]/����[Real]/���Ȱ���[Real]/���ڳ���[Str] => ��ü����[Ename])
(defun makeText (ps ht ag tx / ent) 
	(entmake (list
		(cons 0 "text") ;text Ÿ��
		(cons 1 tx) ;�Է¹��� 
		(cons 40 ht) ;���� ���� 
		(cons 50 (dtr ag)) ;���� 
		(cons 10 ps) ;��ġ
		)
	)
	(entlast)
)





;--------------------------- project sub functions ------------------------------

(defun putLengthOnLine(ht / pl plptlist pt1 pt2 dist ang cen txt) ;������ �� ������ ���� �Է� (���ڳ���[Real])
	(setq pl (getSpObj "lwpolyline")) ;������ ��ü ����
	(setq plptlist (getPlPtList pl)) ;�������� ��������Ʈ ȹ��
	(while plptlist
		(setq pt1 (car plptlist))
		(setq pt2 (cadr plptlist))
		(setq dist (rtos (distance pt1 pt2) 2 2)) ;distance �⺻�Լ� ���
		(setq ang (comfortAng (rtd (angle pt1 pt2)))) ;angle �⺻�Լ� ���
		(setq cen (tpCenter pt1 pt2)) ;���� ȹ��
		(setq txt (makeText cen ht ang dist)) ; �ؽ�Ʈ ����
		(textSetMove2nd txt 4 0) ;�ؽ�Ʈ ����
		(setq plptlist (cdr plptlist))
	)
)
		

;-------------------------------�� main ---------------------------------
(defun c:cd(/ ht) ;������ ���� ���̸� �� �߰��� �����ϴ� ����
	(setq ht (getreal (strcat "\n ������ ���̸� �Է� �� �ּ���. <" (rtos (getvar "textsize")) "> : "))) ;���� ���� �Է¹ޱ�
	(if (= ht nil) (setq ht (getvar "textsize")) ) ;���ڳ��� ���Է½� �⺻�� ���
	(putLengthOnLine ht) ; �����Լ� ����
	(princ)
)