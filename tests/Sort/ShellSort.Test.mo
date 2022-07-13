import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Array "mo:base/Array";

import ActorSpec "../utils/ActorSpec";
import Algo "../../src";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe(" Shell Sort ", [
        it("test 1", do {
            let arr = [var 3,2,4,1,5];

            Algo.Sort.shellSortMut(arr, Nat.compare);
            Debug.print(debug_show Array.freeze(arr));
            assertTrue(Array.freeze(arr) == [1, 2, 3, 4]);
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};