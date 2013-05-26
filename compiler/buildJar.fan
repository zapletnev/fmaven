using build

class Build : BuildScript
{
  @Target { help = "build fmaven compiler pod as a single JAR dist" }
  Void distFansh()
  {
    dist := JarDist(this)
    dist.outFile = `./fmaven-compiler.jar`.toFile.normalize
    dist.podNames = Str["fmavencompiler", "compiler"]
    dist.mainMethod = "fmavencompiler::Main.main"
    dist.run
  }
}