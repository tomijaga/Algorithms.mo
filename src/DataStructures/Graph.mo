import TrieMap "mo:base/TrieMap";
import Trie "mo:base/Trie";
import Hash "mo:base/Hash";
import Set "mo:base/TrieSet";
import Iter "mo:base/Iter";
import Stack "mo:base/Stack";
import List "mo:base/List";
import Debug "mo:base/Debug";

import { IterModule; ListModule } "../Utils";

module{

    public func UndirectedGraph<A>(isEq: (A, A) -> Bool, hashFn: (A) -> Hash.Hash): Graph<A>{
        Graph<A>(#undirected, isEq, hashFn)
    };

    public func DirectedGraph<A>(isEq: (A, A) -> Bool, hashFn: (A) -> Hash.Hash): Graph<A>{
        Graph<A>(#directed, isEq, hashFn)
    };

    public type GraphType = {
        #directed; #undirected
    };

    public class Graph<A>(graphType: GraphType, isEq: (A, A) -> Bool, hashFn: (A) -> Hash.Hash){
        var map = TrieMap.TrieMap<A, Set.Set<A>>(isEq, hashFn);
        var _edgeSize = 0;

        public func isDirected<A>(graph: Graph<A>) : Bool{
            switch(graphType){
                case(#directed) true;
                case(#undirected) false;
            };
        };

        public func isUndirected<A>(graph: Graph<A>) : Bool{
            switch(graphType){
                case(#directed) false;
                case(#undirected) true;
            };
        };

        public func addNode(node: A){
            switch(map.get(node)){
                case(?set){};
                case(_) map.put(node, Set.empty<A>());
            };
        };

        /// Removes a node from the graph and returns all the edges that were removed.
        public func removeNode(nodeToRemove: A) : ?Iter.Iter<(A, A)> {
            let edgesIter = switch(map.remove(nodeToRemove)){
                case(null) return null;
                case (?_set) {
                    Iter.map<(A, ()), (A, A)>(
                        Trie.iter<A, ()>(_set),
                        func((neighbor, ()): (A, ())) : (A, A){
                            (nodeToRemove, neighbor)
                        }
                    )
                }
            };

            switch(graphType){
                case (#directed){
                    var list = List.nil<(A, A)>();

                    let isEqCallback = func(node: A): (A, A) -> Bool{
                        func(a: A, b: A): Bool{
                            if (isEq(a, b)){
                                list := List.push((node, a), list); 
                                true
                            } else {
                                false
                            };
                        }
                    };
                    
                    for ((node, set) in map.entries()){
                        map.put(
                            node, 
                            Set.delete(set, nodeToRemove, hashFn(nodeToRemove), isEqCallback(node))
                        );
                    };

                    ?IterModule.chain<(A, A)>(
                        ListModule.toIter(list),
                        edgesIter
                    )
                };

                case (#undirected){
                    for ((node, set) in map.entries()){
                        map.put(
                            node, 
                            Set.delete(set, nodeToRemove, hashFn(nodeToRemove), isEq)
                        );
                    };

                    ?edgesIter
                };
            };
        };

        public func hasNode(node: A) : Bool{
            switch(map.get(node)){
                case(?set) true;
                case(_) false;
            }
        };

        func addDirectedEdge(nodeA: A, nodeB: A ){
            let setA = switch(map.get(nodeA)){
                case(?set){
                    Set.put(set, nodeB, hashFn(nodeB), isEq);
                };
                case(_) {
                    var set = Set.empty<A>();
                    Set.put(set, nodeB, hashFn(nodeB), isEq);
                };
            };

            map.put(nodeA, setA);
        };

        public func addEdge(nodeA: A, nodeB: A ){
            switch(graphType){
                case (#directed){
                    // add nodeB to map if it doesn't exist
                    addNode(nodeB);
                    addDirectedEdge(nodeA, nodeB);
                };
                case (#undirected){
                    addDirectedEdge(nodeA, nodeB);
                    addDirectedEdge(nodeB, nodeA);
                };
            };
            _edgeSize+=1;
        };

        func removeDirectedEdge(nodeA: A, nodeB: A){
            switch(map.get(nodeA)){
                case(?set){
                    let setA = Set.delete(set, nodeB, hashFn(nodeB), isEq);
                    map.put(nodeA, setA);
                }; 
                case(_) {};
            };
        };

        public func removeEdge(nodeA: A, nodeB: A){
            switch(graphType){
                case (#directed){
                    removeDirectedEdge(nodeA, nodeB);
                };
                case (#undirected){
                    removeDirectedEdge(nodeA, nodeB);
                    removeDirectedEdge(nodeB, nodeA);
                };
            };
            _edgeSize-=1;
        };

        public func hasEdge(nodeA: A, nodeB : A) : Bool{
            switch(map.get(nodeA)){
                case(?set){
                    Set.mem(set, nodeB, hashFn(nodeB), isEq);
                };
                case(_) false;
            };
        };

        public func neighbors(node: A) : Iter.Iter<A>{
            switch(map.get(node)){
                case(?set){
                    Iter.map(
                        Trie.iter<A, ()>(set), 
                        func((node, _) : (A, ())): A{
                            node
                        }
                    )
                };
                case(_) IterModule.empty<A>();
            };
        };

        public func edges() : Iter.Iter<(A, A)>{
            type Entry<A> = (A, Set.Set<A>);

            let filteredEntries : Iter.Iter<Entry<A>> = Iter.filter(
                map.entries(), 
                func ((node, set): Entry<A>) : Bool {
                    Set.size(set) > 0
                }
            );

            let nestedIter = Iter.map<Entry<A>, Iter.Iter<(A, A)>>(
                filteredEntries,
                func((nodeA, set) : Entry<A>) : Iter.Iter<(A, A)>{
                    Iter.map<(A, ()), (A, A)>(
                        Trie.iter<A, ()>(set),
                        func((nodeB, _)): (A, A){
                            (nodeA, nodeB)
                        }
                    )
                }
            );

            let flattened = IterModule.flatten(nestedIter);

            switch(graphType){
                case(#directed) flattened;
                case(#undirected) {
                    var visited = Set.empty<A>();
                    Iter.filter(
                        flattened,
                        func((nodeA, nodeB) : (A, A)) : Bool{
                            if(Set.mem(visited, nodeA, hashFn(nodeA), isEq)){
                                false
                            }else{
                                visited := Set.put(visited, nodeA, hashFn(nodeA), isEq);
                                true
                            };
                        }
                    );
                };
            };
        };

        public func clear() {
            map := TrieMap.TrieMap<A, Set.Set<A>>(isEq, hashFn);
        };

        public func nodeSize() : Nat{
            map.size()
        };

        public func isEmpty() : Bool{
            nodeSize() == 0
        };

        public func edgeSize() : Nat{
            _edgeSize
        };

        public func nodes() : Iter.Iter<A>{
            map.keys()
        };

    };

    public func fromEdges<A>(
        graphType: GraphType, 
        edges: Iter.Iter<(A, A)>, 
        isEq: (A, A) -> Bool, 
        hashFn: (A) -> Hash.Hash
    ) : Graph<A>{
        let graph = Graph<A>(graphType, isEq, hashFn);

        for((nodeA, nodeB) in edges){
            graph.addEdge(nodeA, nodeB);
        };

        graph
    };
};