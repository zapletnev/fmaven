using compiler

class FMavenNamespace : CNamespace
{
  private static const Str podExt := "pod"
  
  private const Str:File pods
  
  new make(Str:File pods := [:]) 
  {
    this.pods = pods
    init
  }
  
  new makeFrom(File podsDir)
  {
    this.pods = [:].addList(podsDir.list) |File f -> Str|{ f.basename }
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