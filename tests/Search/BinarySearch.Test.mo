import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Char "mo:base/Char";

import ActorSpec "../utils/ActorSpec";
import BinarySearch "../../src/Search/BinarySearch";
import Algo "../../src";

let {
    assertTrue; assertFalse; assertAllTrue; describe; it; skip; pending; run
} = ActorSpec;


let success = run([
    describe("Binary Search", [
        it("find char in array", do {
            let arr = ['a', 'b', 'c'];
            var result = true;

            let res = Algo.Search.binarySearch(arr, 'b', Char.compare);

            assertTrue( res == #ok(1))
        }),
        it("find char not in array", do {
            let arr = ['a', 'b', 'c'];
            var result = true;

            let res = Algo.Search.binarySearch(arr, 'd', Char.compare);

            assertTrue( res == #err(3))
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};
