(define isempty
  (lambda (lst)
    (null? lst)))

(define length
        (lambda (lst)
          (if (isempty lst)
            0
            (+ 1 (length (cdr lst))))))

(define equallength
  (lambda (lst1 lst2)
    (= (length lst1) (length lst2))))

(define procList
  (lambda (op lst1 lst2)
    (if (equallength lst1 lst2)
      (if (isempty lst1)
        (list)
        (cons (op (car lst1) (car lst2))
          (procList op (cdr lst1) (cdr lst2))))
      (list))))

(define add
  (lambda (pair1 pair2)
    (cons (+ (car pair1) (car pair2))
      (+ (cdr pair1) (cdr pair2)))))

(define common
  (lambda (pair1 pair2)
    (if (= (car pair1) (car pair2))
      (if (= (cdr pair1) (cdr pair2))
        pair1
        (list))
      (list))))

(define lst1 (list (cons 1 3) (cons 4 2) (cons 5 6)))
(define lst2 (list (cons 1 6) (cons 4 2) (cons 1 3)))