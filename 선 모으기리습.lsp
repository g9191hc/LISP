; pp : point(������ ����)
; ll : ������ ���� ����Ǵ� �� �׸���

; ���� ������ ���ϱ�
(defun c:pp()
	(setq p1 (trans (getpoint "\n ���� ���̱� ���ϴ� ���� �������ּ���") 1 0))
	(princ)
)


; ���õ� ������ �� �����ϱ�
(defun c:ll(/ p2)
	(setq p2 (trans (getpoint "\n �� ���� �������ּ���") 1 0))
	(command "line" (trans p1 0 1) (trans p2 0 1) "")
	(princ)
)