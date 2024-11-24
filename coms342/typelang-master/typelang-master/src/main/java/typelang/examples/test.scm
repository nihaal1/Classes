(define member
  (lambda (x lst)
    (if (null? lst)
      #f
      (if (= (car lst) x)
        #t
        (member x (cdr lst))))))


(member 2 (list 1 2 3))
