(define make_node
  (lambda (value left right)
    (list value left right)))

(define get_value
  (lambda (node)
    (car node)))

(define get_left
  (lambda (node)
    (car (cdr node))))

(define get_right
  (lambda (node)
    (car (cdr (cdr node)))))

(define is_empty
  (lambda (tree)
    (null? tree)))

(define bst
  (lambda (numbers)
    (if (null? numbers)
      (list)
      (insert (bst (cdr numbers)) (list (car numbers))))))

(define insert_value
  (lambda (tree value)
    (if (is_empty tree)
      (make_node value (list) (list))
      (let ((root_val (get_value tree))
             (left (get_left tree))
             (right (get_right tree)))
        (if (< value root_val)
          (make_node root_val (insert_value left value) right)
          (make_node root_val left (insert_value right value)))))))

(define insert
  (lambda (tree values)
    (if (null? values)
      tree
      (insert (insert_value tree (car values)) (cdr values)))))

(define in_order
  (lambda (tree result)
    (if (is_empty tree)
      result
      (let ((left_result (in_order (get_left tree) result)))
        (let ((root_result (cons (get_value tree) left_result)))
          (in_order (get_right tree) root_result))))))

(define getlist
  (lambda (tree)
    (reverse (in_order tree (list)))))

(define gettree
  (lambda (tree)
    (if (is_empty tree)
      (list)
      (make_node (get_value tree)
        (gettree (get_left tree))
        (gettree (get_right tree))))))