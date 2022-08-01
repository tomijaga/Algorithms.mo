import Debug "mo:base/Debug";
import Nat "mo:base/Nat";

import ActorSpec "../utils/ActorSpec";
import Math "../../src/Math";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("Factorial", [
        it("5!", do {
            let fac_5 = Math.factorial(5);

            assertTrue(fac_5 == 120)
        }),

        it("10!", do {
            let fac_10 = Math.factorial(10);
            
            assertTrue(fac_10 == 3_628_800)
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};