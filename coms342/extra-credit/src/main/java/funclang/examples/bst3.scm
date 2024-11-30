// Define a node in the binary search tree
(define leaf
  (lambda (val)
    (list #t val (list) (list))))

(define root
  (lambda (val left right)
    (list #f val left right)))

// Check if a node is a leaf (has a single value)
(define isLeaf
  (lambda (node)
    (car node)))

// Get the value of a node
(define getValue
  (lambda (node)
    (car (cdr node))))

// Get the left child of a root node
(define getLeft
  (lambda (node)
    (car (cdr (cdr node)))))

// Get the right child of a root node
(define getRight
  (lambda (node)
    (car (cdr (cdr (cdr node))))))

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
(define insertValue
  (lambda (tree val)
    (if (isEmpty tree)
      (leaf val)
      (let ((current_val (getValue tree)))
        (if (isLeaf tree)
          (if (< val ( + current_val 1))
            (root current_val (leaf val) (list))
            (root current_val (list) (leaf val)))
          (if (< val ( + current_val 1))
            (root current_val
              (insertValue (getLeft tree) val)
              (getRight tree))
            (root current_val
              (getLeft tree)
              (insertValue (getRight tree) val))))))))

// Constructor function: builds a BST from a list of numbers
(define bst
  (lambda (numbers)
    (if (null? numbers)
      (list)
      (insert (bst (cdr numbers)) (list (car numbers))))))

// Insert a list of values into the BST
(define insert
  (lambda (tree values)
    (if (null? values)
      tree
      (insert (insertValue tree (car values)) (cdr values)))))

(define inOrder
  (lambda (tree result)
    (if (isEmpty tree)
      result
      (if (isLeaf tree)
        (cons (getValue tree) result)
        (let ((left_result (inOrder (getLeft tree) result)))
          (let ((root_result (cons (getValue tree) left_result)))
            (inOrder (getRight tree) root_result)))))))


// In-order traversal to get a sorted list of values in the BST
(define getlist
  (lambda (tree)
    (reverse (inOrder tree (list)))))

// Get a nested list structure representing the tree
(define gettree
  (lambda (tree)
    (if (isEmpty tree)
      (list)
      (if (isLeaf tree)
        (list (getValue tree) (list) (list))
        (list (getValue tree)
              (gettree (getLeft tree))
              (gettree (getRight tree)))))))