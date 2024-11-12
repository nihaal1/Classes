(define leaf
  (lambda (value)
    (lambda (op)
      (if op value #f))))

(define root
  (lambda (left right)
    (lambda (op)
      (if op (list left right) #f))))

(define myroot (root (leaf 2) (leaf 3)))

(define children (myroot #t))

(+((car children) #t)
((car (cdr children)) #t))