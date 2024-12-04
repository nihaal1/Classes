//revserse, append (car lst) and construct new list using cons

(define reverse
  (lambda (lst)
    (if (null? lst)
      lst
      (append (reverse (cdr lst))(list (car lst))))))

(define append
  (lambda (lst1 lst2)
    (if (null? lst1)
      lst2
      (if (null? lst2)
        lst1
        (cons (car lst1) (append (cdr lst1) lst2))))))