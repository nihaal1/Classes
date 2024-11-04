(define leaf
  (lambda (val)
    (cons #t val)))

(define root
  (lambda (left right)
    (cons #f (cons (ref left) (ref right)))))

(define isLeaf
  (lambda (node)
    (car node)))

(define getValue
  (lambda (node)
    (cdr node)))

(define getleft
  (lambda (node)
    (car (cdr node))))

(define getright
  (lambda (node)
    (cdr (cdr node))))

(define treesum
  (lambda (node)
    (if (null? node)
      0
      (if (isLeaf node)
        (getValue node)
        (+ (treesum (deref (getleft node))) (treesum (deref (getright node))))))))