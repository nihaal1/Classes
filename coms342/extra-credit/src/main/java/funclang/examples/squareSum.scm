(define sumSQ
  (lambda (x y)
  (if (> x y) 0
  (+ (* x x) (sumSQ (+ x 1) y)))))

(sumSQ 2 4)