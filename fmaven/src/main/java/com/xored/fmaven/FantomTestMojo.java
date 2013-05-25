package com.xored.fmaven;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.codehaus.plexus.util.StringUtils;

import fan.fancompiler.TestResult;
import fan.fancompiler.Testing;
import fan.sys.File;
import fan.sys.Pod;

/**
 * @goal test
 * @phase test
 */

public class FantomTestMojo extends FatomMojo {

	/**
	 * Pod name
	 * 
	 * @parameter
	 */
	private String podName;
	
	@Override
	public void execute() throws MojoExecutionException, MojoFailureException {
		File podFile = File.os(fanOutputDir + "/" + podName + ".pod");
		if (!podFile.exists()) {
			getLog().error(
					"Tests skipped, pod " + podName + " could not be founded");
			return;
		}
		Pod.load(podFile.in());
		
		for (Object o : Testing.test(podName).toArray()) {
			TestResult tr = (TestResult) o;
			if (tr.severity == 1) {
				getLog().info("Test " + tr.testName + " passed");
			} else if (tr.severity == 0) {
				throw new MojoFailureException("Test " + tr.testName + " failed." + 
			(StringUtils.isEmpty(tr.msg) ? "" : tr.msg));
			}
		}
	}
}
