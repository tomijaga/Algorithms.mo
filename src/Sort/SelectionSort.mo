import Order "mo:base/Order";
import Array "mo:base/Array";
import Debug "mo:base/Debug";

import Utils "../Utils";

module{
    public func selectionSort<A>(arr: [A], cmp: (A, A) -> Order.Order) : [A] {
        let arrMut = Array.thaw<A>(arr);

        selectionSortMut<A>(arrMut, cmp);

        Array.freeze<A>(arrMut);
    };

    public func selectionSortMut<A>(arr: [var A], cmp: (A, A) -> Order.Order ) {
        var minIndex = 0;
        var i = 0;

        while (i < arr.size()){
            minIndex := i;
            for (j in Utils.range(i, arr.size())){
                if (cmp(arr[j], arr[minIndex]) == #less){
                    minIndex := j;
                };
            };

            Utils.array_swap(arr, i, minIndex);

            i+=1;
        };

    };
};