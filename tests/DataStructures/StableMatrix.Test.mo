import Debug "mo:base/Debug";
import Nat "mo:base/Nat";

import ActorSpec "../utils/ActorSpec";
import StableMatrix "../../src/DataStructures/StableMatrix";

import Utils "../../src/Utils";

let {
    assertTrue; assertFalse; assertAllTrue; 
    describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("StableMatrix", [
        it("create 3x3 matrix", do {
            let init = func (i: Nat, j: Nat): Nat{ i * 3 + j };

            let matrix = StableMatrix.new<Nat>(3, 3, init);

            var res = true;
            var n = 0;

            for (i in Utils.range(0, 3)) {
                for (j in Utils.range(0, 3)) {
                    if (StableMatrix.get(matrix, i, j) != n) {
                        res := false;
                    };
                    n+=1;
                };
            };

            assertAllTrue([ 
                res == true,
                StableMatrix.rows(matrix) == 3, 
                StableMatrix.cols(matrix) == 3,
            ])
        }),

        it("add two 3x3 matrices", do{

            let m1 = StableMatrix.new<Nat>(3, 3, func (i, j){ 
                i * 3 + j 
            });

            let m2 = StableMatrix.new<Nat>(3, 3, func (i, j){ 
                (2 - i) * 3 + (2 - j)
            });

            let m3 = StableMatrix.add(m1, m2, Nat.add);

            var res = true;

            for (i in Utils.range(0, 3)){
                for (j in Utils.range(0, 3)){
                    res := StableMatrix.get(m3, i, j) == 8
                };
            };

            assertAllTrue([
                res == true,
                StableMatrix.rows(m3) == 3, 
                StableMatrix.cols(m3) == 3,
            ])
        }),
    ])
]);

if(success == false){
  Debug.trap("\1b[46;41mTests failed\1b[0m");
}else{
    Debug.print("\1b[23;42;3m Success!\1b[0m");
};