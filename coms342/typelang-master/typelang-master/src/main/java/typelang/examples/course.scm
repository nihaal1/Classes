//Contains three pairs representing courses and enrollment status
(define courseAndEnrollment : List<(num, bool)>
                            (list : (num, bool)
                                  (cons 3420 #t)
                                  (cons 3090 #f)
                                  (cons 3310 #f)))

//Used to extract course numbers from pairs
(define getFirst : ((num, bool) -> num)
                 (lambda (pair : (num, bool))
                   (car pair)))

//Recursively builds a list of course numbers by extracting first element from each pair
(define getTitle : (List<(num, bool)> -> List<num>)
                 (lambda (courses : List<(num, bool)>)
                   (if (null? courses)
                     (list : num)
                     (cons (getFirst (car courses))
                       (getTitle (cdr courses))))))

//(define procStudent : ((List<(num, bool)> -> List<num>) List<(num, bool)> -> List<num>)
//                    (lambda (titleFn : (List<(num, bool)> -> List<num>)
//                              courses : List<(num, bool)>)
//                      (titleFn courses)))

//Applies the input function to the input list
(define procStudent : (List<(num, bool)> (List<(num, bool)> -> List<num>) -> List<num>)
                    (lambda (courses : List<(num, bool)>
                              titleFn : (List<(num, bool)> -> List<num>))
                      (titleFn courses)))