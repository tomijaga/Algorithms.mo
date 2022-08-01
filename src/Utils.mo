import Int "mo:base/Int";
import Iter "mo:base/Iter";

module{
    public func array_swap<A>(arr: [var A], i: Nat, j: Nat){
        let tmp = arr[i];
        arr[i] := arr[j];
        arr[j] := tmp;
    };

    public func range(start: Nat, end: Nat): Iter.Iter<Nat> {
        var i: Nat = start;

        return object {
            public func next(): ?Nat {
                if (i < end ) {
                    i += 1;
                    return ?Int.abs(i - 1);
                } else {
                    return null;
                }
            };
        };
    };

    public func reduce<A>(iter: Iter.Iter<A>, f: (A, A) -> A): ?A{
        switch (iter.next()){
            case (?a) {
                var acc = a;

                for (val in iter){
                    acc := f(acc, val);
                };

                ?acc
            };
            case (_) {
                return null;
            };
        }
    };
};