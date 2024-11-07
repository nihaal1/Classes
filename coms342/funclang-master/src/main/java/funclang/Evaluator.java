package funclang;

import funclang.Env.ExtendEnv;
import funclang.Env.GlobalEnv;

import java.util.ArrayList;
import java.util.List;

import static funclang.AST.*;
import static funclang.Value.NumVal;
import static funclang.Value.UnitVal;

public class Evaluator implements Visitor<Value> {

    private final Printer.Formatter ts = new Printer.Formatter();

    private final Env initialEnv = new GlobalEnv(); // new for DefineLang

    Value valueOf(Program p) {
        return (Value) p.accept(this, initialEnv);
    }

    @Override
    public Value visit(AddExp e, Env env) {
        List<Exp> operands = e.all();
        double result = 0;
        for (Exp exp : operands) {
            NumVal intermediate = (NumVal) exp.accept(this, env); // Dynamic type-checking
            result += intermediate.v(); //Semantics of AddExp in terms of the target language.
        }
        return new NumVal(result);
    }

    @Override
    public Value visit(UnitExp e, Env env) {
        return new UnitVal();
    }

    @Override
    public Value visit(NumExp e, Env env) {
        return new NumVal(e.v());
    }

    @Override
    public Value visit(BoolExp e, Env env) {
        return new Value.BoolVal(e.b());
    }

    @Override
    public Value visit(DivExp e, Env env) {
        List<Exp> operands = e.all();
        NumVal lVal = (NumVal) operands.getFirst().accept(this, env);
        double result = lVal.v();
        for (int i = 1; i < operands.size(); i++) {
            NumVal rVal = (NumVal) operands.get(i).accept(this, env);
            result = result / rVal.v();
        }
        return new NumVal(result);
    }

    @Override
    public Value visit(MultExp e, Env env) {
        List<Exp> operands = e.all();
        double result = 1;
        for (Exp exp : operands) {
            NumVal intermediate = (NumVal) exp.accept(this, env); // Dynamic type-checking
            result *= intermediate.v(); //Semantics of MultExp.
        }
        return new NumVal(result);
    }

    @Override
    public Value visit(Program p, Env env) {
        try {
            for (DefineDecl d : p.decls())
                d.accept(this, initialEnv);
            return (Value) p.e().accept(this, initialEnv);
        } catch (ClassCastException e) {
            return new Value.DynamicError(e.getMessage());
        }
    }

    @Override
    public Value visit(SubExp e, Env env) {
        List<Exp> operands = e.all();
        NumVal lVal = (NumVal) operands.getFirst().accept(this, env);
        double result = lVal.v();
        for (int i = 1; i < operands.size(); i++) {
            NumVal rVal = (NumVal) operands.get(i).accept(this, env);
            result = result - rVal.v();
        }
        return new NumVal(result);
    }

    @Override
    public Value visit(VarExp e, Env env) { // New for varlang
        return env.get(e.name());
    }

    @Override
    public Value visit(LetExp e, Env env) { // New for varlang.
        List<String> names = e.names();
        List<Exp> value_exps = e.value_exps();
        List<Value> values = new ArrayList<>(value_exps.size());

        for (Exp exp : value_exps)
            values.add((Value) exp.accept(this, env));

        Env new_env = env;
        for (int i = 0; i < names.size(); i++)
            new_env = new ExtendEnv(new_env, names.get(i), values.get(i));

        return (Value) e.body().accept(this, new_env);
    }

    @Override
    public Value visit(DefineDecl e, Env env) { // New for funclang.
        String name = e.name();
        Exp value_exp = e.value_exp();
        Value value = (Value) value_exp.accept(this, env);
        ((GlobalEnv) initialEnv).extend(name, value);
        return new Value.UnitVal();
    }

    @Override
    public Value visit(LambdaExp e, Env env) {
        // Create a function value with three components:
        //  1. formal parameters of the function - e.formals()
        //  2. actual body of the function - e.body()
        //  3. mapping from the free variables in the function body to their values.
        return new Value.FunVal(env, e.formals(), e.body());
    }

    @Override
    public Value visit(CallExp e, Env env) {
        Object result = e.operator().accept(this, env);
        if (!(result instanceof Value.FunVal operator))
            return new Value.DynamicError("Operator not a function in call " + ts.visit(e, env));
        //Dynamic checking
        List<Exp> operands = e.operands();

        // Call-by-value semantics
        List<Value> actuals = new ArrayList<Value>(operands.size());
        for (Exp exp : operands)
            actuals.add((Value) exp.accept(this, env));

        List<String> formals = operator.formals();
        if (formals.size() != actuals.size())
            return new Value.DynamicError("Argument mismatch in call " + ts.visit(e, env));

        Env fun_env = operator.env();
        for (int index = 0; index < formals.size(); index++)
            fun_env = new ExtendEnv(fun_env, formals.get(index), actuals.get(index));

        return (Value) operator.body().accept(this, fun_env);
    }

    @Override
    public Value visit(IfExp e, Env env) {
        Object result = e.conditional().accept(this, env);
        if (!(result instanceof Value.BoolVal condition))
            return new Value.DynamicError("Condition not a boolean in expression " + ts.visit(e, env));
        //Dynamic checking

        if (condition.v())
            return (Value) e.then_exp().accept(this, env);
        else return (Value) e.else_exp().accept(this, env);
    }

    @Override
    public Value visit(LessExp e, Env env) {
        Value.NumVal first = (Value.NumVal) e.first_exp().accept(this, env);
        Value.NumVal second = (Value.NumVal) e.second_exp().accept(this, env);
        return new Value.BoolVal(first.v() < second.v());
    }

    @Override
    public Value visit(EqualExp e, Env env) {
        Value.NumVal first = (Value.NumVal) e.first_exp().accept(this, env);
        Value.NumVal second = (Value.NumVal) e.second_exp().accept(this, env);
        return new Value.BoolVal(first.v() == second.v());
    }

    @Override
    public Value visit(GreaterExp e, Env env) {
        Value.NumVal first = (Value.NumVal) e.first_exp().accept(this, env);
        Value.NumVal second = (Value.NumVal) e.second_exp().accept(this, env);
        return new Value.BoolVal(first.v() > second.v());
    }

    @Override
    public Value visit(CarExp e, Env env) {
        Value.PairVal pair = (Value.PairVal) e.arg().accept(this, env);
        return pair.fst();
    }

    @Override
    public Value visit(CdrExp e, Env env) {
        Value.PairVal pair = (Value.PairVal) e.arg().accept(this, env);
        return pair.snd();
    }

    @Override
    public Value visit(ConsExp e, Env env) {
        Value first = (Value) e.fst().accept(this, env);
        Value second = (Value) e.snd().accept(this, env);
        return new Value.PairVal(first, second);
    }

    @Override
    public Value visit(ListExp e, Env env) {
        List<Exp> elemExps = e.elems();
        int length = elemExps.size();
        if (length == 0)
            return new Value.Null();

        //Order of evaluation: left to right e.g. (list (+ 3 4) (+ 5 4))
        Value[] elems = new Value[length];
        for (int i = 0; i < length; i++)
            elems[i] = (Value) elemExps.get(i).accept(this, env);

        Value result = new Value.Null();
        for (int i = length - 1; i >= 0; i--)
            result = new Value.PairVal(elems[i], result);
        return result;
    }

    @Override
    public Value visit(NullExp e, Env env) {
        Value val = (Value) e.arg().accept(this, env);
        return new Value.BoolVal(val instanceof Value.Null);
    }
}
