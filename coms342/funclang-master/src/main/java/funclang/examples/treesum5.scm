(define leaf
  (lambda (value)
    (lambda (op)
      (if op
        #t
        value))))

(define root
  (lambda (left right)
    (lambda (op)
      (if op
        left
        right))))

(define isleaf
  (lambda (node)
    (node #t)))

(define leafvalue
  (lambda (node)
    (node #f)))

(define leftchild
  (lambda (node)
    (node #t)))

(define rightchild
  (lambda (node)
    (node #f)))

(define treesum
  (lambda (node)
    (if (is-leaf node)
      (leaf-value node)
      (+ (treesum (left-child node))
        (treesum (right-child node))))))