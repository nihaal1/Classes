(define leaf
  (lambda (val)
    (list #t val (list) (list))))

(define root
  (lambda (val left right)
    (list #f val left right)))

(define isLeaf
  (lambda (node)
    (car node)))

(define getValue
  (lambda (node)
    (car (cdr node))))

(define getLeft
  (lambda (node)
    (car (cdr (cdr node)))))

(define getRight
  (lambda (node)
    (car (cdr (cdr (cdr node))))))

(define isEmpty
  (lambda (tree)
    (null? tree)))

(define insertValue
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
              (insertValue (getLeft tree) val)
              (getRight tree))
            (root current_val
              (getLeft tree)
              (insertValue (getRight tree) val))))))))

(define bst
  (lambda (numbers)
    (if (null? numbers)
      (list)
      (insert (bst (cdr numbers)) (list (car numbers))))))

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


(define getlist
  (lambda (tree)
    (reverse (inOrder tree (list)))))

(define gettree
  (lambda (tree)
    (if (isEmpty tree)
      (list)
      (if (isLeaf tree)
        (list (getValue tree) (list) (list))
        (list (getValue tree)
              (gettree (getLeft tree))
              (gettree (getRight tree)))))))