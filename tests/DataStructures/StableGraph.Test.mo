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
        describe("Directed Graph", [
            it("new", do {
            
                let graph = StableGraph.DirectedGraph<Nat>(Nat.equal, Hash.hash);

                assertTrue( StableGraph.isEmpty(graph) == true )
            }),
            it("add node to Graph", do{
                let graph = StableGraph.DirectedGraph<Nat>(Nat.equal, Hash.hash);

                StableGraph.addNode(graph, 1);
                StableGraph.addNode(graph, 2);

                assertAllTrue([
                    StableGraph.hasNode(graph, 1),
                    StableGraph.hasNode(graph, 2),
                    not StableGraph.hasNode(graph, 3),
                    StableGraph.nodeSize(graph) == 2
                ])
            }),
        ]),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};