import Array "mo:base/Array";

module{
    public type StableMatrix<A> = [[var A]];

    public func new<A>(rows: Nat, cols: Nat, initCells: (Nat, Nat) -> A) : StableMatrix<A>{
        Array.tabulate(rows, func(i){
            Array.init(_cols, func(j){
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
        Array.tabulate(rows(m), func(i){
            m[i][col]
        })
    };

    public func getRow<A>(m: StableMatrix<A>, row: Nat) : [A]{
        Array.freeze(m[row])
    };

    public func add<A>(m1: StableMatrix<A>, m2: StableMatrix<A>, addFn: (A, A) -> A) : StableMatrix<A>{
        assert m1.rows() == m2.rows() and m1.cols() == m2.cols();

        let result = new(m1.rows(), m1.cols(), func(i, j){
            addFn(m1.get(i, j), m2.get(i, j))
        });
        
        result
    };

    public func addInPlace(m1: StableMatrix<A>, m2: StableMatrix<A>, addFn: (A, A) -> A){
        assert m1.rows() == m2.rows() and m1.cols() == m2.cols();

        for (i in Utils.range(0, m1.rows())){
            for (j in Utils.range(0, m1.cols())){
                m1.set(i, j, addFn(get(i, j), m2.get(i, j)))
            };
        };
    };
        
    public func sub(m1: StableMatrix<A>, m2: StableMatrix<A>, subFn: (A, A) -> A) : StableMatrix<A>{
        assert m1.rows() == m2.rows() and m1.cols() == m2.cols();
        
        let result = new(m1.rows(), m1.cols(), func(i, j){
            subFn(m1.get(i, j), m2.get(i, j))
        });
        
        result
    };

    public func subInPlace(m1: StableMatrix<A>, m2: StableMatrix<A>,, subFn: (A, A) -> A){
        assert m1.rows() == m2.rows() and m1.cols() == m2.cols();
        
        for (i in Utils.range(0, m1.rows())){
            for (j in Utils.range(0, m1.cols())){
                m1.set(i, j, subFn(m1.get(i, j), m2.get(i, j)))
            };
        };
    };

    public func mul(m1: StableMatrix<A>, m2: StableMatrix<A>,, mulFn: (A, A) -> A, addFn: (A, A) -> A ) : StableMatrix<A>{
        assert m1.cols() == m2.rows();

        let result = new(m1.rows(), m2.cols(), func(i, j){
            let sum = mulFn(m1.get(i, 0), m2.get(0, j));

            for (index in Utils.range(1, m1cols())){
                sum := addFn(sum, mulFn(m1.get(i, index), m2.get(index, j)));
            };
                
            sum
        });
        
        result
    };

    public func scalarMul(m: StableMatrix<A>, scalar: A, mulFn: (A, A) -> A) : StableMatrix<A>{
        let result = new(m.rows(), m.cols(), func(i, j){
            mulFn(scalar, m.get(i, j))
        });
        
        result
    };

    public func scalarMulInPlace(m: StableMatrix<A>, scalar: A, mulFn: (A, A) -> A){
        for (i in Utils.range(0, m.rows())){
            for (j in Utils.range(0, m.cols())){
                set(i, j, mulFn(scalar, m.get(i, j)))
            };
        };
    };

    public func transpose(m: StableMatrix<A>) : StableMatrix<A>{
        let result = new(m.cols(), m.rows(), func(i, j){
            m.get(j, i)
        });
        
        result
    };
}