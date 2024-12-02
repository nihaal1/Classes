(define member
  (lambda (x lst)
    (if (null? lst)
      #f
      (if (= (car lst) x)
        #t
        (member x (cdr lst)))
      )
    )
  )

(define unique
  (lambda (lst)
    (if (null? lst)
      (list)
      (if (member (car lst) (cdr lst))
        (unique (cdr lst))
        (cons (car lst) (unique (cdr lst)))
        )
      )
    )
  )