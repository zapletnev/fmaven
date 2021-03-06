package org.fmaven;

import java.io.File;

import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.project.MavenProject;

public abstract class FatomMojo extends AbstractMojo {

	protected static final String POD_EXT = "pod";

	/**
	 * @parameter property="project"
	 * @required
	 * @readonly
	 */
	protected MavenProject project;

	/**
	 * Default location of .fan source files.
	 * 
	 * @parameter property="basedir/src/main/fan/"
	 * @required
	 */
	protected File fanDir;

	/**
	 * Location of the output files from the Coffee Compiler. Defaults to
	 * build.directory/fan
	 * 
	 * @parameter property="project.build.directory/fan/lib/fan"
	 * @required
	 */
	protected File fanOutputDir;
}
