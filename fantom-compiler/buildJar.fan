using build

class Build : BuildScript
{
  @Target { help = "build fmaven pod as a single JAR dist" }
  Void distFansh()
  {
    dist := JarDist(this)
    dist.outFile = `./fmaven-compiler.jar`.toFile.normalize
    dist.podNames = Str["fancompiler", "compiler"]
    dist.mainMethod = "fancompiler::Main.main"
    dist.run
  }
}