import Prim "mo:⛔";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

module {
    public func fibonacci(n: Nat) : Nat {
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