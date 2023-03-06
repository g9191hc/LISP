(defun c:xyout( )
 ;/ n xylist f x y pt1 pnxy1 pnxy2 pnxy3 pnxy num )

 (setq case (getint "1:Auto num  2:pick num ") )  
 
 (setq xylist (list ""))
 (setq n 1)

 (if (= case 1) ; -- auto num mode 

       (progn
               (setq pt1 (list ""))
               (setq numtemp (getint "���۹�ȣ:" ))                           
               (while (/= pt1 nil) ; -- Ż������
                  (print numtemp )
                  (setq num (rtos numtemp 2 3))               
                  (pting)
                  (setq numtemp (+ numtemp 1) )
               ); -- end while               
       ); -- end progn
 ); -- end if


 (if (= case 2) ; -- pick num mode 

       (progn
               (while (/= selnum nil)
                 ( picknum )
                 ( pting )
               ); -- end while

       ); -- end progn
 );---end if


 (printfile)


);---end main defun



;---------------------------------------------------

(defun picknum()

 (setq selnum "")

  (setq selnum (entsel "��ȣ :" ) )

   (if (/= selnum nil)
 
        (progn     (setq num 
                          (cdr 
                            (assoc 1 
                              (entget
                                  (car 
                                      selnum   
                                  );--end car
                              );--end entget
                            );--end assoc 1
                          );--end cdr
                    );--end setq
         );---end progn
   );---end if

);---end pick num


;---------------------------------------------------


(defun pting(); -- ���� ����Ʈ�� ��ô

  (setq pt1 (getpoint "�� ����.." )) (terpri)
  (setq x (car  pt1))
  (setq y (cadr pt1))
  (setq z (last pt1))
  (setq xylist (append xylist (list (atof num) x y z))) 

);---end pting

;----------------------------------------------------

( defun printfile()
 
 (setq f (open (getstring "\nȭ���̸� <xx.xxx>: ") "w")) 
   
 (setq n 1)
 (repeat (/ (- (length xylist) 4) 4)
   (setq pnxy1 (rtos (nth n xylist)))
   (setq pnxy2 (rtos (nth (+ n 1) xylist)))
   (setq pnxy3 (rtos (nth (+ n 2) xylist)))
   (setq pnxy4 (rtos (nth (+ n 3) xylist))) 
   (setq pnxy (strcat "\n" pnxy1 "," pnxy2 "," pnxy3 "," pnxy4))
   (princ pnxy f)
   (setq n (+ n 4)) 
 );--end repeat

 (close f)

);---end printfile

;------------------------------------------------------