import Iter "mo:base/Iter";

module{
    public func factorial(n: Nat) : Nat{
        var acc = 1;

        for (num in Iter.range(2, n)){
            acc *= num;
        };

        acc
    };
}