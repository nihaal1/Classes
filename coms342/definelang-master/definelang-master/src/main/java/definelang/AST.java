package definelang;

import java.util.ArrayList;
import java.util.List;

/**
 * This class hierarchy represents expressions in the abstract syntax tree
 * manipulated by this interpreter.
 *
 * @author hridesh, clay
 */
@SuppressWarnings("rawtypes")
public interface AST {
    interface Visitor<T> {
        // This interface should contain a signature for each concrete AST node.
        T visit(AST.AddExp e, Env env);

        T visit(AST.UnitExp e, Env env);

        T visit(AST.NumExp e, Env env);

        T visit(AST.DivExp e, Env env);

        T visit(AST.MultExp e, Env env);

        T visit(AST.Program p, Env env);

        T visit(AST.SubExp e, Env env);

        T visit(AST.VarExp e, Env env); // New for varlang

        T visit(AST.LetExp e, Env env); // New for varlang

        T visit(AST.DefineDecl d, Env env); // New for definelang

    }

    abstract class ASTNode implements AST {
        public abstract Object accept(Visitor visitor, Env env);
    }

    class Program extends ASTNode {
        final List<DefineDecl> _decls;
        final Exp _e;

        public Program(List<DefineDecl> decls, Exp e) {
            _decls = decls;
            _e = e;
        }

        public Exp e() {
            return _e;
        }

        public List<DefineDecl> decls() {
            return _decls;
        }

        public Object accept(Visitor visitor, Env env) {
            return visitor.visit(this, env);
        }
    }

    abstract class Exp extends ASTNode {
        /* no-op */
    }

    class VarExp extends Exp {
        final String _name;

        public VarExp(String name) {
            _name = name;
        }

        public String name() {
            return _name;
        }

        public Object accept(Visitor visitor, Env env) {
            return visitor.visit(this, env);
        }
    }

    class UnitExp extends Exp {

        public UnitExp() {
            /* no-op */
        }

        public Object accept(Visitor visitor, Env env) {
            return visitor.visit(this, env);
        }

    }

    class NumExp extends Exp {
        final double _val;

        public NumExp(double v) {
            _val = v;
        }

        public double v() {
            return _val;
        }

        public Object accept(Visitor visitor, Env env) {
            return visitor.visit(this, env);
        }
    }

    abstract class CompoundArithExp extends Exp {
        final List<Exp> _rest;

        public CompoundArithExp() {
            _rest = new ArrayList<>();
        }

        public CompoundArithExp(Exp fst) {
            _rest = new ArrayList<>();
            _rest.add(fst);
        }

        public CompoundArithExp(List<Exp> args) {
            _rest = new ArrayList<>();
            _rest.addAll(args);
        }

        public CompoundArithExp(Exp fst, List<Exp> rest) {
            _rest = new ArrayList<>();
            _rest.add(fst);
            _rest.addAll(rest);
        }

        public CompoundArithExp(Exp fst, Exp second) {
            _rest = new ArrayList<>();
            _rest.add(fst);
            _rest.add(second);
        }

        public Exp fst() {
            return _rest.getFirst();
        }

        public Exp snd() {
            return _rest.get(1);
        }

        public List<Exp> all() {
            return _rest;
        }

        public void add(Exp e) {
            _rest.add(e);
        }

    }

    class AddExp extends CompoundArithExp {
        public AddExp(Exp fst) {
            super(fst);
        }

        public AddExp(List<Exp> args) {
            super(args);
        }

        public AddExp(Exp fst, List<Exp> rest) {
            super(fst, rest);
        }

        public AddExp(Exp left, Exp right) {
            super(left, right);
        }

        public Object accept(Visitor visitor, Env env) {
            return visitor.visit(this, env);
        }
    }

    class SubExp extends CompoundArithExp {

        public SubExp(Exp fst) {
            super(fst);
        }

        public SubExp(List<Exp> args) {
            super(args);
        }

        public SubExp(Exp fst, List<Exp> rest) {
            super(fst, rest);
        }

        public SubExp(Exp left, Exp right) {
            super(left, right);
        }

        public Object accept(Visitor visitor, Env env) {
            return visitor.visit(this, env);
        }
    }

    class DivExp extends CompoundArithExp {
        public DivExp(Exp fst) {
            super(fst);
        }

        public DivExp(List<Exp> args) {
            super(args);
        }

        public DivExp(Exp fst, List<Exp> rest) {
            super(fst, rest);
        }

        public DivExp(Exp left, Exp right) {
            super(left, right);
        }

        public Object accept(Visitor visitor, Env env) {
            return visitor.visit(this, env);
        }
    }

    class MultExp extends CompoundArithExp {
        public MultExp(Exp fst) {
            super(fst);
        }

        public MultExp(List<Exp> args) {
            super(args);
        }

        public MultExp(Exp fst, List<Exp> rest) {
            super(fst, rest);
        }

        public MultExp(Exp left, Exp right) {
            super(left, right);
        }

        public Object accept(Visitor visitor, Env env) {
            return visitor.visit(this, env);
        }
    }

    /**
     * A let expression has the syntax
     * <p>
     * (let ((name expression)* ) expression)
     *
     * @author hridesh
     */
    class LetExp extends Exp {
        final List<String> _names;
        final List<Exp> _value_exps;
        final Exp _body;

        public LetExp(List<String> names, List<Exp> value_exps, Exp body) {
            _names = names;
            _value_exps = value_exps;
            _body = body;
        }

        public Object accept(Visitor visitor, Env env) {
            return visitor.visit(this, env);
        }

        public List<String> names() {
            return _names;
        }

        public List<Exp> value_exps() {
            return _value_exps;
        }

        public Exp body() {
            return _body;
        }

    }

    class DefineDecl extends Exp {
        final String _name;
        final Exp _value_exp;

        public DefineDecl(String name, Exp value_exp) {
            _name = name;
            _value_exp = value_exp;
        }

        public Object accept(Visitor visitor, Env env) {
            return visitor.visit(this, env);
        }

        public String name() {
            return _name;
        }

        public Exp value_exp() {
            return _value_exp;
        }

    }
}
