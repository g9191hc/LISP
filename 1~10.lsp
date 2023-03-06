; 

(Defun c:1() ;프린트
	(command "_print")
	(princ)
)

(Defun c:2() ;속성복사(match proporties)
	(command "matchprop")
	(princ)
)

(Defun c:3() ;치수선(dimension aligned)
	(command "dimaligned")
	(princ)
)

(Defun c:3r() ;치수선(직각)(dimension linear)
	(command "dimlinear")
	(princ)
)

(Defun c:3a() ;치수선(각도)(dimension linear)
	(command "dimangular")
	(princ)
)

(Defun c:33() ;dimstyle 기본설정(단위형식 윈도우바탕화면, 소숫점자릿수 0, 문자높이 250)
	(command "dimunit" "8") ;단위형식 윈도우바탕화면(세자리마다 콤마(,)표시. 십진("2")은 없음)
	(command "dimdec" "0") ;소숫점 자릿수 0 지정
	(command "dimtxt" "250") ;높이 기본 250 설정
	(princ)
)

(Defun c:333() ;dimstyle 기본설정(단위형식 윈도우바탕화면, 소숫점자릿수 0, 문자높이 사용자정의)
	(command "dimunit" "8") ;단위형식 윈도우바탕화면(세자리마다 콤마(,)표시. 십진("2")은 없음)
	(command "dimdec" "0") ;소숫점 자릿수 0 지정
	(command "dimtxt") ;높이 사용자설정
	(princ)
)	
	
(Defun c:4() ;선택객체의 레이어만 분리(최초 설정(s)-끄기(o)-끄기(o) 해줘야함)(layer isolation)
	(command "layiso")
	(princ)
)

(Defun c:5() ;참조(블록) 편집(블록이 동결된 레이어일 경우에도 편집가능)(reference edit)
	(command "refedit")
	(princ)
)

(Defun c:6() ;선택레이어 끄기(layer off)
	(command "layoff")
	(princ)
)

(Defun c:7() ;전체레이어 켜기(layer on)
	(command "layon")
	(princ)
)

(Defun c:8() ;레이어 잠금(layer lock)
	(command "laylck")
	(princ)
)

(Defun c:88() ;레이어 잠금시 페이드 조정(layer lock fade control)
	(command "LAYLOCKFADECTL")
	(princ)
)

(Defun c:9() ;레이어 잠금해제(layer unlock)
	(command "layulk")
	(princ)
)

(Defun c:0()
	(command "dimaligned")
	(princ)
)