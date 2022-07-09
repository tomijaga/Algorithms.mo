import Order "mo:base/Order";
import Result "mo:base/Result";

module{
    public func binarySearch<A>(sortedArray: [A], value: A,  cmp: (A, A)-> Order.Order) : Result.Result<Nat, Nat>{

        if (sortedArray.size() == 0){
            return #err(0);
        };
        
        var low = 0;
        var high = sortedArray.size() - 1;

        while (low <= high) {
            var mid = (low + high) / 2;

            var cmpResult = cmp(sortedArray[mid], value);

            switch(cmpResult){
                case (#less){ low:= mid + 1; };
                case (#greater){ high:= mid - 1; };
                case (#equal){ return #ok(mid); };
            };
        };

        #err(low)
    }
}