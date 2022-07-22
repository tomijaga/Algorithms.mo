import Order "mo:base/Order";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Debug "mo:base/Debug";

module{
    public func mergeSort<A>(arr: [A], cmp: (A, A) -> Order.Order) : [A] {
        let thawed = Array.thaw<A>(arr);
        mergeSortMut(thawed, cmp);

        Array.freeze<A>(thawed)
    };

    public func mergeSortMut<A>(arr: [var A], cmp: (A, A) -> Order.Order) {
        merge<A>(arr, cmp, 0, arr.size());
    };

    func merge<A>(arr: [var A], cmp: (A, A) -> Order.Order, start: Nat, end: Nat){

        let diff = Int.abs(end - start);

        if (diff < 2){
            return;
        };
        
        if (diff == 2){
            let last_index = Int.abs(end - 1);

            if (cmp(arr[start], arr[last_index]) == #greater){
                swap(arr, start, last_index);
            };
            return ;
        };

        let m = (start + end) / 2;
        merge<A>(arr, cmp, start, m);
        merge<A>(arr, cmp, m, end);

        let left = Array.tabulate<A>(m - start, func(i){ arr[start + i] });
        let right = Array.tabulate<A>(end - m, func(i){ arr[m + i] });

        var i = 0;
        var j = 0;

        for (index in Iter.range(start, end -1)){
            if (i >= left.size()){
                arr[index] := right[j];
                j += 1;
            } else if (j >= right.size()){
                arr[index] := left[i];
                i += 1;
            } else if (cmp(left[i], right[j]) == #less){
                arr[index] := left[i];
                i += 1;
            } else {
                arr[index] := right[j];
                j += 1;
            };
        };
    };

    func swap<A>(arr: [var A], i: Nat, j: Nat){
        var tmp = arr[i];
        arr[i] := arr[j];
        arr[j] := tmp;
    };
}