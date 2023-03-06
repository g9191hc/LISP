;
;
; ----------------------------------------------------------[ J/C/A/D ]-----
;  Trim & Erase for OutSide Rectangle               Programmed by �� �� �� 
;                                                   Last Updated  05/05/02 
; ==========================================================================
;
(defun c:At ( / Os_Md Et_pLo Lt_vtx Min_rX Min_rY Max_rX Max_rY
                 _tmp01 _tmp02 _tmp03 _tmp04 _tmL01 _tmAdd _tmRpt)
;
  (setq olderr *error* *error* errchck)
;
  (setq Os_md (getvar "Osmode"))
;
  (setvar "cmdecho" 0)
  (setvar "Osmode"  0)
;
  (setq Et_pLo (car (entseL "\n �׵θ� ��Ҹ� �����ϼ��� ")) ) ;
;
; --------------------------------------------------------------------------------------
; ... �����ϴ� '�׵θ� ���'�� �ݵ�� "Polyline'���� �� ���簢�� ����̾�� �մϴ�.   
; ... [������ '0'���� '90'���� �Ǿ�� �ϸ� ȸ���Ǿ�� �ȵ˴ϴ�.                     
; --------------------------------------------------------------------------------------
;
  (redraw Et_pLo 3)
;
  (setq Lt_vtx niL)
  (foreach f_e (entget Et_pLo)
    (if (= (car f_e) 10) (setq Lt_vtx (append Lt_vtx (List (cdr f_e))) ) ) ; i
  ) ; r
;
  (setq Min_rX (min (car  (car Lt_vtx)) (car  (cadr Lt_vtx)) (car  (caddr Lt_vtx)) (car  (cadddr Lt_vtx)))
        Max_rX (max (car  (car Lt_vtx)) (car  (cadr Lt_vtx)) (car  (caddr Lt_vtx)) (car  (cadddr Lt_vtx)))
        Min_rY (min (cadr (car Lt_vtx)) (cadr (cadr Lt_vtx)) (cadr (caddr Lt_vtx)) (cadr (cadddr Lt_vtx)))
        Max_rY (max (cadr (car Lt_vtx)) (cadr (cadr Lt_vtx)) (cadr (caddr Lt_vtx)) (cadr (cadddr Lt_vtx))) )
;
  (setq _tmp01 (list Min_rX Min_rY)
        _tmp02 (list Max_rX Min_rY)
        _tmp03 (list Max_rX Max_rY)
        _tmp04 (list Min_rX Max_rY) ) ;
;
  (setq _tmL01 1 ; ... ���� �̰ݰŸ� 
        _tmAdd  1   ; ... �Ÿ� ����     
        _tmRpt 150) ; ... �ݺ� Ƚ��     
;
  (Command "Erase" "ALL" "R" "C" _tmp01 _tmp03 "")
;
  (Command "Trim" Et_pLo "")
  (repeat _tmRpt
    (Command "F" (polar _tmp01 (dtr 225) _tmL01) (polar _tmp02 (dtr 315) _tmL01) "")
    (Command "F" (polar _tmp02 (dtr 315) _tmL01) (polar _tmp03 (dtr  45) _tmL01) "")
    (Command "F" (polar _tmp03 (dtr  45) _tmL01) (polar _tmp04 (dtr 135) _tmL01) "")
    (Command "F" (polar _tmp04 (dtr 135) _tmL01) (polar _tmp01 (dtr 225) _tmL01) "")
    (setq _tmL01 (+ _tmL01 _tmAdd))
  ) ; r
  (Command)
;
;
  (setq Min_tX (car  (getvar "ExtMin"))
        Min_tY (cadr (getvar "ExtMin"))
        Max_tX (car  (getvar "ExtMax"))
        Max_tY (cadr (getvar "ExtMax")) ) ;
;
  (Command "ERASE" "W" (list Min_tX Min_tY) (list Min_rX Max_tY) "")
  (Command "ERASE" "W" (list Min_tX Min_tY) (list Max_tX Min_rY) "")
  (Command "ERASE" "W" (list Min_tX Max_rY) (list Max_tX Max_tY) "")
  (Command "ERASE" "W" (list Max_rX Min_tY) (list Max_tX Max_tY) "")
;
; >>> �Ʒ��� �׵θ��� ���� �ִ� ���ڿ� ����� �����ϴ� ��ƾ�Դϴ�.           
;
  (setq Et_List (list (ssget "C" _tmp01 _tmp02 '((0 . "TEXT,INSERT")))
                      (ssget "C" _tmp02 _tmp03 '((0 . "TEXT,INSERT")))
                      (ssget "C" _tmp03 _tmp04 '((0 . "TEXT,INSERT")))
                      (ssget "C" _tmp04 _tmp01 '((0 . "TEXT,INSERT")))) ) ;
;
  (foreach f_e Et_List
    (if f_e
      (progn
        (setq _ij1 0)
        (repeat (sslength f_e)
          (entdel (ssname f_e _ij1))
          (setq _ij1 (1+ _ij1))
        ) ; r
      ) ; p
    ) ; i
  ) ; f
;
;
  (setVar "Osmode" Os_Md)
;
;
(princ)
;
;
) ; de_fun
;
;
; =========================================================================
(defun dtr  (_a / )  (/ (* _a pi) 180.) ) 
; =========================================================================
;
;
