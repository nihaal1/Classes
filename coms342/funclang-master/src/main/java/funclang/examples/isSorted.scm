(define asc
  (lambda (lst)
    (if (null? lst) #t
         (if (null? (cdr lst)) #t
             (if (> (car lst) (car (cdr lst))) #f
                  (asc (cdr lst)
                    )
           )
         )
      )
    )
  )

(define dsc
  (lambda (lst)
    (if(null? lst) #t
       (if (null? (cdr lst)) #t
         (if (< (car lst) (car (cdr lst))) #f
           (dsc (cdr lst))
           )
         )
      )
    )
  )

(define isSorted
  (lambda (lst)
    (if (asc lst) #t
     (if (dsc lst) #t
       #f
       )
      )
    )
  )

//(isSorted (list 1 2 3 4 5))