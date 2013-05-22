
const class Testing
{
  static TestResult[] test(Str podName) 
  {
    TestResult[] res := [,]
    Method[] testMethods := Pod.find(podName).types.findAll { it.fits(Test#) }
        .map |type->Method[]| { 
          type.methods.findAll { it.name.startsWith("test")} 
        }.flatten
    
    noOfPasses := 0
    noOfFailures := 0
    testMethods.each {
      testInst := it.parent.make
      try {
        it.parent.method("setup").callOn(testInst, [,])
        it.callOn(testInst, [,])
        res.add(TestResult.ok(it.name))
      } catch (Err e) {
        res.add(TestResult.error(it.name, e.msg))
      } finally {
        it.parent.method("teardown").callOn(testInst, [,])
      }
    }
    return res
  }
}

const class TestResult {
  
  const Int severity // 0 - error, 1 - ok
  const Str? msg
  const Str testName
  
  new make(Int severity, Str testName, Str? msg := null) {
    this.severity = severity
    this.testName = testName
    this.msg = msg
  }
  
  override Bool equals(Obj? obj)
  {
    if (obj isnot TestResult) { return false }
    TestResult? other := obj as TestResult
    echo( msg?.equals(other.msg)?:true)
    return msg?.equals(other.msg)?:true
      && severity == other.severity && testName.equals(other.testName)
  }
  
  static TestResult error(Str testName, Str msg) { TestResult(0, testName, msg) }
  static TestResult ok(Str testName) { TestResult(1, testName) }
}
