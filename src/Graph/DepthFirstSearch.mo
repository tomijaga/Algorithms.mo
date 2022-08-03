import Iter "mo:base/Iter";

import Graph "../DataStructures/Graph";

import {SetModule} "../Utils";

module{
    public func depthFirstSearch<A>(graph: Graph<A>, start: A) : Iter.Iter<A> {
        var visited = Set.empty<A>();
        let stack = Stack.Stack<A>();
        stack.push(start);

        object{
            public func next() : ?A{
                var val : ?A = null;
                
                label l loop {
                    switch(stack.pop()){
                        case(?node) {
                            switch(map.get(node)){
                                case(?set){
                                    val := node;
                                    visited := Set.put(visited, node, hashFn(node), isEq);
                                    
                                    for (_node in SetModule.toIter(set)){
                                        if (not Set.mem(visited, node, hashFn(node), isEq)){
                                            stack.push(_node);
                                        };
                                    };
                                };
                                case(_) { break l};
                            };
                        };
                        case(_) break l;
                    };
                }
            };
        };
    }
};