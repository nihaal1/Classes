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
    (car (cdr node))
    ))

(define getright
  (lambda (node)
    (cdr (cdr node))
    ))

(define isNull
  (lambda (node)
    (null? node)
    ))

//(define treesum
//  (lambda (node)
//    (if (isLeaf node)
//      (getValue node)
//      (+ (if (isNull (getleft node)) 0 (treesum (deref (getleft node))))
//        (if (isNull (getright node)) 0 (treesum (deref (getright node)))))
//      )))

(define treesum
  (lambda (node)
    (if (isNull node)
      0
      (if (isLeaf node)
        (getValue node)
        (+ (treesum (if (isNull (getleft node)) 0 (deref (getleft node))))
          (treesum (if (isNull (getright node)) 0 (deref (getright node)))))
        ))))