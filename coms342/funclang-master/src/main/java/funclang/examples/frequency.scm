//frequency, check how frequent an elemnt is in a list

(define frequency
  (lambda (lst x)
    (if (null? lst)
      0
      (if (= (car lst) x)
        (+ 1 (frequency (cdr lst) x))
        (frequency (cdr lst) x)))))