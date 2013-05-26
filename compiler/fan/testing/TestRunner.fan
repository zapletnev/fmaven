
class TestRunner
{
  Result[] test(Str podName) 
  {
    Result[] res := [,]
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
        res.add(Result.ok(it.name))
      } catch (Err e) {
        res.add(Result.error(it.name, e.msg))
      } finally {
        it.parent.method("teardown").callOn(testInst, [,])
      }
    }
    return res
  }
}

enum class Status { ok, fail }

class Result {
  
  const Status status
  const Str? msg
  const Str testName
  
  new make(Status status, Str testName, Str? msg := null) {
    this.status = status
    this.testName = testName
    this.msg = msg
  }
  
  override Bool equals(Obj? obj)
  {
    if (obj isnot Result) { return false }
    Result? other := obj as Result
    echo( msg?.equals(other.msg)?:true)
    return msg?.equals(other.msg)?:true
      && status == other.status && testName.equals(other.testName)
  }
  
  static Result error(Str testName, Str msg) { Result(Status.fail, testName, msg) }
  static Result ok(Str testName) { Result(Status.ok, testName) }
}
