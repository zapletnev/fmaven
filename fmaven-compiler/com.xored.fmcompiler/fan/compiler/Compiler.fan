using compiler

class Compiler
{
  Manifest[] manifests := [,]
 
  File outputDir { private set }
  
  new make(Str outDir) 
  { 
    outputDir = File(Uri.fromStr(outDir))
    if (!outputDir.exists) { outputDir.create }
  }
  
  CompilerErr[] compileManifests() 
  {
    CompilerErr[] caughtErrs := [,]
    manifests.each { caughtErrs.addAll(compileManifest(it)) }
    return caughtErrs
  }
  
  CompilerErr[] compileManifest(Manifest manifest) 
  {
    buf := StrBuf()
    input := CompilerInput.make
    input.log         = CompilerLog(buf.out)
    input.podName     = manifest.podName
    input.version     = manifest.version
//    input.ns          = F4Namespace(getAllPods(fp), fp.classpath, fp.javaProject)
    input.depends     = manifest.rawDepends.dup
    input.includeDoc  = true
    input.summary     = manifest.summary
    input.mode        = CompilerInputMode.file
    input.baseDir     = manifest.baseDir
    input.srcFiles    = manifest.srcDirs
    input.resFiles    = manifest.resDirs
    input.index       = manifest.index
    input.outDir      = File.os(outputDir.pathStr) 
    input.output      = CompilerOutputMode.podFile
    input.jsFiles     = manifest.jsDirs
    meta := manifest.meta.dup 
    meta["pod.docApi"] = true.toStr
    meta["pod.docSrc"] = false.toStr
    meta["pod.native.java"]   = (!manifest.javaDirs.isEmpty).toStr
    meta["pod.native.dotnet"] = false.toStr
    meta["pod.native.js"]     = (!manifest.jsDirs.isEmpty).toStr
    input.meta = meta
    errs := compile(input)
    if (!errs[0].isEmpty) return errs.flatten
    
//    if (!manifest.javaDirs.isEmpty) errs.add(compileJava(consumer,projectPath))
      
    podFileName := `${manifest.podName}.pod`
    newPodFile := input.outDir + podFileName
    return errs.flatten
  }
  
  private CompilerErr[][] compile(CompilerInput input)
  {
    caughtErrs := CompilerErr[,]
    compiler := compiler::Compiler(input)
    
    try compiler.compile  
    catch(CompilerErr e) { echo(e); caughtErrs.add(e) } 
    catch(Err e) { echo(e); e.trace }//TODO: add logging 
    return [caughtErrs.addAll(compiler.errs), compiler.warns]
  }
}
