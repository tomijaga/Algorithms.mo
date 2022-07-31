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
    describe(" Linear Search ", [
        it("item in array", do {
            
            let arr = [1, 2, 3, 4, 5];

            let result = Algo.Search.linearSearch<Nat>(arr, 3, Nat.compare);
            
            assertTrue(result == #ok(2));
        }),

        it("item not in array", do {
            
            let arr = [1, 2, 3, 4, 5];

            let result = Algo.Search.linearSearch(arr, 10, Nat.compare);
            
            assertTrue(result == #err);
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};