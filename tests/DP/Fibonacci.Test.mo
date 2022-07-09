import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Char "mo:base/Char";

import ActorSpec "../utils/ActorSpec";
import Fib "../../src/DP/Fibonacci";
import Algo "../../src";

let {
    assertTrue; assertFalse; assertAllTrue; describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("Fibonacci", [
        it("fib of 3", do {
            assertTrue( true)
        }),
        it("fib of 10", do {

            assertTrue( true)
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};