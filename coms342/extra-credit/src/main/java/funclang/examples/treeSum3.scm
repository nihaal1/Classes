(define leaf
  (lambda (value)
    (lambda (op)
      (if op value #f))))

(define root
  (lambda (left right)
    (lambda (op)
      (if op (list left right) #f))))

(define ifLeaf
  (lambda (node trueFunc)
    (if (node #f)
      (trueFunc (node #t))
      #f)))

(define ifRoot
  (lambda (node trueFunc)
    (if (node #f)
      #f
      (trueFunc (node #t)))))

(define treesum
  (lambda (node)
    (ifLeaf node
      (lambda (value)
        value)
      (ifRoot node
        (lambda (children)
          (+ (treesum (car children))
            (treesum (car (cdr children)))))))))