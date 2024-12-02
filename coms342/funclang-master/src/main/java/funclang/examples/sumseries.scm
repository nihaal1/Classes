(define sumseries
  (lambda (x)
    (if (= x 0)
      0
      (+ (* x x) (sumseries (- x 1))))
      ))