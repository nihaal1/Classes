package reflang;

import java.util.HashMap;
import java.util.Map;

/**
 * Representation of an environment, which maps variables to values.
 *
 * @author hridesh
 */
public interface Env {
    Value get(String search_var);

    class LookupException extends RuntimeException {
        LookupException(String message) {
            super(message);
        }
    }

    @SuppressWarnings("unused")
    class EmptyEnv implements Env {
        public Value get(String search_var) {
            throw new LookupException("No binding found for name: " + search_var);
        }
    }

    class ExtendEnv implements Env {
        private final Env _saved_env;
        private final String _var;
        private final Value _val;

        public ExtendEnv(Env saved_env, String var, Value val) {
            _saved_env = saved_env;
            _var = var;
            _val = val;
        }

        public synchronized Value get(String search_var) {
            if (search_var.equals(_var)) return _val;
            return _saved_env.get(search_var);
        }
    }

    class GlobalEnv implements Env {
        private final Map<String, Value> map;

        public GlobalEnv() {
            map = new HashMap<>();
        }

        public synchronized Value get(String search_var) {
            if (map.containsKey(search_var)) return map.get(search_var);
            throw new LookupException("No binding found for name: " + search_var);
        }

        public synchronized void extend(String var, Value val) {
            map.put(var, val);
        }
    }

}
