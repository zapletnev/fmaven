package com.xored.fmaven;

import java.io.File;

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
	
	@Override
	protected void doExecute() {
		File destination = new File(fanOutputDir, podName + ".pod");
		project.getArtifact().setFile(destination);
	}
}
