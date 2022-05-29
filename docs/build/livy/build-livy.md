

# Livy build

Livy must be built with support for Spark 3.2+  
The standard Livy build cannot run using scala version used by Spark (2.12.15)

Spark 3.2 requires Scala 2.12, building for 2.12 requires a few steps.

- git clone https://github.com/apache/incubator-livy.git
- update pom.xml 
  - update scala-maven-plugin to version 5.4.5
  - update spark-3.0 profile to use latest version of spark
  - update scala-2.12.version to 2.12.15
  - update scala.binary.version to 2.12
  
- update python-apy/pom.xml
  - change to executable from python to python3
  
see example poms
- 

see: https://stackoverflow.com/questions/67085984/how-to-rebuild-apache-livy-with-scala-2-12
