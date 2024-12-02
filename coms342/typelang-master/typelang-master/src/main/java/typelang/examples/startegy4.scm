(define strategyLog : Ref List<(num (num num -> bool))>
                    (ref: List<(num (num num -> bool))> (list: (num (num num -> bool)))))

(define fallbackStrategy : (num num -> bool)
                         (lambda (a : num b : num)
                           (if (= a b) #f #f)))

(define strategyExists : (num -> bool)
                       (lambda (key : num)
                         (letrec
                           ([search
                              (lambda (log : List<(num (num num -> bool))>)
                                (if (null? log)
                                  #f
                                  (if (= key (car (car log)))
                                    #t
                                    (search (cdr log)))))])
                           (search (deref strategyLog)))))

(define fetchStrategy : (num -> (num num -> bool))
                      (lambda (key : num)
                        (letrec
                          ([find
                             (lambda (log : List<(num (num num -> bool))>)
                               (if (null? log)
                                 fallbackStrategy
                                 (if (= key (car (car log)))
                                   (cdr (car log))
                                   (find (cdr log)))))])
                          (find (deref strategyLog)))))

(define registerStrategy : (num (num num -> bool) -> bool)
                         (lambda (key : num handler : (num num -> bool))
                           (let ((updated : List<(num (num num -> bool))>
                                   (set! strategyLog
                                     (cons (cons key handler)
                                       (if (strategyExists key)
                                         (let ((filtered : List<(num (num num -> bool))>
                                                 (filter
                                                   (lambda (entry : (num (num num -> bool)))
                                                     (not (= key (car entry))))
                                                   (deref strategyLog))))
                                           filtered)
                                         (deref strategyLog))))))
                             #t)))

(define executeStrategy : (num num num -> bool)
                        (lambda (key : num x : num y : num)
                          ((fetchStrategy key) x y)))