package definelang;

import java.util.List;

public class Printer {
    public void print(Value v) {
        if (!v.toString().isEmpty()) System.out.println(v);
    }

    public void print(Exception e) {
        System.out.println(e.getMessage());
    }

    public static class Formatter implements AST.Visitor<String> {

        public String visit(AST.AddExp e, Env env) {
            StringBuilder result = new StringBuilder("(+ ");
            for (AST.Exp exp : e.all())
                result.append(exp.accept(this, env)).append(" ");
            return result + ")";
        }

        public String visit(AST.UnitExp e, Env env) {
            return "unit";
        }

        public String visit(AST.NumExp e, Env env) {
            return "" + e.v();
        }

        public String visit(AST.DivExp e, Env env) {
            StringBuilder result = new StringBuilder("(/ ");
            for (AST.Exp exp : e.all())
                result.append(exp.accept(this, env)).append(" ");
            return result + ")";
        }

        public String visit(AST.MultExp e, Env env) {
            StringBuilder result = new StringBuilder("(* ");
            for (AST.Exp exp : e.all())
                result.append(exp.accept(this, env)).append(" ");
            return result + ")";
        }

        public String visit(AST.Program p, Env env) {
            return "" + p.e().accept(this, env);
        }

        public String visit(AST.SubExp e, Env env) {
            StringBuilder result = new StringBuilder("(- ");
            for (AST.Exp exp : e.all())
                result.append(exp.accept(this, env)).append(" ");
            return result + ")";
        }

        public String visit(AST.VarExp e, Env env) {
            return e.name();
        }

        public String visit(AST.LetExp e, Env env) {
            StringBuilder result = new StringBuilder("(let (");
            List<String> names = e.names();
            List<AST.Exp> value_exps = e.value_exps();
            int num_decls = names.size();
            for (int i = 0; i < num_decls; i++) {
                result.append(" (");
                result.append(names.get(i)).append(" ");
                result.append(value_exps.get(i).accept(this, env)).append(")");
            }
            result.append(") ");
            result.append(e.body().accept(this, env)).append(" ");
            return result + ")";
        }

        public String visit(AST.DefineDecl d, Env env) {
            return "(define %s %s)".formatted(d.name(), d.value_exp().accept(this, env));
        }
    }
}
