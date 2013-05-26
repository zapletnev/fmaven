class FanPod
{
  File podDir
  
  Str podName
  Str podSummary := ""
  Version podVersion := Version("1.0")
  
  Bool podDocApi
  Bool podDocSrc
  Bool podIncludeDoc
  
  Uri[] podSrcDirs := [`fan/`]
  Uri[] podResDirs := [,]
  
  Depend[] rawDepends := Depend[,]
  
  new make(Str name, Uri podDirPath) {
    podName = name
    podDir = File(podDirPath)
  }
  
  FanPod version(Str version) 
  { 
    podVersion = Version(version)
    return this
  }
  
  FanPod summary(Str summary) 
  { 
    podSummary = summary
    return this
  }
  
  FanPod srcDirs(Str[] srcs)
  {
    podSrcDirs = srcs.map |Str src->Uri| { Uri(src) }
    return this
  }
  
  FanPod resDirs(Str[] resources)
  {
    podResDirs = resources.map |Str src->Uri| { Uri(src) }
    return this
  }
  
  FanPod docApi(Bool value) 
  {
    podDocApi = value
    return this;
  }
  
  FanPod docSrc(Bool value) 
  {
    podDocSrc = value
    return this;
  }
  
  FanPod includeDoc(Bool value) {
    podIncludeDoc = value
    return this
  }
  
  FanPod depend(Str raw) {
    try {
      rawDepends.add(Depend.fromStr(raw))
    } catch(ParseErr e) {
      throw Err("Invalid dependency format $e.msg")
    }
    return this
  }
  
  static new makeFromStr(Str name, Str podDirPathStr) { make(name, Uri.fromStr(podDirPathStr)) }
}
