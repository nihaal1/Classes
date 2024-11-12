(define compList
  (lambda (lst)
    (if (null? lst) (list)
      (if (null? (cdr lst)) lst
        (if (= (car lst) (car (cdr lst)))
          (compList (cdr lst))
          (cons (car lst) (compList (cdr lst)))
          )
        )
      )
    )
  )

(compList (list 1 1 2 3 3 4 5))