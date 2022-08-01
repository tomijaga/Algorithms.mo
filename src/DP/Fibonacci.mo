import Prim "mo:⛔";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

module {
    public func fibonacci(n: Nat) : Nat {
        var fib = Array.init<Nat>(n + 1, 0);
        var left = 0;
        var right = 1;

        for (i in Iter.range(1, n)){
            let tmp = left;
            left := right;
            right += tmp;
        };
        
        left
    };
}