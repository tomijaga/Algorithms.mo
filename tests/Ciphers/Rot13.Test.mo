import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

import ActorSpec "../utils/ActorSpec";
import Algo "../../src";
import { rot13 } "../../src/Ciphers";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("Rot13", [
        it("letter case", do {
            assertTrue(
                Algo.Ciphers.rot13("Hello, World!") == "Uryyb, Jbeyq!"
            )
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};