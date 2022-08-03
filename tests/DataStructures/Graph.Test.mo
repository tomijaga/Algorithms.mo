import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

import ActorSpec "../utils/ActorSpec";
import Graph "../../src/DataStructures/Graph";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("Graph", [
        describe("Directed Graph", [
            it("New Graph", do{
                let graph = Graph.DirectedGraph<Text>(Text.equal, Text.hash);

                assertAllTrue([
                    graph.isEmpty(),
                    graph.nodeSize() == 0,
                    graph.edgeSize() == 0
                ])
            }),
            it("Add node", do{
                let graph = Graph.DirectedGraph<Text>(Text.equal, Text.hash);

                graph.addNode("motoko");

                assertAllTrue([
                    not graph.isEmpty(),
                    graph.nodeSize() == 1,
                    graph.edgeSize() == 0,
                    graph.hasNode("motoko"),
                    Iter.toArray(graph.nodes()) == ["motoko"]
                ]);
            }),

            it("Add edge", do{
                let graph = Graph.DirectedGraph<Text>(Text.equal, Text.hash);

                graph.addNode("motoko");
                graph.addNode("dfinity");

                graph.addEdge("motoko", "dfinity");

                assertAllTrue([
                    graph.nodeSize() == 2,
                    graph.edgeSize() == 1,
                    graph.hasEdge("motoko", "dfinity"),
                    not graph.hasEdge("dfinity", "motoko"),
                    Iter.toArray(graph.neighbors("motoko")) == ["dfinity"],
                    Iter.toArray(graph.edges()) == [
                        ("motoko","dfinity")
                    ],
                ])
            }),
            it("Add edge for nodes not in the graph", do{
                let graph = Graph.DirectedGraph<Text>(Text.equal, Text.hash);

                graph.addEdge("icp", "motoko");
                graph.addEdge("icp", "dfinity");

                assertAllTrue([
                    graph.nodeSize() == 3,
                    graph.edgeSize() == 2,
                    graph.hasEdge("icp", "motoko"),
                    graph.hasEdge("icp", "dfinity"),
                    not graph.hasEdge("motoko", "icp"),
                    Iter.toArray(graph.edges()) == [
                        ("icp","motoko"),
                        ("icp", "dfinity")
                    ],
                    Iter.toArray(graph.neighbors("icp")) == [
                        "motoko", "dfinity"
                    ]
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
