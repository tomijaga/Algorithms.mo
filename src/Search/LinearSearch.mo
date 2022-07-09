import Order "mo:base/Order";
import Result "mo:base/Result";
import Iter "mo:base/Iter";

module{
    public func linearSearch<A>(arr: [A], value: A, cmp: (A, A) -> Order.Order): Result.Result<Nat, ()>{
        for (i in Iter.range(0, arr.size() - 1)){
            if (cmp(arr[i], value) == #equal){
                return #ok(i);
            };
        };

        #err()
    };
}