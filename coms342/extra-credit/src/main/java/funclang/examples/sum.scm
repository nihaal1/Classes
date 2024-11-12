(define sum
  (lambda (n)
    (if (= n 1) 1
                (+n (sum (- n 1))))))

(sum 3)