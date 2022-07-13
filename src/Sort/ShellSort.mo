import Order "mo:base/Order";
import Debug "mo:base/Debug";
import Array "mo:base/Array";

import Utils "../Utils";

module{
    public func shellSortMut(arr: [var Nat], cmp: (Nat, Nat) -> Order.Order){
        gapSort(arr, cmp, arr.size()/2);
    };

    func gapSort(arr: [var Nat],  cmp: (Nat, Nat) -> Order.Order, gap: Nat){
        var i = 0;
        var j = gap;

        while (j < arr.size()){
            if( cmp(arr[i], arr[j]) != #less){
                Utils.array_swap<Nat>(arr, i, j);
            };

            Debug.print(debug_show Array.freeze(arr) # " " # debug_show gap);

            i+=1;
            j+=1;
        };

        if (gap > 1){
            gapSort(arr, cmp, gap/2);
        };
    };
};
