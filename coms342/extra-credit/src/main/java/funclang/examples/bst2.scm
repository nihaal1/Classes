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

//check if tree is empty
(define isEmpty
  (lambda (tree)
    (null? tree)))

//append function
(define append
        (lambda (lst1 lst2)
          (if (null? lst1)
            lst2
            (cons (car lst1)
              (append (cdr lst1) lst2)))))

//reverse function
(define reverse
        (lambda (lst)
          (if (null? lst)
            lst
            (append (reverse (cdr lst))
              (list (car lst))))))

// Helper function for inserting a single value into the BST
//(define insertSingle
//  (lambda (tree val)
//    (if (isEmpty tree)
//      (leaf val)
//      (if (isLeaf tree)
//        (if (< val (getValue tree))
//          (root (getValue tree) (leaf val) (list))
//          (root (getValue tree) (list) (leaf val))
//          )
//       (let ((nodeValue (getValue tree)))
//          (if (< val nodeValue)
//            (root nodeValue (insertSingle (getLeft tree) val) (getRight tree))
//            (root nodeValue (getLeft tree) (insertSingle (getRight tree) val))
//            )
//          )
//        )
//      )))

(define insertSingle
  (lambda (tree val)
    (if (isEmpty tree)
      (leaf val)
      (let ((current_val (getValue tree)))
        (if (isLeaf tree)
          (if (< val current_val)
            (root current_val (leaf val) (list))
            (root current_val (list) (leaf val)))
          (if (< val current_val)
            (root current_val
              (insertSingle (getLeft tree) val)
              (getRight tree))
            (root current_val
              (getLeft tree)
              (insertSingle (getRight tree) val))))))))

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
      //(insert (list) lst)
      (insert (bst (cdr lst)) (list (car lst)))
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
