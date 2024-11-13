// Define a node in the binary search tree
(define leaf
  (lambda (val)
    (list #t val (list) (list))
    ))

(define root
  (lambda (val left right)
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

// Helper function for inserting a single value into the BST
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

// Insert a list of values into the BST
(define insert
  (lambda (tree lst)
    (if (null? lst)
      tree
      (insert (insertSingle tree (car lst)) (cdr lst))
      )))

// Constructor function: builds a BST from a list of numbers
(define bst
  (lambda (lst)
    (if (null? lst)
      (list)
      (insert (list) lst)
      )))

// In-order traversal to get a sorted list of values in the BST
(define getlist
  (lambda (node)
    (if (null? node)
      (list)
      (if (isLeaf node)
        (list (getValue node))
        (append (getlist (getLeft node))
          (list (getValue node))
          (getlist (getRight node))
          )
        )
      )))

// Get a nested list structure representing the tree
(define gettree
  (lambda (node)
    (if (null? node)
      (list)
      (if (isLeaf node)
        (list (getValue node) (list) (list))
        (list (getValue node)
              (gettree (getLeft node))
              (gettree (getRight node))
          )
        )
      )))
