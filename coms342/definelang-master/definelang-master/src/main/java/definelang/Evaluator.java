package definelang;

import definelang.Env.ExtendEnv;
import definelang.Env.GlobalEnv;

import java.util.ArrayList;
import java.util.List;

import static definelang.AST.*;
import static definelang.Value.NumVal;
import static definelang.Value.UnitVal;

public class Evaluator implements Visitor<Value> {
    private final Env initialEnv = new GlobalEnv(); // new for DefineLang

    Value valueOf(Program p) {
        return (Value) p.accept(this, initialEnv);
    }

    @Override
    public Value visit(AddExp e, Env env) {
        List<Exp> operands = e.all();
        double result = 0;
        for (Exp exp : operands) {
            NumVal intermediate = (NumVal) exp.accept(this, env);
            result += intermediate.v();
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
            NumVal intermediate = (NumVal) exp.accept(this, env);
            result *= intermediate.v();
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

//        for (Exp exp : value_exps)
//            values.add((Value) exp.accept(this, env));

//        for (int i = 0; i < names.size(); i++)
//            new_env = new ExtendEnv(new_env, names.get(i), values.get(i));

        Env new_env = env;
        for (int i = names.size() - 1; i >= 0; i--) {
//            String name = names.get(i);
            Exp exp = value_exps.get(i);
            Value value = (Value) exp.accept(this, new_env);
//            new_env = new ExtendEnv(new_env, names.get(i), values.get(i));
            new_env = new ExtendEnv(new_env, names.get(i), value);
        }
        return (Value) e.body().accept(this, new_env);
    }

    @Override
    public Value visit(DefineDecl e, Env env) { // New for definelang.
        String name = e.name();
        Exp value_exp = e.value_exp();
        Value value = (Value) value_exp.accept(this, env);
        ((GlobalEnv) initialEnv).extend(name, value);
        return new Value.UnitVal();
    }
}
