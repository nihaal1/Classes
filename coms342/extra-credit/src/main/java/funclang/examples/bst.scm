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

// Get the value of a node
(define getValue
  (lambda (node)
    (cdr node)
    ))

// Get the left child of a root node
(define getLeft
  (lambda (node)
    (car (cdr (cdr node)))
    ))

// Get the right child of a root node
(define getRight
  (lambda (node)
    (cdr (cdr (cdr node)))
    ))
