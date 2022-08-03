import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Iter "mo:base/Iter";

import ActorSpec "../utils/ActorSpec";
import StableTrieMap "../../src/DataStructures/StableTrieMap";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("StableTrieMap", [
        it("create new map", do {
            let map = StableTrieMap.new<Text, Nat>(Text.equal, Text.hash);

            assertAllTrue([
                StableTrieMap.isEmpty(map),
                StableTrieMap.size(map) == 0
            ]);
        }),
        it("put", do{
            let map = StableTrieMap.new<Text, Nat>(Text.equal, Text.hash);

            StableTrieMap.put(map, "a", 1);
            StableTrieMap.put(map, "b", 2);
            StableTrieMap.put(map, "c", 3);

            assertAllTrue([
                not StableTrieMap.isEmpty(map),
                StableTrieMap.size(map) == 3,
                StableTrieMap.get(map, "a") == ?1,
                StableTrieMap.get(map, "b") == ?2,
                StableTrieMap.get(map, "c") == ?3
            ])
        }),
        it("remove", do{
            let map = StableTrieMap.new<Text, Nat>(Text.equal, Text.hash);

            StableTrieMap.put(map, "a", 1);
            StableTrieMap.put(map, "b", 2);
            StableTrieMap.put(map, "c", 3);

            assertAllTrue([
                not StableTrieMap.isEmpty(map),
                StableTrieMap.size(map) == 3,
                StableTrieMap.remove(map, "a") == ?1,
                StableTrieMap.remove(map, "b") == ?2,
                StableTrieMap.remove(map, "c") == ?3,
                StableTrieMap.isEmpty(map),
                StableTrieMap.get(map, "a") == null,
            ])
        }),
        it("fromEntries", do{
            let map = StableTrieMap.fromEntries<Text, Nat>(
                [ ("a", 1), ("b", 2), ("c", 3) ].vals(),
                Text.equal, 
                Text.hash
            );

            assertAllTrue([
                StableTrieMap.size(map) == 3,
                StableTrieMap.get(map, "a") == ?1,
                StableTrieMap.get(map, "b") == ?2,
                StableTrieMap.get(map, "c") == ?3
            ])
        }),
        it("keys", do{
            let map = StableTrieMap.new<Text, Nat>(Text.equal, Text.hash);

            StableTrieMap.put(map, "a", 1);
            StableTrieMap.put(map, "b", 2);
            StableTrieMap.put(map, "c", 3);

            let keys = StableTrieMap.keys(map);
            assertAllTrue([
                Iter.toArray(keys) == ["a", "b", "c"],
            ])
        }),
        it("vals", do{
            let map = StableTrieMap.new<Text, Nat>(Text.equal, Text.hash);

            StableTrieMap.put(map, "a", 1);
            StableTrieMap.put(map, "b", 2);
            StableTrieMap.put(map, "c", 3);

            let vals = StableTrieMap.vals(map);
            assertAllTrue([
                Iter.toArray(vals) == [1, 2, 3],
            ])
        }),

        it("clone", do{
            let map = StableTrieMap.new<Text, Nat>(Text.equal, Text.hash);

            StableTrieMap.put(map, "a", 1);
            StableTrieMap.put(map, "b", 2);
            StableTrieMap.put(map, "c", 3);

            let clone = StableTrieMap.clone(map);

            StableTrieMap.delete(map, "a");
            StableTrieMap.delete(map, "b");

            StableTrieMap.delete(clone, "c");

            assertAllTrue([
                StableTrieMap.size(map) == 1,
                StableTrieMap.get(map, "c") == ?3,

                StableTrieMap.size(clone) == 2,
                StableTrieMap.get(clone, "a") == ?1,
                StableTrieMap.get(clone, "b") == ?2,
            ])
        }),

        it("clear", do{
            let map = StableTrieMap.new<Text, Nat>(Text.equal, Text.hash);

            StableTrieMap.put(map, "a", 1);
            StableTrieMap.put(map, "b", 2);
            StableTrieMap.put(map, "c", 3);

            StableTrieMap.clear(map);

            assertAllTrue([
                StableTrieMap.isEmpty(map),
                StableTrieMap.size(map) == 0,
                StableTrieMap.get(map, "a") == null,
                StableTrieMap.get(map, "b") == null,
                StableTrieMap.get(map, "c") == null,
            ])
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};
