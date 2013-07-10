using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "fmaven"
    summary = "fMaven Compiler"
    depends = ["sys 1.0", "compiler 1.0", "concurrent 1.0", "build 1.0"]
    srcDirs = [`fan/`, `fan/compiler/`]
    resDirs = [`resources/tests/`]
  }
}
