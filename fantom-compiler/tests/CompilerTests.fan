**
** Compiler Tests
** 
class CompilerTests : Test
{
  Uri pods := unzip(`/resources/tests/pods.zip`)
  
  Void testWorld()
  {
    verifyNotNull(compile(FanPod("hello", unzip(`/resources/tests/hello.zip`)).depend("sys 1.0")))
  }
  
  Void testWorldTesting()
  {
    doTest("helloWithTests.pod", 
      [TestResult.ok("testOk"), TestResult.error("testFail", "Test failed")])
  }
  
  private File? compile(FanPod pod) 
  {
    compiler := FCompiler(pod.podDir.uri, pods) 
    errors := compiler.compile(pod)
    compiler.dispose
    if (!errors.isEmpty) {
      fail(errors.toStr)
    }
    podFile := pod.podDir.plus(Uri.fromStr(pod.podName + ".pod"));
    return podFile.exists ? podFile : null
  }
  
  private Void doTest(Str podName, TestResult[] expected)
  {
    Pod.load(typeof.pod.file(`/resources/tests/$podName`).in)
    Testing.test(podName.split('.')[0]).each |t, index| {   
      verify(t.equals(expected.get(index)))
    }
  }
  
  private Uri unzip(Uri uri)
  {
    outDir := tempDir.createDir(uri.basename)
    zipFile := Zip.read(typeof.pod.file(uri).in)
    
    File? file
    while ((file = zipFile.readNext) != null) 
    {
      if (!file.isDir)
      {
        file.copyTo(outDir.createFile(file.path.join("/")), ["overwrite":true])
      }
    }      
    outDir.deleteOnExit
    return outDir.uri
  }
}
