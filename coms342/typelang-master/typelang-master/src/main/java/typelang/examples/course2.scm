(define courseAndEnrollment : List<(num bool)>
                            (cons
                              (cons 3420 #t)
                              (cons
                                (cons 3090 #f)
                                (cons
                                  (cons 3310 #f)
                                  (list : (num bool))))))

(define extractFirst : ((num bool) -> num)
                     (lambda (pair : (num bool))
                       (if (null? pair)
                         0
                         (car pair))))

(define getTitle : (List<(num bool)> -> List<num>)
                 (lambda (courses : List<(num bool)>)
                   (letrec
                     ([collect
                        (lambda (remaining : List<(num bool)>
                                  accumulator : List<num>)
                          (if (null? remaining)
                            (reverse accumulator)
                            (collect
                              (cdr remaining)
                              (cons (extractFirst (car remaining))
                                accumulator))))])
                     (collect courses (list : num)))))

(define procStudent : (List<(num bool)> (List<(num bool)> -> List<num>) -> List<num>)
                    (lambda (courses : List<(num bool)>
                              titleFn : (List<(num bool)> -> List<num>))
                      (titleFn courses)))