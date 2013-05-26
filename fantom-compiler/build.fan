using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "fmavencompiler"
    summary = "fMaven Compiler"
    depends = ["sys 1.0", "compiler 1.0"]
    srcDirs = [`tests/`, `fan/`, `fan/testing/`, `fan/compiler/`]
    resDirs = [`resources/tests/`]
  }
}
