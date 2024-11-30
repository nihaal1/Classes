// Define the strategy dictionary
(define strategy : Dict<num, (num num -> bool)>
  (dict : num (num num -> bool)))

// Get a strategy by key
(define getStrategy : (num -> (num num -> bool))
  (lambda (key : num)
    (if (contains? strategy key)
      (get strategy key)
      (lambda (x : num y : num) #f)))) // Return dummy function if key not found

// Set a strategy by key
(define setStrategy : (num (num num -> bool) -> bool)
  (lambda (key : num func : (num num -> bool))
    (begin
      (put strategy key func) // Update the dictionary
      #t))) // Always return true

// Apply a strategy to two numbers
(define applyStrategy : (num num num -> bool)
  (lambda (key : num a : num b : num)
    ((getStrategy key) a b))) // Retrieve the function and apply it
