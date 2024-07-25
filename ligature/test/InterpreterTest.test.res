@module("vitest") external test: (string, _ => _) => unit = "test"

let check = (left, right) => %raw(`Vitest.expect(left).toStrictEqual(right)`)

let singleTestValues: array<(Model.wanderValue, result<(list<Model.wanderValue>, Belt.Map.String.t<Model.wordInstance>), string>)> = [
  (Model.Int(123n), Ok(list{Model.Int(123n)}, HostFunctions.std)),
  (Model.Quote(list{}), Ok(list{Model.Quote(list{})}, HostFunctions.std)),
]

let testScripts: array<(list<Model.wanderValue>, result<(list<Model.wanderValue>, Belt.Map.String.t<Model.wordInstance>), string>)> = [
 (list{Model.Int(123n)}, Ok(list{Model.Int(123n)}, HostFunctions.std)),
 (list{Model.Int(123n), Model.Int(321n)}, Ok(list{Model.Int(321n), Model.Int(123n)}, HostFunctions.std)),
]

let testStrings: array<(string, result<(list<Model.wanderValue>, Belt.Map.String.t<Model.wordInstance>), string>)> = [
  ("234", Ok(list{Model.Int(234n)}, HostFunctions.std)),
  ("\"test\"", Ok(list{Model.String("test")}, HostFunctions.std)),
  ("`test`", Ok(list{Model.Identifier({identifier: "test"})}, HostFunctions.std)),
  ("234 `test`", Ok(list{Model.Identifier({identifier: "test"}), Model.Int(234n)}, HostFunctions.std)),
  ("1 pop", Ok(list{}, HostFunctions.std)),
  ("[]", Ok(list{Model.Quote(list{})}, HostFunctions.std)),
  ("$test", Ok(list{Model.Slot("test")}, HostFunctions.std)),
  ("[$test]", Ok(list{Model.Quote(list{Model.Slot("test")})}, HostFunctions.std)),
  ("[$test] run", Ok(list{Model.Slot("test")}, HostFunctions.std)),
  ("1 [2] run", Ok(list{Model.Int(2n), Model.Int(1n)}, HostFunctions.std)),
  //(":x 5; x", Ok(list{Model.Int(5n)}, HostFunctions.std)),
]

test("single eval", () => {
  singleTestValues->Array.forEach(((script, result)) => {
    check(Interpreter.evalSingle(script, HostFunctions.std, list{}), result)
  })
})

test("script eval", () => {
  testScripts->Array.forEach(((script, result)) => {
    check(Interpreter.evalList(script, HostFunctions.std, list{}), result)
  })
})

test("string eval", () => {
  testStrings->Array.forEach(((script, result)) => {
    check(Interpreter.evalString(script, HostFunctions.std, list{}), result)
  })
})
