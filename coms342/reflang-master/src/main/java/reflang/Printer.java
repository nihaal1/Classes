package reflang;

import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Printer {
    public void print(Value v) {
        if (v instanceof Value.UnitVal) {
            System.out.println();
        } else if (!v.toString().isEmpty()) {
            System.out.println(v);
        }
    }

    public void print(Exception e) {
        System.out.println(e.getMessage());
    }

    public static class Formatter implements AST.Visitor<String> {

        public String visit(AST.AddExp e, Env env) {
            return "(+ %s)".formatted(
                    e.all().stream()
                            .map(exp -> exp.accept(this, env))
                            .map(Object::toString)
                            .collect(Collectors.joining(" ")));
        }

        public String visit(AST.UnitExp e, Env env) {
            return "unit";
        }

        public String visit(AST.NumExp e, Env env) {
            return "" + e.v();
        }

        @Override
        public String visit(AST.BoolExp e, Env env) {
            return e.b() ? "#t" : "#f";
        }

        public String visit(AST.DivExp e, Env env) {
            return "(/ %s)".formatted(
                    e.all().stream()
                            .map(exp -> exp.accept(this, env))
                            .map(Object::toString)
                            .collect(Collectors.joining(" ")));
        }

        public String visit(AST.MultExp e, Env env) {
            return "(* %s)".formatted(
                    e.all().stream()
                            .map(exp -> exp.accept(this, env))
                            .map(Object::toString)
                            .collect(Collectors.joining(" ")));
        }

        public String visit(AST.Program p, Env env) {
            return p.e().accept(this, env);
        }

        public String visit(AST.SubExp e, Env env) {
            return "(- %s)".formatted(
                    e.all().stream()
                            .map(exp -> exp.accept(this, env))
                            .map(Object::toString)
                            .collect(Collectors.joining(" ")));
        }

        public String visit(AST.VarExp e, Env env) {
            return e.name();
        }

        public String visit(AST.LetExp e, Env env) {
            return "(let (%s) %s)".formatted(
                    IntStream.range(0, e.names().size())
                            .mapToObj(i -> "(%s %s)".formatted(
                                    e.names().get(i),
                                    e.value_exps().get(i).accept(this, env)))
                            .map(Object::toString)
                            .collect(Collectors.joining(" ")),
                    e.body().accept(this, env)
            );
        }

        public String visit(AST.DefineDecl d, Env env) {
            return "(define %s %s)".formatted(
                    d.name(),
                    d.value_exp().accept(this, env));
        }

        @Override
        public String visit(AST.LambdaExp e, Env env) {
            return "(lambda (%s) %s)".formatted(
                    String.join(" ", e.formals()),
                    e.body().accept(this, env));
        }

        @Override
        public String visit(AST.CallExp e, Env env) {
            return "(%s %s)".formatted(
                    e.operator().accept(this, env),
                    e.operands().stream()
                            .map(opnd -> opnd.accept(this, env))
                            .map(Object::toString)
                            .collect(Collectors.joining(" "))
            );
        }

        @Override
        public String visit(AST.IfExp e, Env env) {
            return "(if %s %s %s)".formatted(
                    e.conditional().accept(this, env),
                    e.then_exp().accept(this, env),
                    e.else_exp().accept(this, env));
        }

        @Override
        public String visit(AST.LessExp e, Env env) {
            return "(< %s %s)".formatted(
                    e.first_exp().accept(this, env),
                    e.second_exp().accept(this, env));
        }

        @Override
        public String visit(AST.EqualExp e, Env env) {
            return "(= %s %s)".formatted(
                    e.first_exp().accept(this, env),
                    e.second_exp().accept(this, env));
        }

        @Override
        public String visit(AST.GreaterExp e, Env env) {
            return "(> %s %s)".formatted(
                    e.first_exp().accept(this, env),
                    e.second_exp().accept(this, env));
        }

        @Override
        public String visit(AST.CarExp e, Env env) {
            return "(car %s)".formatted(e.arg().accept(this, env));
        }

        @Override
        public String visit(AST.CdrExp e, Env env) {
            return "(cdr %s)".formatted(e.arg().accept(this, env));
        }

        @Override
        public String visit(AST.ConsExp e, Env env) {
            return "(cons %s %s)".formatted(
                    e.fst().accept(this, env),
                    e.snd().accept(this, env));
        }

        @Override
        public String visit(AST.ListExp e, Env env) {
            return "(list %s)".formatted(e.elems().stream()
                    .map(exp -> exp.accept(this, env))
                    .map(Object::toString)
                    .collect(Collectors.joining(" ")));
        }

        @Override
        public String visit(AST.NullExp e, Env env) {
            return "(null? %s)".formatted(e.arg().accept(this, env));
        }

        @Override
        public String visit(AST.RefExp e, Env env) {
            return "(ref %s)".formatted(e.value_exp().accept(this, env));
        }

        @Override
        public String visit(AST.AssignExp e, Env env) {
            return "(set! %s %s)".formatted(
                    e.lhs_exp().accept(this, env),
                    e.rhs_exp().accept(this, env));
        }

        @Override
        public String visit(AST.DerefExp e, Env env) {
            return "(deref %s)".formatted(e.loc_exp().accept(this, env));
        }

        @Override
        public String visit(AST.FreeExp e, Env env) {
            return "(free %s)".formatted(e.value_exp().accept(this, env));
        }
    }
}
