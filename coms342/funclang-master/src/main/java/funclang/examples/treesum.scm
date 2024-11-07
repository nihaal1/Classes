(define leaf
  (lambda (value)
    (lambda (op)
      (if op value #f))))

(define root
  (lambda (left right)
    (lambda (op)
      (if op (list left right) #f))))

(define treesum
  (lambda (node)
    (if (node #f)
      (node #t)
      (let ((children (node #t)))
        (+ (treesum (car children))
          (treesum (car (cdr children))))))))

