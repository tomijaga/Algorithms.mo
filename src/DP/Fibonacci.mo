import Prim "mo:⛔";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

module {
    public func fibonacci(n: Nat) : Nat {
        var fib = Array.init<Nat>(n + 1, 0);

        fib[0] := 0;
        fib[1] := 1;

        for (i in Iter.range(2, n)){
            fib[i] := fib[i - 1] + fib[i  - 2];
        };
        
        fib[n]
    };
}