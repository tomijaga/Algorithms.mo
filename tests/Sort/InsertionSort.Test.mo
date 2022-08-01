import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Array "mo:base/Array";

import ActorSpec "../utils/ActorSpec";
import Sort "../../src/Sort";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("Insertion Sort", [
        it("insertionSort()", do {
            
            let unsorted_arr: [Nat] = [1, 3, 5, 2, 4];

            let sorted_arr = Sort.insertionSort(
                unsorted_arr, 
                Nat.compare
            );

            assertTrue(
                sorted_arr == [1, 2, 3, 4, 5],
            )
        }),
        it("insertionSortMut", do{
            let arr : [var Nat] = [var 1, 3, 5, 2, 4];

            Sort.insertionSortMut(arr, Nat.compare);

            assertTrue(
                Array.freeze(arr) == [1, 2, 3, 4, 5]
            )
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};