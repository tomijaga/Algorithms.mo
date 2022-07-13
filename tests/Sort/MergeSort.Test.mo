import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";

import ActorSpec "../utils/ActorSpec";
import Algo "../../src";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("MergeSort", [
        it("test 1", do {
            
            let arr = [3, 2, 4, 1];

            let sorted_arr = Algo.Sort.mergeSort(arr, Nat.compare);
            Debug.print("sorted_arr: " # debug_show sorted_arr);
            assertTrue( sorted_arr == [1, 2, 3, 4])
        }),

        it("test 2", do {
            
            let arr = [9,3,10,1,2,8,7,6,5];

            let sorted_arr = Algo.Sort.mergeSort(arr, Nat.compare);
            assertTrue( sorted_arr ==  [1, 2, 3, 5, 6, 7, 8, 9, 10])
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};