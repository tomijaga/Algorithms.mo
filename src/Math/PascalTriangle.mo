import Array "mo:base/Array";
import Iter "mo:base/Iter";

module{
    public func pascalTriangle(rows: Nat): [[Nat]]{
        var prev: [Nat] = [];

        Array.tabulate<[Nat]>(rows, func(_){
            prev := nextRow(prev);
            prev
        })
    };

    func nextRow(row: [Nat]): [Nat]{
        var prev = 0;
        Array.tabulate<Nat>(row.size() + 1, func(i){
            if (i == row.size()){
                1
            }else{
                let n = prev + row[i];
                prev := row[i]; 
                n
            }
        })
    };

};