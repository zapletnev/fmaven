using concurrent

class CompilerMain
{
  static const Str p := "-pod"
  static const Str o := "-out"
  static const Str r := "-repo"
  static const Str f := "-fan"
  
  private static const Str FAN_ENV_PATH := "FAN_ENV_PATH";
  
  static Void main(Str[] args)
  {
    Str pod := ""
    Str out := ""
    Str fan := ""
    Str repo := ""
    
    args.each |Str s, Int i| 
    {  
      if (p.equals(s)) { pod = args.get(i+1) }
      else if (o.equals(s)) { out = args.get(i+1) }
      else if (r.equals(s)) { repo = args.get(i+1) }
      else if (f.equals(s)) { fan = args.get(i+1) }
    }
    
    if (pod.isEmpty) { throw ArgErr("Invalid pod directory") }
    else if (out.isEmpty) { throw ArgErr("Invalid output directory") }
    else if (fan.isEmpty) { throw ArgErr("Invalid fan.home directory") }
    else if (repo.isEmpty) { throw ArgErr("Invalid repository directory") }
    
    fanpod := File(File.createTemp.uri.parent).createDir("buildpod")
    fanpod.deleteOnExit
    
    File(`resources/build.fan`).copyInto(fanpod, ["overwrite":true])
    src := fanpod.createDir("fan")
    File(Uri(pod).plus(`build.fan`)).copyInto(src, ["overwrite":true])
    
    compile := Process([Uri(fan).plus(`bin/fan`).toStr, 
      File(fanpod.uri.plus(`build.fan`)).toStr], File(Uri(fan)))
    compile.env.remove(FAN_ENV_PATH)
    compile.env.add(FAN_ENV_PATH, fan)
    compile.run.join
    fanpod.delete
    
    buildPod := Pod.find("buildpod")
    if (buildPod == null) { echo("Could not read build.pod"); return; }
    buildType := buildPod.type("Build")
    
    Compiler() 
    {
      outPodDir  = Uri(out)
      baseDir    = Uri(pod)
      dependsDir = Uri(repo)
    }.compile(buildType.make)
  }
}