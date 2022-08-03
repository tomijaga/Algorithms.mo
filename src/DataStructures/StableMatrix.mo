import Array "mo:base/Array";

import Utils "../Utils";

module{
    public type StableMatrix<A> = [[var A]];

    public func new<A>(rows: Nat, cols: Nat, initCells: (Nat, Nat) -> A) : StableMatrix<A>{
        Array.tabulate<[var A]>(rows, func(i: Nat): [var A]{
            Array.tabulateVar<A>(cols, func(j: Nat): A {
                initCells(i, j)
            })
        })
    };

    public func get<A>(m: StableMatrix<A>, row: Nat, col: Nat) : A{
        m[row][col]
    };

    public func set<A>(m: StableMatrix<A>, row: Nat, col: Nat, value: A){
        m[row][col] := value
    };

    public func rows<A>(m: StableMatrix<A>) : Nat{
        m.size()
    };

    public func cols<A>(m: StableMatrix<A>) : Nat{
        if (rows(m) == 0){
            0
        } else {
            m[0].size()
        }
    };

    public func getCol<A>(m: StableMatrix<A>, col: Nat) : [A]{
        Array.tabulate<A>(rows(m), func(i: Nat): A{
            m[i][col]
        })
    };

    public func getRow<A>(m: StableMatrix<A>, row: Nat) : [A]{
        Array.freeze(m[row])
    };

    public func add<A>(m1: StableMatrix<A>, m2: StableMatrix<A>, addFn: (A, A) -> A) : StableMatrix<A>{
        assert rows(m1) == rows(m2) and cols(m1) == cols(m2);

        let result = new<A>(
            rows(m1), 
            cols(m1), 
            func(i: Nat, j: Nat) : A{
                addFn(get(m1, i, j), get(m2, i, j))
            }
        );
        
        result
    };

    public func addInPlace<A>(m1: StableMatrix<A>, m2: StableMatrix<A>, addFn: (A, A) -> A){
        assert rows(m1) == rows(m2) and cols(m1) == cols(m2);

        for (i in Utils.range(0, rows(m1))){
            for (j in Utils.range(0, cols(m1))){
                set(m1, i, j, addFn(get(m1, i, j), get(m2, i, j)))
            };
        };
    };

    public func addTo<A>(m1: StableMatrix<A>, m2: StableMatrix<A>, store: StableMatrix<A>, addFn: (A, A) -> A){
        assert rows(m1) == rows(m2) and cols(m1) == cols(m2) and  rows(m1) == rows(store) and cols(m1) == cols(store);  

        for (i in Utils.range(0, rows(m1))){
            for (j in Utils.range(0, cols(m1))){
                set(store, i, j, addFn(get(m1, i, j), get(m2, i, j)));
            };
        };
    };
        
    public func sub<A>(m1: StableMatrix<A>, m2: StableMatrix<A>, subFn: (A, A) -> A) : StableMatrix<A>{
        assert rows(m1) == rows(m2) and cols(m1) == cols(m2);
        
        let result = new<A>(rows(m1), cols(m1), func(i, j){
            subFn(get(m1, i, j), get(m2, i, j))
        });
        
        result
    };

    public func subInPlace<A>(m1: StableMatrix<A>, m2: StableMatrix<A>, subFn: (A, A) -> A){
        assert rows(m1) == rows(m2) and cols(m1) == cols(m2);
        
        for (i in Utils.range(0, rows(m1))){
            for (j in Utils.range(0, cols(m1))){
                set(m1, i, j, subFn(get(m1, i, j), get(m2, i, j)))
            };
        };
    };

    public func subTo<A>(m1: StableMatrix<A>, m2: StableMatrix<A>, store: StableMatrix<A>, subFn: (A, A) -> A){
        assert rows(m1) == rows(m2) and cols(m1) == cols(m2) and  rows(m1) == rows(store) and cols(m1) == cols(store);  
              
        for (i in Utils.range(0, rows(m1))){
            for (j in Utils.range(0, cols(m1))){
                set(store, i, j, subFn(get(m1, i, j), get(m2, i, j)));
            };
        };
    };

    public func mul<A>(m1: StableMatrix<A>, m2: StableMatrix<A>, mulFn: (A, A) -> A, addFn: (A, A) -> A ) : StableMatrix<A>{
        assert cols(m1) == rows(m2);

        let result = new<A>(rows(m1), cols(m2), func(i, j){
            var sum = mulFn(get(m1, i, 0), get(m2, 0, j));

            for (index in Utils.range(1, cols(m1))){
                sum := addFn(sum, mulFn(get(m1, i, index), get(m2, index, j)));
            };
                
            sum
        });
        
        result
    };

    public func scalarMul<A>(m: StableMatrix<A>, scalar: A, mulFn: (A, A) -> A) : StableMatrix<A>{
        let result = new<A>(rows(m), cols(m), func(i, j){
            mulFn(scalar, get(m, i, j))
        });
        
        result
    };

    public func scalarMulInPlace<A>(m: StableMatrix<A>, scalar: A, mulFn: (A, A) -> A){
        for (i in Utils.range(0, rows(m))){
            for (j in Utils.range(0, cols(m))){
                set(m, i, j, mulFn(scalar, get(m, i, j)))
            };
        };
    };

    public func scalarMulTo<A>(m: StableMatrix<A>, scalar: A, store: StableMatrix<A>, mulFn: (A, A) -> A){
        for (i in Utils.range(0, rows(m))){
            for (j in Utils.range(0, cols(m))){
                set(store, i, j, mulFn(scalar, get(m, i, j)));
            };
        };
    };

    public func transpose<A>(m: StableMatrix<A>) : StableMatrix<A>{
        let result = new<A>(cols(m), rows(m), func(i, j){
            get(m, j, i)
        });
        
        result
    };
};