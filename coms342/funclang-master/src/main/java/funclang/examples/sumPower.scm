(define sumPower
  (lambda (lst)
    (if (null? lst)
      0
      (+ (pow (car lst)) (sumPower (cdr lst))))))

(define pow
  (lambda (num)
    (* num num)))