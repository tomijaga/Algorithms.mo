import Order "mo:base/Order";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Int "mo:base/Int";

import Utils "../Utils";

module{
    public func insertionSort<A>(arr: [A], cmp: (A, A) -> Order.Order) : [A] {
        let arrMut = Array.thaw<A>(arr);

        insertionSortMut<A>(arrMut, cmp);

        Array.freeze<A>(arrMut);
    };

    public func insertionSortMut<A>(arr: [var A], cmp: (A, A) -> Order.Order) {
        for (index in Utils.range(1, arr.size())){
            var j = index;
            var i = Int.abs(j - 1);

            while(i >= 0 and not (cmp(arr[i], arr[j]) == #less)){
                Utils.array_swap(arr, i, j);

                if (i > 0){
                    i-=1;
                    j-=1;
                };
                
            };
        };
    };
}