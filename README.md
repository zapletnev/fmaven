### fmaven
  Fantom Maven Plugin has been designed to make working with fantom as easy as possible. 
  The fmaven plug-in is used for compiling/testing/running Fantom code in maven. If there are problems please [let us know](https://github.com/zapletnev/fmaven/issues/new).

### Usage
    <build>
      <plugins>
        ...
        <plugin>
          <groupId>com.xored</groupId>
      		<artifactId>fmaven-plugin</artifactId>
      		<version>0.0.1-SNAPSHOT</version>
      		<extensions>true</extensions>
      		<configuration>
      	    <podName>HelloPod</podName>
            <podVersion>0.0.1</podVersion>
            <podSummary>Hello Pod Summary</podSummary>
          </configuration>
        </plugin>        
      </plugins>
    </build>
    
### Depencencies
    <dependencies>
      ...
      <dependency>
    	  <groupId>org.fantom</groupId>
        <artifactId>sys</artifactId>
        <version>1.0</version>
        <type>pod</type>
      </dependency>
    </dependencies>
