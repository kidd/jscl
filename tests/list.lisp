;; Tests for list functions

;; CONS
(test (equal (cons 1 2) '(1 . 2)))
(test (equal (cons 1 nil) '(1)))
(test (equal (cons nil 2) '(NIL . 2)))
(test (equal (cons nil nil) '(NIL)))
(test (equal (cons 1 (cons 2 (cons 3 (cons 4 nil)))) '(1 2 3 4)))
(test (equal (cons 'a 'b) '(A . B)))
(test (equal (cons 'a (cons 'b (cons 'c '()))) '(A B C)))
(test (equal (cons 'a '(b c d)) '(A B C D)))

;; CONSP
(test (not (consp 'nil)))
(test (not (consp nil)))
(test (not (consp ())))
(test (not (consp '())))
(test (consp (cons 1 2)))

;; ATOM
(test (atom 'sss))
(test (not (atom (cons 1 2))))
(test (atom nil))
(test (atom '()))
(test (atom 3))

;; RPLACA
(let ((some-list (list* 'one 'two 'three 'four)))
  (test (equal (rplaca some-list 'uno) '(UNO TWO THREE . FOUR)))
  (test (equal some-list '(UNO TWO THREE . FOUR))))

;; RPLACD
(let ((some-list (list* 'one 'two 'three 'four)))
  (test (equal (rplacd (last some-list) (list 'IV)) '(THREE IV)))
  (test (equal some-list '(ONE TWO THREE IV))))

;; CAR, CDR and variants
(test (equal (car nil) nil))
(test (equal (cdr '(1 . 2)) 2))
(test (equal (cdr '(1 2)) '(2)))
(test (equal (cadr '(1 2)) 2))
(test (equal (car '(a b c)) 'a))
(test (equal (cdr '(a b c)) '(b c)))
(test (equal (caar '((1 2) 3)) 1))
(test (equal (cadr '(1 2 3)) 2))
(test (equal (cdar '((1 2) 3)) '(2)))
(test (equal (cddr '(1 2 3)) '(3)))
(test (equal (caaar '(((1)))) 1))
(test (equal (caadr '(1 (2))) 2))
(test (equal (cadar '((1 2))) 2))
(test (equal (caddr '(1 2 3)) 3))
(test (equal (cdaar '(((1 2)))) '(2)))
(test (equal (cdadr '(1 (2 3))) '(3)))
(test (equal (cddar '((1 2 3))) '(3)))
(test (equal (cdddr '(1 2 3 4)) '(4)))
(test (equal (caaaar '((((1))))) 1))
(test (equal (caaadr '(1 ((2)))) 2))
(test (equal (caadar '((1 (2)))) 2))
(test (equal (caaddr '(1 2 (3))) 3))
(test (equal (cadaar '(((1 2)))) 2))
(test (equal (cadadr '(1 (2 3))) 3))
(test (equal (caddar '((1 2 3))) 3))
(test (equal (cadddr '(1 2 3 4)) 4))
(test (equal (cdaaar '((((1 2))))) '(2)))
(test (equal (cdaadr '(1 ((2 3)))) '(3)))
(test (equal (cdadar '((1 (2 3)))) '(3)))
(test (equal (cdaddr '(1 2 (3 4))) '(4)))
(test (equal (cddaar '(((1 2 3)))) '(3)))
(test (equal (cddadr '(1 (2 3 4))) '(4)))
(test (equal (cdddar '((1 2 3 4))) '(4)))
(test (equal (cddddr '(1 2 3 4 5)) '(5)))

;; SUBLIS
(test (equal (sublis '((x . 100) (z . zprime))
                     '(plus x (minus g z x p) 4 . x))
             '(PLUS 100 (MINUS G ZPRIME 100 P) 4 . 100)))
(test (equal (sublis '(((+ x y) . (- x y)) ((- x y) . (+ x y)))
                     '(* (/ (+ x y) (+ x p)) (- x y))
                     :test #'equal)
             '(* (/ (- X Y) (+ X P)) (+ X Y))))
(let ((tree1 '(1 (1 2) ((1 2 3)) (((1 2 3 4))))))
  (test (equal (sublis '((3 . "three")) tree1)
               '(1 (1 2) ((1 2 "three")) (((1 2 "three" 4))))))
  (test (equal (sublis '((t . "string"))
                       (sublis '((1 . "") (4 . 44)) tree1)
                       :key #'stringp)
               '("string" ("string" 2) (("string" 2 3)) ((("string" 2 3 44))))))
  (test (equal tree1 '(1 (1 2) ((1 2 3)) (((1 2 3 4)))))))
(let ((tree2 '("one" ("one" "two") (("one" "Two" "three")))))
  (test (equal (sublis '(("two" . 2)) tree2)
               '("one" ("one" "two") (("one" "Two" "three")))))
  (test (equal tree2 '("one" ("one" "two") (("one" "Two" "three")))))
  (test (equal (sublis '(("two" . 2)) tree2 :test 'equal)
               '("one" ("one" 2) (("one" "Two" "three"))))))

; COPY-TREE
(test (let* ((foo (list '(1 2) '(3 4)))
             (bar (copy-tree foo)))
        ;; (SETF (CAR (CAR FOO)) 0) doesn't work in the test for some reason,
        ;; despite working fine in the REPL
        (rplaca (car foo) 0)
        (not (= (car (car foo))
                (car (car bar))))))

; TREE-EQUAL
(test (tree-equal '(1 2 3) '(1 2 3)))
(test (tree-equal '(1 (2 (3 4) 5) 6) '(1 (2 (3 4) 5) 6)))
(test (tree-equal (cons 1 2) (cons 2 3)
                  :test (lambda (a b) (not (= a b)))))

; FIRST to TENTH
(let ((nums '(1 2 3 4 5 6 7 8 9 10)))
  (test (= (first   nums) 1))
  (test (= (second  nums) 2))
  (test (= (third   nums) 3))
  (test (= (fourth  nums) 4))
  (test (= (fifth   nums) 5))
  (test (= (sixth   nums) 6))
  (test (= (seventh nums) 7))
  (test (= (eighth  nums) 8))
  (test (= (ninth   nums) 9))
  (test (= (tenth   nums) 10)))

; TAILP
(let* ((a (list 1 2 3))
       (b (cdr a)))
  (test (tailp b a))
  (test (tailp a a)))
(test (tailp 'a (cons 'b 'a)))

; ACONS
(test (equal '((1 . 2) (3 . 4))
             (acons 1 2 '((3 . 4)))))
(test (equal '((1 . 2)) (acons 1 2 ())))

; PAIRLIS
(test (equal '((1 . 3) (0 . 2))
             (pairlis '(0 1) '(2 3))))
(test (equal '((1 . 2) (a . b))
             (pairlis '(1) '(2) '((a . b)))))

; COPY-ALIST
(let* ((alist '((1 . 2) (3 . 4)))
       (copy (copy-alist alist)))
  (test (not (eql alist copy)))
  (test (not (eql (car alist) (car copy))))
  (test (equal alist copy)))

; ASSOC and RASSOC
(let ((alist '((1 . 2) (3 . 4))))
  (test (equal (assoc  1 alist) '(1 . 2)))
  (test (equal (rassoc 2 alist) '(1 . 2)))
  (test (not   (assoc  2 alist)))
  (test (not   (rassoc 1 alist))))

; MEMBER
(test (equal (member 2 '(1 2 3)) '(2 3)))
(test (not   (member 4 '(1 2 3))))
(test (equal (member 4 '((1 . 2) (3 . 4)) :key #'cdr) '((3 . 4))))
(test (member '(2) '((1) (2) (3)) :test #'equal))

; ADJOIN
(test (equal (adjoin 1 '(2 3))   '(1 2 3)))
(test (equal (adjoin 1 '(1 2 3)) '(1 2 3)))
(test (equal (adjoin '(1) '((1) (2)) :test #'equal) '((1) (2))))

; INTERSECTION
(test (equal (intersection '(1 2) '(2 3)) '(2)))
(test (not (intersection '(1 2 3) '(4 5 6))))
(test (equal (intersection '((1) (2)) '((2) (3)) :test #'equal) '((2))))

; SUBST

; POP
(test (let* ((foo '(1 2 3))
             (bar (pop foo)))
        (and (= bar 1)
             (= (car foo) 2))))

;; MAPCAR
(test (equal (mapcar #'+ '(1 2) '(3) '(4 5 6)) '(8)))

;; MAPC
(test (equal (mapc #'+ '(1 2) '(3) '(4 5 6)) '(1 2)))
(test (let (foo)
        (mapc (lambda (x y z) (push (+ x y z) foo)) '(1 2) '(3) '(4 5 6))
        (equal foo '(8))))
