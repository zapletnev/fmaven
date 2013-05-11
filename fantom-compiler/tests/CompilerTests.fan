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
