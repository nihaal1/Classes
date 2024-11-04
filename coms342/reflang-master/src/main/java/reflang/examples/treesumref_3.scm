(define leaf
  (lambda (val)
    (cons #t val)))

(define root
  (lambda (left right)
    (cons #f (cons (ref left) (ref right)))))

(define isLeaf
  (lambda (node)
    (car node)))

(define get_Value
  (lambda (node)
    (cdr node)))

(define getleft
  (lambda (node)
    (car (cdr node))))

(define getright
  (lambda (node)
    (cdr (cdr node))))

(define safe_deref
  (lambda (ref)
    (if (null? (deref ref))
      (list)
      (deref ref))))

(define treesum
  (lambda (node)
    (if (null? node)
      0
      (if (isLeaf node)
        (get_Value node)
        (+ (treesum (safe_deref (getleft node)))
          (treesum (safe_deref (getright node))))))))