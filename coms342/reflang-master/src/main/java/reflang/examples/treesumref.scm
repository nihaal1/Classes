(define leaf
  (lambda (val)
    (cons #t val)
    ))

(define root
  (lambda (left right)
    (cons #f (cons (ref left) (ref right)))
    ))

(define isLeaf
  (lambda (node)
    (car node)
    ))

(define getValue
  (lambda (node)
    (cdr node)
    ))

(define getleft
  (lambda (node)
    (deref (car (cdr node)))
    ))

(define getright
  (lambda (node)
    (deref (cdr (cdr node)))
    ))

(define treesum
  (lambda (node)
    (if (isLeaf node)
      (getValue node)
      (+ (treesum (getleft node))
        (treesum (getright node)))
      )
    ))