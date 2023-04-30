namespace TriangleProblem {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Canon;

    operation CreateSuperposition(register : Qubit[]) : Unit {
        ApplyToEach(H, register);
    }

    operation QuantumWalkOperator(register : Qubit[], graph : Int[][]) : Unit {
        let n = Length(graph);
        for i in 0..n - 1 {
            for j in 0..n - 1 {
                if (graph[i][j] == 1) {
                    CNOT(register[i], register[j]);
                }
            }
        }
    }

    operation TriangleOracle(register : Qubit[], graph : Int[][]) : Unit {
        let n = Length(graph);
        for i in 0..n - 1 {
            for j in 0..n - 1 {
                for k in 0..n - 1 {
                    if (graph[i][j] == 1 and graph[j][k] == 1 and graph[k][i] == 1) {
                        CCNOT(register[i], register[j], register[k]);
                    }
                }
            }
        }
    }

    operation GroverSearch(register : Qubit[], graph : Int[][]) : Unit {
        let N = Length(register);
        let numIterations = N^(5/4) / 6;

        for _ in 1..numIterations {
            TriangleOracle(register, graph);
            ReflectAboutUniform(register);
        }
    }

    operation ReflectAboutUniform(register : Qubit[]) : Unit {
        ApplyToEach(H, register);
        ApplyToEach(X, register);
        Controlled Z(Most(register), Tail(register));
        ApplyToEach(X, register);
        ApplyToEach(H, register);
    }

    operation MeasureAndOutput(register : Qubit[]) : Result[] {
        let measurementResults = MultiM(register);
        let indexOfOne = IndexOf(EqualOne, Mapped(ResultAsBool, measurementResults));
        return measurementResults;
    }

    function ResultAsBool(result : Result) : Bool {
        return result == One;
    }

    function EqualOne(value : Bool) : Bool {
        return value;
    }

    operation CountTriangles(graph : Int[][]) : Int {
        mutable count = 0;
        let n = Length(graph);
        for i in 0..n - 1 {
            for j in i + 1..n - 1 {
                for k in j + 1..n - 1 {
                    if (graph[i][j] == 1 and graph[j][k] == 1 and graph[k][i] == 1) {
                        set count += 1;
                    }
                }
            }
        }
        return count;
    }

    operation SolveTriangleProblem(graph : Int[][]) : (Int, Result[]) {
        let n = Length(graph);
        if (n < 3) {
            fail "Error: Graph must have at least three vertices to contain a triangle.";
        }

        use register = Qubit[n] {
            CreateSuperposition(register);
            QuantumWalkOperator(register, graph);
            GroverSearch(register, graph);
            let measurementResults = MeasureAndOutput(register);
            let triangleCount = CountTriangles(graph);
            return (triangleCount, measurementResults);
        }
    }

    @EntryPoint()
    operation RunTriangleProblem() : Unit {
        let graph = [
            [0, 1, 0, 0, 1],
            [1, 0, 1, 1, 1],
            [0, 1, 0, 1, 0],
            [0, 1, 1, 0, 1],
            [1, 1, 0, 1, 0]
        ];

        let (triangleCount, result) = SolveTriangleProblem(graph);
        Message($"Number of triangles found in the graph: {triangleCount}");
        Message($"Measurement results: {result}");
    }
}
