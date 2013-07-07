using compiler
using build

class Compiler
{
  Uri? baseDir
  Uri? outPodDir 
  Uri? dependsDir
 
  Void compile(BuildPod pod) 
  {
    meta := [:]
    meta["pod.docApi"] = pod.docApi.toStr
    meta["pod.docSrc"] = pod.docSrc.toStr
    meta["pod.native.java"]   = (pod.javaDirs   != null && !pod.javaDirs.isEmpty).toStr
    meta["pod.native.dotnet"] = (pod.dotnetDirs != null && !pod.dotnetDirs.isEmpty).toStr
    meta["pod.native.js"]     = (pod.jsDirs     != null && !pod.jsDirs.isEmpty).toStr

    ci := CompilerInput()
    ci.podName     = pod.podName
    ci.summary     = pod.summary
    ci.version     = pod.version
    ci.depends     = pod.depends.map |s->Depend| { Depend(s) }
    ci.meta        = meta
    ci.index       = pod.index
    ci.baseDir     = File(baseDir)
    ci.srcFiles    = pod.srcDirs
    ci.resFiles    = pod.resDirs
    ci.jsFiles     = pod.jsDirs
    ci.log         = pod.log
    ci.includeDoc  = pod.docApi
    ci.includeSrc  = pod.docSrc
    ci.mode        = CompilerInputMode.file
    ci.outDir      = outPodDir.toFile
    ci.output      = CompilerOutputMode.podFile

    ci.ns = FPodNamespace(dependsDir.toFile)

    try
    {
      compiler::Compiler(ci).compile
    }
    catch (Err err)
    {
      echo("[ERROR]" + err)
    }
  }
}
