// Define a node in the binary search tree
(define leaf
  (lambda (val)
    (list #t val (list) (list))
    ))


(define root
  (lambda (val left right)
//    (cons #f (cons val (cons left right)))
    (list #f val left right)
    ))

// Check if a node is a leaf (has a single value)
(define isLeaf
  (lambda (node)
    (car node)
    ))

// Get the value of a node
(define getValue
  (lambda (node)
    //(cdr node)
    (car (cdr node))
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

(define bst
  (lambda (lst)
    (if (null? lst)
      (list)
      (insert (list) lst)
      )))

(define insert
  (lambda (tree lst)
    (if (null? lst)
      tree
      (insert (insertSingle tree (car lst)) (cdr lst))
      )))

(define insertSingle
  (lambda (node val)
    (if (null? node)
      (leaf val)
      (if (isLeaf node)
        (if (< val (getValue node))
          (root (getValue node) (leaf val) (list))
          (root (getValue node) (list) (leaf val))
          )
        (let ((nodeValue (getValue node)))
          (if (< val nodeValue)
            (root nodeValue (insertSingle (getLeft node) val) (getRight node))
            (root nodeValue (getLeft node) (insertSingle (getRight node) val))
            )
          )
        )
      )))

(define getlist
  (lambda (node)
    (if (null? node)
      (list)  ; Return an empty list for an empty tree
      (if (isLeaf node)
        (list (getValue node))  ; If it's a leaf, return its value in a list
        (append (getlist (getLeft node))  ; In-order traversal: left, root, right
          (list (getValue node))
          (getlist (getRight node))
          )
        )
      )))

(define gettree
  (lambda (node)
    (if (null? node)
      (list)  ; Return an empty list for an empty tree
      (if (isLeaf node)
        (list (getValue node) (list) (list))  ; Leaf node structure
        (list (getValue node)
              (gettree (getLeft node))
              (gettree (getRight node))
          )
        )
      )))
