import Order "mo:base/Order";
import Iter "mo:base/Iter";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Debug "mo:base/Debug";

module {

    public func quickSort<A>(arr: [A], cmp: (A, A) -> Order.Order) : [A]{
        let thawed = Array.thaw<A>(arr);
        quickSortMut<A>(thawed, cmp);

        Array.freeze<A>(thawed)
    };

    public func quickSortMut<A>(arr: [var A], cmp: (A, A) -> Order.Order){
        if (arr.size() == 0){
            return;
        };

        partition<A>(arr, cmp, 0, arr.size());
    };

    func partition<A>(arr: [var A], cmp: (A, A) -> Order.Order, start: Nat, end: Nat){
        if (start >= end){
            return;
        };

        var pivot = start;
        var i = start + 1;
        var j = start + 1;

        for (index in Iter.range(pivot +1 , Int.abs(end - 1))){
            let ord = cmp(arr[index], arr[pivot]);

            if (ord == #less){
                swap(arr, index, i);
                i+=1;
                j+=1;
            }else{
                swap(arr, index, j);
                j+=1;
            };
        };

        pivot := Int.abs(i - 1);
        swap(arr, start, pivot);

        partition(arr, cmp, start, pivot);

        partition(arr, cmp, pivot + 1, j);
    };

    func swap<A>(arr: [var A], i: Nat, j: Nat){
        var tmp = arr[i];
        arr[i] := arr[j];
        arr[j] := tmp;
    };
};

