package org.fmaven;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;

/**
 * @goal resources
 * @phase generate-resources
 * @requiresDependencyResolution compile
 */
public class FantomPrepareMojo  extends FatomMojo  {
	@Override
	public void execute() throws MojoExecutionException, MojoFailureException {
		// dummy
	}

}
