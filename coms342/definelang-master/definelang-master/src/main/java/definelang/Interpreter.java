package definelang;

import definelang.AST.Program;

/**
 * This main class implements the Read-Eval-Print-Loop of the interpreter with
 * the help of Reader, Evaluator, and Printer classes.
 *
 * @author hridesh, clay
 */
public class Interpreter {
    public static void main(String[] args) {
        System.out.println("""
                Type a program to evaluate and press the enter key, e.g. (let ((a 3) (b 100) (c 84) (d 279) (e 277)) (+ (* a b) (/ c (- d e))))
                Press Ctrl + C to exit.
                """);
        try (Reader reader = new Reader()) {
            Evaluator eval = new Evaluator();
            Printer printer = new Printer();
            // Read-Eval-Print-Loop (also known as REPL)
            while (true) {
                Program p;
                try {
                    p = reader.read();
                    if (p == null) {
                        System.out.println();
                        break;
                    } else if (p._e == null) {
                        System.out.println();
                    } else {
                        Value val = eval.valueOf(p);
                        printer.print(val);
                    }
                } catch (Env.LookupException e) {
                    printer.print(e);
                } catch (Exception e) {
                    System.err.println("Error:" + e.getMessage());
                }
            }
        } catch (Exception e) {
            System.err.println("Error closing the input stream:" + e.getMessage());
        }
    }
}
