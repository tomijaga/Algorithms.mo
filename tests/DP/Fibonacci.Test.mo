import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Char "mo:base/Char";

import ActorSpec "../utils/ActorSpec";
import { fibonacci } "../../src/DP";
import Algo "../../src";

let {
    assertTrue; assertFalse; assertAllTrue; describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("Fibonacci", [
        it("fib of 3", do {
            assertTrue( fibonacci(3) == 2 )
        }),
        it("fib of 10", do {
            assertTrue( fibonacci(10) == 55 )
        }),
        it("fib of 20", do {
            assertTrue( fibonacci(20) == 6765 )
        }),
        it("fib of 30", do {
            assertTrue( fibonacci(30) == 832040 )
        }),
        it("fib of 40", do {
            assertTrue( fibonacci(40) == 102334155 )
        }),
        it("fib of 101", do {
            assertTrue( fibonacci(101) == 573147844013817084101 )
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};
