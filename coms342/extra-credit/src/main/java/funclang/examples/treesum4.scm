(define leaf
  (lambda (val)
    (cons #t val)
    )
  )

(define root
  (lambda (left right)
    (cons #f (cons left right))
    )
  )

(define isLeaf
  (lambda (node)
    (car node)
    )
  )

(define get_Value
  (lambda (node)
    (cdr node)
    )
  )

(define left_Child
  (lambda (node)
    (car (cdr node))
    )
  )

(define right_Child
  (lambda (node)
    (cdr (cdr node)
      )
    )
  )

(define treesum
  (lambda (node)
    (if (isLeaf node)
      (get_Value node)
      (+ (treesum (left_Child node)
           )
        (treesum (right_Child node))
        )
      )
    )
  )

(treesum (root (root (leaf 5) (root (leaf 5) (leaf 5))) (leaf 5)))