package funclang;

import java.util.List;

public interface Value {

    class NumVal implements Value {
        private final double _val;

        public NumVal(double v) {
            _val = v;
        }

        public double v() {
            return _val;
        }

        @Override
        public String toString() {
            return Double.toString(_val);
        }
    }

    class UnitVal implements Value {
        @Override
        public String toString() {
            return "";
        }
    }

    class DynamicError implements Value {
        private final String message;

        public DynamicError(String message) {
            this.message = message;
        }

        @Override
        public String toString() {
            return message;
        }
    }

    class FunVal implements Value { //New in the funclang
        private final Env _env;
        private final List<String> _formals;
        private final AST.Exp _body;

        public FunVal(Env env, List<String> formals, AST.Exp body) {
            _env = env;
            _formals = formals;
            _body = body;
        }

        public Env env() {
            return _env;
        }

        public List<String> formals() {
            return _formals;
        }

        public AST.Exp body() {
            return _body;
        }

        @Override
        public String toString() {
            StringBuilder result = new StringBuilder("(lambda ( ");
            for (String formal : _formals)
                result.append(formal).append(" ");
            result.append(") ");
            result.append(_body.accept(new Printer.Formatter(), _env));
            return result + ")";
        }
    }

    class BoolVal implements Value {
        private final boolean _val;

        public BoolVal(boolean v) {
            _val = v;
        }

        public boolean v() {
            return _val;
        }

        @Override
        public String toString() {
            if (_val) return "#t";
            return "#f";
        }
    }

    class PairVal implements Value {
        protected Value _fst;
        protected Value _snd;

        public PairVal(Value fst, Value snd) {
            _fst = fst;
            _snd = snd;
        }

        public Value fst() {
            return _fst;
        }

        public Value snd() {
            return _snd;
        }

        @Override
        public java.lang.String toString() {
            if (isList()) return listToString();
            return "(" + _fst.toString() + " " + _snd.toString() + ")";
        }

        private boolean isList() {
            if (_snd instanceof Value.Null) return true;
            return _snd instanceof PairVal && ((PairVal) _snd).isList();
        }

        private java.lang.String listToString() {
            StringBuilder result = new StringBuilder("(");
            result.append(_fst.toString());
            Value next = _snd;
            while (!(next instanceof Value.Null)) {
                result.append(" ").append(((PairVal) next)._fst.toString());
                next = ((PairVal) next)._snd;
            }
            return result + ")";
        }
    }

    class Null implements Value {
        @Override
        public String toString() {
            return "()";
        }
    }
}
