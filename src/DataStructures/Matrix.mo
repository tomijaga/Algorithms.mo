import Array "mo:base/Array";

module{
    public class Matrix<A>(_rows: Nat, _cols: Nat, initCells: (Nat, Nat) -> A){
        let data : [[var A]] = Array.tabulate(rows, func(i){
            Array.init(_cols, func(j){
                initCells(i, j)
            })
        });

        public func get(row: Nat, col: Nat) : A{
            data[row][col]
        };

        public func set(row: Nat, col: Nat, value: A){
            data[row][col] := value
        };

        public func rows() : Nat{
            _rows
        };

        public func cols() : Nat{
            _cols
        };

        public func getCol(col: Nat) : [A]{
            Array.tabulate(rows(), func(i){
                data[i][col]
            })
        };

        public func getRow(row: Nat) : [A]{
            Array.freeze(data[row])
        };

        public func add(other: Matrix<A>, addFn: (A, A) -> A) : Matrix<A>{
            assert rows() == other.rows() and cols() == other.cols();

            let result = Matrix(rows(), cols(), func(i, j){
                addFn(get(i, j), other.get(i, j))
            });
            
            result
        };

        public func addInPlace(other: Matrix<A>, addFn: (A, A) -> A){
            assert rows() == other.rows() and cols() == other.cols();

            for (i in Utils.range(0, rows())){
                for (j in Utils.range(0, cols())){
                    set(i, j, addFn(get(i, j), other.get(i, j)))
                };
            };
        };
        
        public func sub(other: Matrix<A>, subFn: (A, A) -> A) : Matrix<A>{
            assert rows() == other.rows() and cols() == other.cols();
            
            let result = Matrix(rows(), cols(), func(i, j){
                subFn(get(i, j), other.get(i, j))
            });
            
            result
        };

        public func subInPlace(other: Matrix<A>, subFn: (A, A) -> A){
            assert rows() == other.rows() and cols() == other.cols();
            
            for (i in Utils.range(0, rows())){
                for (j in Utils.range(0, cols())){
                    set(i, j, subFn(get(i, j), other.get(i, j)))
                };
            };
        };

        public func mul(other: Matrix<A>, mulFn: (A, A) -> A, addFn: (A, A) -> A ) : Matrix<A>{
            assert cols() == other.rows();

            let result = Matrix(rows(), other.cols(), func(i, j){
                let sum = mulFn(data[i][0], other.get(0, j));

                for (index in Utils.range(1, cols())){
                    sum := addFn(sum, mulFn(data[i][index], other.get(index, j)));
                };
                    
                sum
            });
            
            result
        };

        public func scalarMul(scalar: A, mulFn: (A, A) -> A) : Matrix<A>{
            let result = Matrix(rows(), cols(), func(i, j){
                mulFn(scalar, data[i][j])
            });
            
            result
        };

        public func scalarMulInPlace(scalar: A, mulFn: (A, A) -> A){
            for (i in Utils.range(0, rows())){
                for (j in Utils.range(0, cols())){
                    set(i, j, mulFn(scalar, data[i][j]))
                };
            };
        };

        public func transpose() : Matrix<A>{
            let result = Matrix(cols(), rows(), func(i, j){
                data[j][i]
            });
            
            result
        };
    };
};