// Define a node in the binary search tree
(define leaf
  (lambda (val)
    (cons #t val)
    ))

//(define root
//  (lambda (val left right)
//    (cons #f (cons val (cons left right)))
//    ))

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

// Constructor function: builds a BST from a list of numbers
(define bst
  (lambda (lst)
    (if (null? lst)
      (list)
      (insertHelper (list) lst)
      )
    ))

// Helper function to insert each element from list into the tree recursively
(define insertHelper
  (lambda (tree lst)
    (if (null? lst)
      tree
      (insertHelper (insertSingle tree (car lst)) (cdr lst))
      )
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
        (let ((nodeValue (car (cdr node))))
          (if (< val nodeValue)
            (root nodeValue (insertSingle (getLeft node) val) (getRight node))
            (root nodeValue (getLeft node) (insertSingle (getRight node) val))
            )
          )
        )
      )))
