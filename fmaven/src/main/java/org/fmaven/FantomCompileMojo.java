package org.fmaven;

import static org.fmaven.utils.PathUtils.platformPath;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.apache.maven.artifact.Artifact;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.codehaus.plexus.util.FileUtils;

import com.google.common.base.Joiner;

import fan.compiler.CompilerErr;
import fan.fmavencompiler.FanPod;
import fan.sys.Env;
import fan.sys.Pod;
import fan.sys.Sys;
import fan.sys.Uri;

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

	/**
	 * Source directories
	 * 
	 * @parameter
	 */
	protected List<?> srcDirs;

	/**
	 * Resources directories
	 * 
	 * @parameter
	 */
	protected List<?> resDirs;

	/**
	 * @parameter
	 */
	private boolean includeDoc;

	/**
	 * @parameter
	 */
	private boolean docApi;

	/**
	 * @parameter
	 */
	private boolean docSrc;

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
		CompilerErr[] errors = compile(buildFan);
		long duration = (System.currentTimeMillis() - start);

		if (errors.length > 0) {
			throw new MojoFailureException("Compilation error: "
					+ Joiner.on("; ").join(errors));
		} else {
			getLog().info(
					"Compilation finished in "
							+ String.format("[%.2fs]", duration / 1000.0));
		}
	}

	private CompilerErr[] compile(File buildFan) throws MojoExecutionException {
		File podsRepo;
		try {
			podsRepo = podsRepo();
		} catch (IOException e) {
			throw new MojoExecutionException("Could not create pods repo: "
					+ e.getMessage());
		}

		boot();

		FanPod pod = FanPod.makeFromStr(podName, platformPath(buildFan))
				.version(podVersion).summary(podSummary).srcDirs(srcDirs())
				.resDirs(resDirs()).includeDoc(includeDoc).docApi(docApi)
				.docSrc(docSrc);

		if (!fanOutputDir.exists()) {
			fanOutputDir.mkdirs();
		}
		fan.fmavencompiler.Compiler compiler = fan.fmavencompiler.Compiler
				.make(path(fanOutputDir), path(podsRepo));
		fan.sys.List errors = compiler.compile(pod);
		compiler.dispose();

		return (CompilerErr[]) errors.toArray(new CompilerErr[0]);
	}

	private void boot() {
		System.getProperties().put("fan.jardist", "true");
		System.getProperties().put("fan.home", ".");

		Env.cur().loadPodClass(Pod.find("sys"));
		Env.cur().loadPodClass(Pod.find("compiler"));
		Env.cur().loadPodClass(Pod.find("fmavencompiler"));

		Sys.boot();
	}

	private static final String PODS_REPO = "podsRepo";

	private File podsRepo() throws IOException {
		File repoDir = File.createTempFile(PODS_REPO,
				Long.toString(System.nanoTime()));

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

	private fan.sys.List srcDirs() {
		return srcDirs != null ? new fan.sys.List(
				srcDirs.toArray(new String[srcDirs.size()]))
				: new fan.sys.List(new String[] { "fan/" });
	}

	private fan.sys.List resDirs() {
		return resDirs != null ? new fan.sys.List(
				resDirs.toArray(new String[resDirs.size()]))
				: new fan.sys.List(new String[] {});
	}

	private String getPodName(String podWithVersion) {
		String[] parts = podWithVersion.split("-");
		return parts.length > 1 ? parts[0] + ".pod" : podWithVersion;
	}

	private static Uri path(File f) {
		return Uri.fromStr(platformPath(f, true));
	}
}
