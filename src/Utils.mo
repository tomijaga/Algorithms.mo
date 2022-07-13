module{
    public func array_swap<A>(arr: [var A], i: Nat, j: Nat){
        var tmp = arr[i];
        arr[i] := arr[j];
        arr[j] := tmp;
    };
};