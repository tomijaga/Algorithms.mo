import Int "mo:base/Int";
import Iter "mo:base/Iter";
import List "mo:base/List";

module{
    public module IterModule{
        public func empty<A>(): Iter.Iter<A> {
            object {
                public func next(): ?A {
                    null
                };
            };
        };

        public func flatten<A>(nestedIter: Iter.Iter<Iter.Iter<A>>) : Iter.Iter<A> {
            var iter : Iter.Iter<A> = switch (nestedIter.next()){
                case (?_iter){
                    _iter
                };
                case (_){
                    return IterModule.empty<A>();
                };
            };

            object {
                public func next(): ?A {
                    switch(iter.next()){
                        case (?val) ?val;
                        case (_){
                            switch(nestedIter.next()){
                                case (?_iter){
                                    iter :=_iter;
                                    iter.next()
                                };
                                case (_) null;
                            };
                        };
                    };
                };
            };
        }; 
        
        public func chain<A>(a: Iter.Iter<A>, b: Iter.Iter<A>): Iter.Iter<A>{
            object{
                public func next(): ?A{
                    switch(a.next()){
                        case (?x){
                            ?x
                        };
                        case (null) {
                            b.next()
                        };
                    };
                }
            };
        };
    };

    public module ListModule{
        public func toIter<A>(xs : List.List<A>) : Iter.Iter<A> {
            var state = xs;
            object {
                public func next() : ?A =
                    switch state {
                    case (?(hd, tl)) { state := tl; ?hd };
                    case _ null
                }
            }
        }
    };

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

    public func emptyIter<A>(): Iter.Iter<A> {
        return object {
            public func next(): ?A {
                return null;
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