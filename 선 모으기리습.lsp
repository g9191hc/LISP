; pp : point(������ ����)
; ll : ������ ���� ����Ǵ� �� �׸���

; ���� ������ ���ϱ�
(defun c:pp()
	(setq pp::point (trans (getpoint "\n ���� ���̱� ���ϴ� ���� �������ּ���") 1 0))
	(princ)
)


; ���õ� ������ �� �����ϱ�
(defun c:ll(/ pt)
	(if (= nil pp::point)
		(command "pp")
	)
	(setq pt (trans (getpoint "\n �� ���� �������ּ���") 1 0))
	(command "line" (trans pp::point 0 1) (trans pt 0 1) "")
	(princ)
)

;������Ʈ
;230306 : ll���� pp���� �ȵǾ� ������� pp�� ���� ���� ��