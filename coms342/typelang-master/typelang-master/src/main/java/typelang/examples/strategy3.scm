(define dummyStrategy : (num num -> bool)
  (lambda (x : num y : num) #f))

(define strategy : List<(num, (num num -> bool))>
 (list : (num, (num num -> bool))))

(define keyMatch : (num (num, (num num -> bool)) -> bool)
  (lambda (key : num pair : (num, (num num -> bool)))
   (= key (car pair))))

(define getStrategy : (num -> (num num -> bool))
  (lambda (key : num)
    (if (null? strategy)
      dummyStrategy
      (if (keyMatch key (car strategy))
        (cdr (car strategy))
        (getStrategy key)))))


(define setStrategy : (num (num num -> bool) -> bool)
  (lambda (key : num fn : (num num -> bool))
    (let ((result : bool
            (set! strategy
              (cons (cons key fn)
                (if (null? strategy)
                  (list : (num (num num -> bool)))
                  strategy)))))
      #t)))

(define applyStrategy : (num num num -> bool)
  (lambda (key : num x : num y : num)
    ((getStrategy key) x y)))