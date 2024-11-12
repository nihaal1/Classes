// Define a node in the binary search tree
(define leaf
  (lambda (val)
    (cons #t val)
    ))

(define root
  (lambda (val left right)
    (cons #f (cons val (cons left right)))
    ))

// Check if a node is a leaf (has a single value)
(define isLeaf
  (lambda (node)
    (car node)
    ))