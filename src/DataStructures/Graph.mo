import TrieMap "mo:base/TrieMap";
import Trie "mo:base/Trie";
import Hash "mo:base/Hash";
import Set "mo:base/TrieSet";
import Iter "mo:base/Iter";
import Stack "mo:base/Stack";
import List "mo:base/List";
import Debug "mo:base/Debug";

import { IterModule; ListModule; SetModule } "../Utils";

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
            let outgoingEdges = switch(map.remove(nodeToRemove)){
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

                    for ((node, set) in map.entries()){
                        let (updatedSet, wasRemoved) = SetModule.remove<A>(set, nodeToRemove, hashFn(nodeToRemove), isEq);
                        
                        if (wasRemoved){
                            map.put(node, updatedSet);
                            list := List.push((node, nodeToRemove), list);
                        };
                    };

                    ?IterModule.chain<(A, A)>(
                        ListModule.toIter(list),
                        outgoingEdges
                    )
                };

                case (#undirected){
                    for ((node, set) in map.entries()){
                        map.put(
                            node, 
                            Set.delete(set, nodeToRemove, hashFn(nodeToRemove), isEq)
                        );
                    };

                    ?outgoingEdges
                };
            };
        };

        public func hasNode(node: A) : Bool{
            switch(map.get(node)){
                case(?set) true;
                case(_) false;
            }
        };

        func addDirectedEdge(nodeA: A, nodeB: A ) : Bool{
            let (setA, added) = switch(map.get(nodeA)){
                case(?set){
                    SetModule.add(set, nodeB, hashFn(nodeB), isEq);
                };
                case(_) {
                    var set = Set.empty<A>();
                    SetModule.add(set, nodeB, hashFn(nodeB), isEq);
                };
            };

            if (added){
                map.put(nodeA, setA);
                return true;
            };

            false
        };

        public func addEdge(nodeA: A, nodeB: A ){
            let added = switch(graphType){
                case (#directed){
                    // add nodeB to map if it doesn't exist
                    addNode(nodeB);
                    addDirectedEdge(nodeA, nodeB)
                };
                case (#undirected){
                    addDirectedEdge(nodeA, nodeB) and 
                    addDirectedEdge(nodeB, nodeA);
                };
            };

            if (added){
                _edgeSize+=1;
            };

        };

        func removeDirectedEdge(nodeA: A, nodeB: A): Bool{
            switch(map.get(nodeA)){
                case(?set){
                    let (updatedSet, removed) = SetModule.remove(set, nodeB, hashFn(nodeB), isEq);

                    if (removed){
                        map.put(nodeA, updatedSet);
                        return true;
                    };

                    false
                }; 
                case(_) false;
            };
        };

        public func removeEdge(nodeA: A, nodeB: A){
            let removed = switch(graphType){
                case (#directed){
                    removeDirectedEdge(nodeA, nodeB);
                };
                case (#undirected){
                    removeDirectedEdge(nodeA, nodeB) and
                    removeDirectedEdge(nodeB, nodeA);
                };
            };

            if (removed){
                _edgeSize-=1;
            };

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
                    SetModule.toIter(set)
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
                            if(Set.mem(visited, nodeB, hashFn(nodeB), isEq)){
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