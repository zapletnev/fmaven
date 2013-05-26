package org.fmaven;

import java.io.File;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;

/**
 * @goal package
 * @phase package
 */
public class FantomPackageMojo extends FatomMojo {

	/**
	 * Pod name
	 * 
	 * @parameter
	 */
	private String podName;
	
	public void execute() throws MojoExecutionException, MojoFailureException {
		File destination = new File(fanOutputDir, podName + ".pod");
		project.getArtifact().setFile(destination);
	}
}
