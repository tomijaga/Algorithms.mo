import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";


import ActorSpec "../utils/ActorSpec";
import StableGraph "../../src/DataStructures/StableGraph";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("StableGraph", [
        it("Directed Graph", do {
            
            let graph = StableGraph.newDirectedGraph<Nat>(Nat.equal, Hash.hash);

            assertTrue( StableGraph.isEmpty(graph) == true )
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};