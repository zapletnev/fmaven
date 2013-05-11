using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "fancompiler"
    summary = "Extended Fantom Compiler"
    depends = ["sys 1.0", "compiler 1.0"]
    srcDirs = [`tests/`, `fan/`, `fan/compiler/`]
    resDirs = [`resources/tests/`]
  }
}
