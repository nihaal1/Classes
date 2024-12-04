(define frequency
  (lambda (lst elem)
    (if (null? lst)
      0
      (if (= (car lst) elem)
        (+ 1 (frequency (cdr lst) elem))
        (frequency (cdr lst) elem)))))
