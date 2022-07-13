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
    describe("QuickSort", [
        it("test 1", do {
            
            let arr = [3, 2, 4, 1, 5];

            let sorted_arr = Algo.Sort.quickSort<Nat>(arr, Nat.compare);
            assertTrue( sorted_arr == [1, 2, 3, 4, 5])
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};