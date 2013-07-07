using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "buildpod"
    summary = "Build Pod"
    depends = ["sys 1.0", "build 1.0"]
    srcDirs = [`fan/`]
  }
}
