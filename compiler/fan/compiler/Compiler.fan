using compiler

class Compiler
{
  Namespace ns { private set }
  File output { private set }
  
  new make(Uri outDir, Uri podsLoc) 
  { 
    output = File(outDir)
    if (!output.exists) { output.create }
    
    ns = Namespace.makeFromDir(File(podsLoc))
  }
  
  CompilerErr[] compileAll(FanPod[] pods) 
  {
    CompilerErr[] caughtErrs := [,]
    pods.each { caughtErrs.addAll(compile(it)) }
    return caughtErrs
  }
  
  CompilerErr[] compile(FanPod manifest) 
  {
    buf := StrBuf()
    input := CompilerInput.make
    input.log         = CompilerLog(buf.out)
    input.podName     = manifest.podName
    input.version     = manifest.podVersion
    input.ns          = ns
    input.depends     = manifest.rawDepends.dup
    input.includeDoc  = manifest.podIncludeDoc
    input.summary     = manifest.podSummary
    input.mode        = CompilerInputMode.file
    input.baseDir     = manifest.podDir
    input.srcFiles    = manifest.podSrcDirs
    input.resFiles    = manifest.podResDirs
    input.index       = [:]
    input.outDir      = File.os(output.pathStr) 
    input.output      = CompilerOutputMode.podFile
    meta := [:] 
    meta["pod.docApi"] = manifest.podDocApi.toStr
    meta["pod.docSrc"] = manifest.podDocSrc.toStr
    meta["pod.native.java"]   = false.toStr
    meta["pod.native.dotnet"] = false.toStr
    input.meta = meta
    errs := doCompile(input)
    if (!errs[0].isEmpty) return errs.flatten
    
    podFileName := `${manifest.podName}.pod`
    newPodFile := input.outDir + podFileName
    return errs.flatten
  }
  
  private CompilerErr[][] doCompile(CompilerInput input)
  {
    caughtErrs := CompilerErr[,]
    compiler := compiler::Compiler(input)
    
    try compiler.compile  
    catch(CompilerErr e) { echo(e); caughtErrs.add(e) } 
    catch(Err e) { echo(e); e.trace } //TODO: add logging 
    return [caughtErrs.addAll(compiler.errs), compiler.warns]
  }
  
  Void dispose()
  {
    ns.close
  }
}

class Namespace : CNamespace
{
  private static const Str podExt := "pod"
  
  private const Str:File pods
  
  new make(Str:File pods := [:]) 
  {
    this.pods = pods
    init
  }
  
  new makeFromDir(File pods)
  {
    this.pods = [:].addList(pods.list) |File f -> Str|{ f.basename }
    init
  }
  
  override FPod? findPod(Str podName)
  {
    if(!pods.containsKey(podName)) return null
    pod := pods[podName]
    if(!pod.exists) return null
    fpod := FPod(this, podName, Zip.open(pod))
    fpod.read
    return fpod
  }
  
  private Zip addZip(Zip zip) {
    zips.add(zip)
    return zip
  }
  private Zip[] zips := [,]
  
  public Void close() {
    zips.each { it.close }
  }
}
