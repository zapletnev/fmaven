package com.xored.fmaven;

import static com.xored.fmaven.compiler.CompileStatus.ERROR;
import static com.xored.fmaven.compiler.CompileStatus.SUCCESSFUL;

import java.io.File;
import java.io.IOException;

import org.apache.maven.artifact.Artifact;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.codehaus.plexus.util.FileUtils;

import com.xored.fmaven.compiler.CompileStatus;
import com.xored.fmaven.compiler.FantomCompiler;
import com.xored.fmaven.utils.PathUtils;

import fan.fancompiler.FanPod;
import fan.sys.List;

/**
 * @goal compile
 * @phase compile
 */
public class FantomCompileMojo extends FatomMojo {

	/**
	 * Pod name
	 * 
	 * @parameter
	 */
	private String podName;

	/**
	 * Pod version
	 * 
	 * @parameter default-value="1.0"
	 */
	private String podVersion;

	/**
	 * Pod summary
	 * 
	 * @parameter default-value=""
	 */
	private String podSummary;

	private final static String buildfan = "build.fan";
	
	@Override
	public void execute() throws MojoExecutionException, MojoFailureException {
		File buildFan = new File(fanDir, buildfan);
		if (!buildFan.exists()) {
			getLog().error(
					"Fantom sources could not be found. Build.fan should be stored in the "
							+ fanDir.getPath());
			return;
		}

		getLog().info(
				String.format("Compiling source %s to %s", podName,
						fanOutputDir.getAbsolutePath()));

		long start = System.currentTimeMillis();
		CompileStatus status = compile(buildFan);
		long duration = (System.currentTimeMillis() - start);

		if (status.code != SUCCESSFUL) {
			getLog().error("Compilation error: " + status.msg);
		} else {
			getLog().info("Compilation finished in " 
					+ String.format("[%.2fs]", duration / 1000.0));
		}
	}

	private CompileStatus compile(File buildFan) {
		File podsRepo;
		try {
			podsRepo = podsRepo();
		} catch (IOException e) {
			return new CompileStatus(ERROR, "Could not create pods repo: "
					+ e.getMessage());
		}
		
		FantomCompiler compiler = new FantomCompiler(podsRepo);

		final FanPod fanPod = FanPod
				.makeFromStr(podName, PathUtils.platformPath(buildFan))
				.version(podVersion).summary(podSummary);
		if (srcDirs != null) {
			fanPod.src(new List(srcDirs.toArray(new String[srcDirs.size()])));
		} else {
			fanPod.src(new List(new String[] { "fan/" }));
		}
		return compiler.compile(fanPod, fanOutputDir);
	}
	
	private File podsRepo() throws IOException {
		File repoDir = File.createTempFile("podsRepo", Long.toString(System.nanoTime()));
		
		repoDir.delete();
		if (!repoDir.exists()) {
			repoDir.mkdir();
		}
		repoDir.deleteOnExit();

		for (Artifact a : project.getDependencyArtifacts()) {
			if (a.getFile() == null) {
				continue;
			}
			try {
				FileUtils.copyFileToDirectory(a.getFile(), repoDir);
				String artifactPodName = a.getFile().getName();
				File podFile = new File(repoDir, a.getFile().getName());
				podFile.renameTo(new File(repoDir, getPodName(artifactPodName)));
			} catch (IOException e) {
			}
		}
		return repoDir;
	}

	private String getPodName(String podWithVersion) {
		String[] parts = podWithVersion.split("-");
		return parts.length > 1 ? parts[0] + ".pod" : podWithVersion;
	}
}
