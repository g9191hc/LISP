; pp : point(모일점 셋팅)
; ll : 셋팅한 점과 연결되는 선 그리기

; 선이 모일점 정하기
(defun c:pp()
	(setq pp::point (trans (getpoint "\n 선이 모이기 원하는 점을 선택해주세요") 1 0))
	(princ)
)


; 선택된 점으로 선 연결하기
(defun c:ll(/ pt)
	(if (= nil pp::point)
		(command "pp")
	)
	(setq pt (trans (getpoint "\n 한 점을 선택해주세요") 1 0))
	(command "line" (trans pp::point 0 1) (trans pt 0 1) "")
	(princ)
)

;업데이트
;230306 : ll사용시 pp지정 안되어 있을경우 pp를 먼저 실행 함