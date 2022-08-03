import TrieMap "mo:base/TrieMap";
import Set "mo:base/TrieSet";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Trie "mo:base/Trie";
import List "mo:base/List";
import Debug "mo:base/Debug";
import Option "mo:base/Option";

import StableTrieMap "StableTrieMap";

import { IterModule; ListModule; SetModule } "../Utils";

module{

    public type GraphType = {
        #directed; #undirected
    };

    public type StableGraph<A> = {
        map : StableTrieMap.StableTrieMap<A, Set.Set<A>>;
        graphType : GraphType;
        var _edgeSize : Nat;
    };

    public func DirectedGraph<A>(isEq: (A, A) -> Bool, hashFn: (A) -> Hash.Hash) : StableGraph<A>{ 
        new(#directed, isEq, hashFn);
    };

    public func UndirectedGraph<A>(isEq: (A, A) -> Bool, hashFn: (A) -> Hash.Hash) : StableGraph<A>{
        new(#undirected, isEq, hashFn);
    };

    public func new<A>(graphType : GraphType, isEq : (A, A) -> Bool, hashFn: (A) -> Hash.Hash) : StableGraph<A>{

        let map = StableTrieMap.new<A, Set.Set<A>>(isEq, hashFn);

        {
            map;
            graphType;
            var _edgeSize = 0;
        }
    };

    public func isDirected<A>(graph: StableGraph<A>) : Bool{
        switch(graph.graphType){
            case(#directed) true;
            case(#undirected) false;
        };
    };

    public func isUnirected<A>(graph: StableGraph<A>) : Bool{
        switch(graph.graphType){
            case(#directed) false;
            case(#undirected) true;
        };
    };

    public func nodeSize<A>(graph : StableGraph<A>) : Nat{
        StableTrieMap.size(graph.map)
    };

    public func edgeSize<A>(graph : StableGraph<A>) : Nat{
        graph._edgeSize
    };

    public func isEmpty<A>(graph: StableGraph<A>) : Bool{
        nodeSize(graph) == 0
    };

    public func addNode<A>(graph : StableGraph<A>, node : A) {
        switch(StableTrieMap.get(graph.map, node)){
            case(?set) {};
            case(_) {
                StableTrieMap.put(graph.map, node, Set.empty<A>());
            }
        };
    };

    public func hasNode<A>(graph : StableGraph<A>, node : A ) : Bool{
        switch(StableTrieMap.get(graph.map, node)){
            case(?set) true;
            case(_) false;
        }
    };

    public func deleteNode<A>(graph : StableGraph<A>, nodeToDelete : A) {
        switch(StableTrieMap.get(graph.map, nodeToDelete)){
            case(?set) {
                let {isEq; hashFn} = graph.map;

                StableTrieMap.delete(graph.map, nodeToDelete);

                for ((node, set) in StableTrieMap.entries(graph.map)){
                    let updatedSet = Set.delete<A>(set, nodeToDelete, hashFn(nodeToDelete), isEq);

                    StableTrieMap.put(graph.map, node, updatedSet);
                };
            };
            case(_) {};
        };
    };

    public func removeNode<A>(graph : StableGraph<A>, nodeToRemove : A) : ?Iter.Iter<(A, A)>{
        let outgoingEdges = switch(StableTrieMap.remove(graph.map, nodeToRemove)){
            case(null) return null;
            case (?set) {
                Iter.map<(A, ()), (A, A)>(
                    Trie.iter<A, ()>(set),
                    func((neighbor, _): (A, ())) : (A, A){
                        (nodeToRemove, neighbor)
                    }
                )
            }
        };

        let {isEq; hashFn} = graph.map;

        switch(graph.graphType){
            case (#directed){
                var list = List.nil<(A, A)>();

                for ((node, set) in StableTrieMap.entries(graph.map)){
                    let (updatedSet, wasRemoved) = SetModule.remove<A>(set, nodeToRemove, hashFn(nodeToRemove), isEq);
                    
                    if (wasRemoved){
                        StableTrieMap.put(graph.map, node, updatedSet);
                        list := List.push((node, nodeToRemove), list);
                    };
                };
                
                ?IterModule.chain<(A, A)>(
                    ListModule.toIter(list),
                    outgoingEdges
                )
            };
            case (#undirected){
                for ((node, set) in StableTrieMap.entries(graph.map)){
                    StableTrieMap.put(
                        graph.map,
                        node, 
                        Set.delete(set, nodeToRemove, hashFn(nodeToRemove), isEq)
                    );
                };
                ?outgoingEdges
            };
        };
    };

    func addDirectedEdge<A>(graph : StableGraph<A>, nodeA : A, nodeB : A) : Bool {
        let {isEq; hashFn} = graph.map;

        let optSet = StableTrieMap.get(graph.map, nodeA);
        let set = Option.get(optSet, Set.empty<A>());
        
        let (updatedSet, added) = SetModule.add(set, nodeB, hashFn(nodeB), isEq);

        if (added){
            StableTrieMap.put(graph.map, nodeA, updatedSet);
            return true;
        };

        false
    };

    public func addEdge<A>(graph : StableGraph<A>, nodeA : A, nodeB: A) {
        let added = switch(graph.graphType){
            case(#directed) {
                addNode(graph, nodeB);
                addDirectedEdge(graph, nodeA, nodeB)
            };
            case(#undirected) {
                addDirectedEdge(graph, nodeA, nodeB) and
                addDirectedEdge(graph, nodeB, nodeA);
            };
        };

        if (added){
            graph._edgeSize += 1;
        };
    };

    func removeDirectedEdge<A>(graph : StableGraph<A>, nodeA : A, nodeB: A) : Bool {
        let {isEq; hashFn} = graph.map;
        
        switch (StableTrieMap.get(graph.map, nodeA)) {
            case(?set) {
                let (updatedSet, wasRemoved) = SetModule.remove<A>(set, nodeB, hashFn(nodeB), isEq);
                
                if (wasRemoved){
                    StableTrieMap.put(graph.map, nodeA, updatedSet);
                    return true;
                };

                false
            };
            case(_) false;
        };
    };

    public func removeEdge<A>(graph : StableGraph<A>, nodeA : A, nodeB: A) {
        let removed = switch(graph.graphType){
            case(#directed) {
                removeDirectedEdge(graph, nodeA, nodeB)
            };
            case(#undirected) {
                removeDirectedEdge(graph, nodeA, nodeB) and removeDirectedEdge(graph, nodeB, nodeA);
            };
        };
        
        if (removed){
            graph._edgeSize -= 1;
        };

    };

    public func neighbors<A>(graph : StableGraph<A>, node : A) : ?Iter.Iter<A> {
        switch(StableTrieMap.get(graph.map, node)){
            case(?set) ?SetModule.toIter(set);
            case(_) null;
        }
    };

    public func nodes<A>(graph : StableGraph<A>) : Iter.Iter<A> {
        StableTrieMap.keys(graph.map)
    };

    public func edges<A>(graph : StableGraph<A>) : Iter.Iter<(A, A)>{
            type Entry<A> = (A, Set.Set<A>);

            let filteredEntries : Iter.Iter<Entry<A>> = Iter.filter(
                StableTrieMap.entries(graph.map),
                func ((node, set) : Entry<A>) : Bool {
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
            
            let {isEq; hashFn} = graph.map;

            switch(graph.graphType){
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

    public func fromEdges<A>(
        graphType: GraphType, 
        edges: Iter.Iter<(A, A)>, 
        isEq: (A, A) -> Bool, 
        hashFn: (A) -> Hash.Hash
    ) : StableGraph<A>{
        let graph = new<A>(graphType, isEq, hashFn);

        for((nodeA, nodeB) in edges){
            addEdge(graph, nodeA, nodeB);
        };

        graph
    };
};