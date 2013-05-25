package com.xored.fmaven;

import java.io.File;
import java.util.List;

import org.apache.maven.execution.MavenSession;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.project.MavenProject;
import org.apache.maven.toolchain.ToolchainManager;

public abstract class FatomMojo extends AbstractMojo {

	protected static final String POD_EXT = "pod";

	/**
	 * @parameter property="project"
	 * @required
	 * @readonly
	 */
	protected MavenProject project;

	/**
	 * The Maven Session Object
	 * 
	 * @parameter property="session"
	 * @required
	 * @readonly
	 */
	protected MavenSession session;

	/**
	 * The toolchain manager to use.
	 * 
	 * @component
	 * @required
	 * @readonly
	 */
	protected ToolchainManager toolchainManager;

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
	
	/**
     * @parameter
     */
    protected List<?> srcDirs;
}
