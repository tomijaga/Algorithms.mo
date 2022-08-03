import TrieMap "mo:base/TrieMap";
import Set "mo:base/TrieSet";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

import StableTrieMap "StableTrieMap";

module{

    public type GraphType = {
        #directed; #undirected
    };

    public type StableGraph<A> = StableTrieMap.StableTrieMap<A, Set.Set<A>> and {
        graphType : GraphType;
    };

    public func newDirectedGraph<A>(isEq: (A, A) -> Bool, nodeHashFn: (A) -> Hash.Hash): StableGraph<A>{ 
        let triemap = StableTrieMap.new<A, Set.Set<A>>(isEq, nodeHashFn);

        {
            var map = triemap.map;
            var _size = triemap._size;
            isEq = triemap.isEq;
            hashFn = triemap.hashFn;
            graphType = #directed;
        }
    };

    public func newUndirectedGraph<A>(isEq: (A, A) -> Bool, nodeHashFn: (A) -> Hash.Hash) : StableGraph<A>{
        let triemap = StableTrieMap.new<A, Set.Set<A>>(isEq, nodeHashFn);

        {
            var map = triemap.map;
            var _size = triemap._size;
            isEq = triemap.isEq;
            hashFn = triemap.hashFn;
            graphType = #undirected;
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

    public func isEmpty<A>(graph: StableGraph<A>) : Bool{
        graph._size == 0
    };

    // public func addNode<A>(graph: StableGraph<A>, node: A){
    //     applyToGraph<A, ()>(graph, func(g, _, _){
    //         g.put(node, Set.empty<A>())
    //     })
    // };


    // public func contains<A>(graph: StableGraph<A>, node: A): Bool{
    //     applyToGraph<A, Bool>(graph, func(g, _, _){
    //         switch(g.get(n1)){
    //             case(?set){
    //                 true
    //             };
    //             case(_){
    //                 false
    //             };
    //         }
    //     })
    // };

    // public func addEdge<A>(graph: StableGraph<A>, nodeA: A, nodeB: A){
    //     switch(graph){
    //         case(#directed(g, isEq, nodeHashFn)){
    //             switch(g.get(nodeA)){
    //                 case(?set){
    //                     if (not contains(nodeB)){
    //                         Debug.trap("Trying to add edge to nodeB that doesn't exist");
    //                     };

    //                     Set.put(set, nodeB, nodeHashFn(nodeB), isEq)
    //                 };
    //                 case(_){
    //                     Debug.trap("Trying to add edge to nodeA that doesn't exist");
    //                 };
    //             }
    //         };
    //         case(#undirected(g, isEq, nodeHashFn)){
    //             switch(g.get(nodeA)){
    //                 case(?setA){
    //                     switch(g.get(nodeB)){
    //                         case(?setB){
    //                             Set.put(setA, nodeB, nodeHashFn(nodeB), isEq)
    //                             Set.put(setB, nodeA, nodeHashFn(nodeB), isEq)
    //                         };
    //                         case(_){
    //                             Debug.trap("Trying to add edge to nodeA that doesn't exist");
    //                         };
    //                     };
    //                 };
    //                 case(_){
    //                     Debug.trap("Trying to add edge to nodeA that doesn't exist");
    //                 };
    //             }
    //         };
    //     };
    // };

    // func getAndUpdate(gMap: GraphInternalMap<A>, node: A, update: (Set.Set<A>) -> Set.Set<A>){
    //     switch(gMap.get(node)){
    //         case(?set){
    //             gMap.put(node, update(set));
    //         };
    //         case(_){
    //             Debug.trap("Trying to get node that doesn't exist");
    //         };
    //     };
    // };

    // public func removeEdge<A>(graph: StableGraph<A>, nodeA: A, nodeB: A){
    //     switch(graph){
    //         case(#directed(g, isEq, nodeHashFn)){
    //             getAndUpdate(g, nodeA, func(set){
    //                 Set.delete(set, nodeB, nodeHashFn(nodeB), isEq)
    //             })
    //         };
    //         case(#undirected(g, isEq, nodeHashFn)){
    //             getAndUpdate(g, nodeA, func(set){
    //                 let Set.delete(set, nodeB, nodeHashFn(nodeB), isEq)
    //             });
    //             getAndUpdate(g, nodeB, func(set){
    //                 let Set.delete(set, nodeA, nodeHashFn(nodeA), isEq)
    //             });
    //         };
    //     };
    // };

    // public func neighbors<A>(graph: StableGraph<A>, node: A): [A] {
    //     applyToGraph<A, Set.Set<A>>(graph, func(g, _, _){
    //         switch(g.get(node)){
    //             case(?set){
    //                 Set.toArray(set)
    //             };
    //             case(_){
    //                 Debug.trap("Trying to get connections of node that doesn't exist");
    //             };
    //         }
    //     })
    // };

    // public func nodes<A>(graph: StableGraph<A>) : Iter.Iter<A> {
    //     applyToGraph<A, Set.Set<A>>(graph, func(g, _, _){
    //         g.keys()
    //     })
    // };

    // public func edges<A>(graph: StableGraph<A>) : Iter.Iter<(A, A)> {
    //     func getNextEdge(nodeIter: Iter.Iter<A>, connections:  Iter.Iter<A> edgesIter: Iter.Iter<(A, A)> ): {
    //         loop{
    //             switch(nodeIter.next()){

    //             };
    //         }
    //     };
        
    //     switch(graph){
    //         case(#directed(g, _, _)){
    //             object{
    //                 public func next(): ?A{
    //                     let nodeIter = g.keys();
    //                     var connections : Iter.Iter<A> = Utils.emptyIter();

                       
    //                 };
    //             }
    //         };
    //         case(#undirected(g, _, _)){
                
    //         };
    //     };
    // };
};