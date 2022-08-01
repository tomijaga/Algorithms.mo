import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Array "mo:base/Array";

import ActorSpec "../utils/ActorSpec";
import Sort "../../src/Sort";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("Selection Sort", [
        it("selectionSort()", do {
            let {selectionSort} = Sort;
            let unsorted_arr: [Nat] = [5, 1, 2, 4, 3];

            let sorted_arr = selectionSort(unsorted_arr, Nat.compare);
            
            Debug.print(debug_show sorted_arr);

            assertTrue(
                sorted_arr == [1, 2, 3, 4, 5],
            )
        }),

        it("selectionSortMut()", do{
            let {selectionSortMut} = Sort;
            let arr: [var Nat] = [var 5, 1, 2, 4, 3];

            selectionSortMut(arr, Nat.compare);
            assertTrue(
                Array.freeze(arr) == [1, 2, 3, 4, 5],
            )
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};