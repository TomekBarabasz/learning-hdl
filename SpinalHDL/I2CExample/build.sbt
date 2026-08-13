ThisBuild / version := "1.0"
ThisBuild / scalaVersion := "2.13.14"
ThisBuild / organization := "org.example"

val spinalVersion = "1.12.3"
val spinalCore = "com.github.spinalhdl" %% "spinalhdl-core" % spinalVersion
val spinalLib = "com.github.spinalhdl" %% "spinalhdl-lib" % spinalVersion
val spinalIdslPlugin = compilerPlugin("com.github.spinalhdl" %% "spinalhdl-idsl-plugin" % spinalVersion)
val scalatest = "org.scalatest" %% "scalatest" % "3.2.19" % Test

lazy val I2CExample = (project in file("."))
  .settings(
    Compile / scalaSource := baseDirectory.value / "hw/spinal/main",
    Test / scalaSource := baseDirectory.value / "hw/spinal/test",
    libraryDependencies ++= Seq(spinalCore, spinalLib, spinalIdslPlugin, scalatest)
  )

fork := true
