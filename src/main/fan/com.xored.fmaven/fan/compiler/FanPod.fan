
class FanPod
{
  Str podName
  File podDir
  
  Version podVersion := Version("1.0")
  Str:Obj podIndex := [:]
  Str podSummary := ""
  Uri[] javaDirs := [,]
  Uri[] podSrc := [Uri("fan/")]
  
  const Str:Str meta := [:]
  
  new make(Str name, Uri podDirPath) {
    podName = name
    podDir = File(podDirPath)
  }
  
  FanPod version(Str version) 
  { 
    podVersion = Version(version)
    return this
  }
  
  FanPod index(Str index, Obj obj) 
  { 
    podIndex[index] = obj
    return this
  }
  
  FanPod summary(Str summary) 
  { 
    podSummary = summary
    return this
  }
  
  FanPod src(Str[] srcs)
  {
    podSrc = srcs.map |Str src->Uri| { Uri(src) }
    return this
  }
  
  File baseDir() { podDir }
  
  static new makeFromStr(Str name, Str podDirPathStr) { make(name, Uri.fromStr(podDirPathStr)) }
}
