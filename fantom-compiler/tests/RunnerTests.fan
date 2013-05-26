class RunnerTests : Test
{
  Void testWorldTesting()
  {
    doTest("helloWithTests.pod", 
      [Result.ok("testOk"), Result.error("testFail", "Test failed")])
  }
  
  private Void doTest(Str podName, Result[] expected)
  {
    Pod.load(typeof.pod.file(`/resources/tests/$podName`).in)
    TestRunner().test(podName.split('.')[0]).each |t, index| {   
      verify(t.equals(expected.get(index)))
    }
  }
}
