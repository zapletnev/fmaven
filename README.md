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
            <podVersion>1.0.0</podVersion>
            <podSummary>Hello Pod Summary</podSummary>
            <includeDoc>true</includeDoc>
  			    <docApi>true</docApi>
  			    <docSrc>false</docSrc>
            <srcDirs>
    		  	  <srcDir>fan/</srcDir>
  			  	  <srcDir>tests/</srcDir>
  			    </srcDirs>
  			    <resDirs>
  			      <resDir>tests/</resDir>
  			    </resDirs>
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
        <version>1.0.64</version>
        <type>pod</type>
      </dependency>
    </dependencies>
