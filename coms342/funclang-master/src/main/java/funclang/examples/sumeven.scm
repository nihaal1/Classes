//sumeven goes through each element, checks if even, if yes, adds it, else ignores it

(define sumeven
  (lambda (lst)
    (if (null? lst)
      0
      (if (= 0(mod (car lst) 2))
        (+ (car lst) (sumeven (cdr lst)))
        (sumeven (cdr lst))
          )
      )))


(define mod
  (lambda (x y)
    (if (< x y)
      x
      (mod (- x y) y))))