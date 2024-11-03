(define compList
    (lambda (lst)
        (define compress_helper
            (lambda (lst current_num result )
                (if (null? lst)
                    result
                (let ((first_element (car lst)))
                    (if (= first_element current_num)
                        (compress_helper (cdr lst) current_num result)
                        (compress_helper (cdr lst) first_element (cons first_element result)))))
            )
        )
    (compress_helper lst #f ())
)
