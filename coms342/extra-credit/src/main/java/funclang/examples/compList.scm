;(define compList
;  (lambda (lst)
;    (define compress_helper
;      (lambda (lst current_num result)
;        (if (null? lst)
;            result
;            (let ((first_element (car lst)))
;              (if (= first_element current_num)
;                  (compress_helper (cdr lst) current_num result)
;                  (compress_helper (cdr lst) first_element (cons first_element result))))))
;    (compress_helper lst #f ())
;
;      )
;    )
;  )
;
;(compList (list 1 2 2 3))
;(define append
;         (lambda (lst1 lst2)
;             (if (null? lst1)
;                 lst2
;                 (if (null? lst2)
;                    lst1
;                     (cons (car lst1)
;                        (append (cdr lst1) lst2))
;                     )
;                 )
;             )
;         )

;(define compList
;  (lambda (lst)
;    (if (null? lst)
;      ()
;      (if (null? (cdr lst))
;        lst
;        (if (= (car lst) (car(cdr lst)))
;          (compList (cdr lst))
;          (cons (car lst) (compList (cdr lst)))
;          )
;        )
;      )
;    )
;  )

;(define L (list 1 2 3))

(/
  (* (- 6 1) 2)
  (+ 1 1)
  )


;(define compList
;  (lambda (lst)
;    (if (null? lst)            ; Base case: if list is empty, return empty list
;      '()                      ; Return empty list if lst is empty (use '() instead of ())
;      (if (null? (cdr lst))     ; If there is only one element in the list, return the list
;        lst
;        (if (= (car lst) (car (cdr lst)))   ; Compare the first two elements
;          (compList (cdr lst))            ; If they are equal, skip the first element
;          (cons (car lst) (compList (cdr lst))) ; Otherwise, include the first element and recurse
;          )
;        )
;      )
;    )
;  )

;(compList (list 1 1 2 3 3 4 5))