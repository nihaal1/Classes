(define contains? : ((List<num> num) -> bool)
                  (lambda (lst : List<num> x : num)
                    (if (null? lst)
                      #f
                      (if (= (car lst) x)
                        #t
                        (contains? (cdr lst) x)))))

(define remove-earlier-occurrences : (List<num> -> List<num>)
                                   (lambda (lst : List<num>)
                                     (if (null? lst)
                                       (list : num)
                                       (let ((x : num (car lst))
                                              (rest : List<num> (cdr lst)))
                                         (if (contains? rest x)
                                           (remove-earlier-occurrences rest)
                                           (cons x (remove-earlier-occurrences rest)))))))

(define unique : (List<num> -> List<num>)
               (lambda (lst : List<num>)
                 (remove-earlier-occurrences lst)))