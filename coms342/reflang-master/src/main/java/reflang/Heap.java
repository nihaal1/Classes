//package reflang;
//
///**
// * Representation of a heap, which maps references to values.
// *
// * @author hridesh
// */
//public interface Heap {
//
//    Value ref(Value value);
//
//    Value deref(Value.RefVal loc);
//
//    Value setref(Value.RefVal loc, Value value);
//
//    Value free(Value.RefVal value);
//
//    class Heap16Bit implements Heap {
//        static final int HEAP_SIZE = 65_536;
//
//        Value[] _rep = new Value[HEAP_SIZE];
//        int index = 0;
//
//        public Value ref(Value value) {
//            if (index >= HEAP_SIZE) return new Value.DynamicError("Out of memory error");
//            Value.RefVal new_loc = new Value.RefVal(index);
//            _rep[index++] = value;
//            return new_loc;
//        }
//
//        public Value deref(Value.RefVal loc) {
//            try {
//                if (_rep[loc.loc()] == null) return new Value.DynamicError("Null pointer at " + loc);
//                return _rep[loc.loc()];
//            } catch (ArrayIndexOutOfBoundsException e) {
//                return new Value.DynamicError("Segmentation fault at access " + loc);
//            }
//        }
//
//        public Value setref(Value.RefVal loc, Value value) {
//            try {
//                if (_rep[loc.loc()] == null) return new Value.DynamicError("Null pointer at " + loc);
//                return _rep[loc.loc()] = value;
//            } catch (ArrayIndexOutOfBoundsException e) {
//                return new Value.DynamicError("Segmentation fault at access " + loc);
//            }
//        }
//
//        public Value free(Value.RefVal loc) {
//            try {
//                _rep[loc.loc()] = null;
//                return loc;
//            } catch (ArrayIndexOutOfBoundsException e) {
//                return new Value.DynamicError("Segmentation fault at access " + loc);
//            }
//        }
//
//        public Heap16Bit() {
//        }
//    }
//
//}


package reflang;

import java.util.Stack;

/**
 * Representation of a heap, which maps references to values.
 *
 * @author hridesh
 */
public interface Heap {

    Value ref(Value value);

    Value deref(Value.RefVal loc);

    Value setref(Value.RefVal loc, Value value);

    Value free(Value.RefVal value);

    class Heap16Bit implements Heap {
        static final int HEAP_SIZE = 65_536;

        Value[] _rep = new Value[HEAP_SIZE];
        int index = 0;
        Stack<Integer> freeLocations = new Stack<>(); // Stack to track freed locations

        @Override
        public Value ref(Value value) {
            int location;
            // Check if there are freed locations available
            if (!freeLocations.isEmpty()) {
                location = freeLocations.pop(); // Reuse a freed location
            } else {
                // Allocate new location if no freed locations are available
                if (index >= HEAP_SIZE) return new Value.DynamicError("Out of memory error");
                location = index++;
            }
            Value.RefVal new_loc = new Value.RefVal(location);
            _rep[location] = value;
            return new_loc;
        }

        @Override
        public Value deref(Value.RefVal loc) {
            try {
                if (_rep[loc.loc()] == null) return new Value.DynamicError("Null pointer at " + loc);
                return _rep[loc.loc()];
            } catch (ArrayIndexOutOfBoundsException e) {
                return new Value.DynamicError("Segmentation fault at access " + loc);
            }
        }

        @Override
        public Value setref(Value.RefVal loc, Value value) {
            try {
                if (_rep[loc.loc()] == null) return new Value.DynamicError("Null pointer at " + loc);
                return _rep[loc.loc()] = value;
            } catch (ArrayIndexOutOfBoundsException e) {
                return new Value.DynamicError("Segmentation fault at access " + loc);
            }
        }

        @Override
        public Value free(Value.RefVal loc) {
            try {
                _rep[loc.loc()] = null; // Clear the reference at this location
                freeLocations.push(loc.loc()); // Add location to the stack for reuse
                return loc;
            } catch (ArrayIndexOutOfBoundsException e) {
                return new Value.DynamicError("Segmentation fault at access " + loc);
            }
        }

        public Heap16Bit() {
        }
    }

}
