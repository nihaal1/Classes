//A placeholder strategy function that always returns false, regardless of input.
(define dummyStrategy : (num num -> bool)
                      (lambda (x : num y : num) #f))

//A reference to a list of key-function pairs, representing the strategy dictionary.
(define strategy : Ref List<(num,(num num -> bool))>
                 (ref: List<(num,(num num -> bool))> (list:(num,(num num -> bool)))))

//Checks if a given key matches the key in a key-function pair
(define keyMatch : (num (num,(num num -> bool)) -> bool)
                 (lambda (key : num pair : (num,(num num -> bool)))
                   (= key (car pair))))

//Retrieves the strategy function associated with a key, returns dummyStrategy if the key does not exist.
(define getStrategy : (num -> (num num -> bool))
                    (lambda (key : num)
                      (if (null? (deref strategy))
                        dummyStrategy
                        (if (keyMatch key (car (deref strategy)))
                          (cdr (car (deref strategy)))
                          (getStrategy key)))))

//Adds or updates a key-function pair in the strategy dictionary, returns true to indicate success.
(define setStrategy : (num (num num -> bool) -> bool)
                    (lambda (key : num fn : (num num -> bool))
                      (let ((x : List<(num,(num num -> bool))>
                              (set! strategy
                                (cons (cons key fn)
                                  (if (null? (deref strategy))
                                    (list:(num,(num num -> bool)))
                                    (deref strategy))))))
                        #t)))

// Applies the strategy function (associated with a given key) to two input numbers and returns the result.
(define applyStrategy : (num num num -> bool)
                      (lambda (key : num x : num y : num)
                        ((getStrategy key) x y)))