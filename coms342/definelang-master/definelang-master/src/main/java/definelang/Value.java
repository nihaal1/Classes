package definelang;

public interface Value {
    String toString();

    class NumVal implements Value {
        private final double _val;

        public NumVal(double v) {
            _val = v;
        }

        public double v() {
            return _val;
        }

        public String toString() {
            int tmp = (int) _val;
            if (tmp == _val) return "" + tmp;
            return "" + _val;
        }
    }

    class UnitVal implements Value {
        public static final UnitVal v = new UnitVal();

        public String toString() {
            return "";
        }
    }

    class DynamicError implements Value {
        private final String message;

        public DynamicError(String message) {
            this.message = message;
        }

        public String toString() {
            return message;
        }
    }
}
