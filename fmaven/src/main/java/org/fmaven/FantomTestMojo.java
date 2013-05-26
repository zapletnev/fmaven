package org.fmaven;

import static fan.fmavencompiler.Status.fail;
import static fan.fmavencompiler.Status.ok;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.codehaus.plexus.util.StringUtils;

import fan.fmavencompiler.Result;
import fan.fmavencompiler.TestRunner;
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

		for (Object o : new TestRunner().test(podName).toArray()) {
			Result tr = (Result) o;
			if (tr.status == ok) {
				getLog().info("Test " + tr.testName + " passed");
			} else if (tr.status == fail) {
				throw new MojoFailureException("Test " + tr.testName
						+ " failed."
						+ (StringUtils.isEmpty(tr.msg) ? "" : tr.msg));
			}
		}
	}
}
