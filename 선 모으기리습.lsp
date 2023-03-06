; pp : point(모일점 셋팅)
; ll : 셋팅한 점과 연결되는 선 그리기

; 선이 모일점 정하기
(defun c:pp()
	(setq p1 (trans (getpoint "\n 선이 모이기 원하는 점을 선택해주세요") 1 0))
	(princ)
)


; 선택된 점으로 선 연결하기
(defun c:ll(/ p2)
	(setq p2 (trans (getpoint "\n 한 점을 선택해주세요") 1 0))
	(command "line" (trans p1 0 1) (trans p2 0 1) "")
	(princ)
)