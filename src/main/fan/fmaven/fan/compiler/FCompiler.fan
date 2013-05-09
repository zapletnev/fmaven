using compiler

class FCompiler
{
  FMavenNamespace ns { private set }
  File output { private set }
  
  new make(Uri outDir, Uri podsLoc) 
  { 
    output = File(outDir)
    if (!output.exists) { output.create }
    
    ns = FMavenNamespace.makeFromDir(File(podsLoc))
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
    input.includeDoc  = true
    input.summary     = manifest.podSummary
    input.mode        = CompilerInputMode.file
    input.baseDir     = manifest.baseDir
    input.srcFiles    = manifest.podSrc
    input.index       = manifest.podIndex
    input.outDir      = File.os(output.pathStr) 
    input.output      = CompilerOutputMode.podFile
    meta := manifest.meta.dup 
    meta["pod.docApi"] = true.toStr
    meta["pod.docSrc"] = false.toStr
    meta["pod.native.java"]   = (!manifest.javaDirs.isEmpty).toStr
    meta["pod.native.dotnet"] = false.toStr
    input.meta = meta
    errs := doCompile(input)
    if (!errs[0].isEmpty) return errs.flatten
    
//    if (!manifest.javaDirs.isEmpty) errs.add(compileJava(consumer,projectPath))
      
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
