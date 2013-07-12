package org.fmaven;

import java.io.File;
import java.io.IOException;
import java.net.URL;

import org.apache.maven.artifact.Artifact;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.codehaus.plexus.util.FileUtils;

/**
 * @goal compile
 * @phase compile
 */
public class FantomCompileMojo extends FatomMojo {

	private final static String buildfan = "build.fan";

	@Override
	public void execute() throws MojoExecutionException, MojoFailureException {
		final File buildFan = new File(fanDir, buildfan);
		if (!buildFan.exists()) {
			throw new MojoFailureException(
					"Fantom sources could not be found. Build.fan should be stored in the "
							+ "src/main/fan directory");
		}

		URL runtimeZip = this.getClass().getClassLoader()
				.getResource("runtime-1.0.65.zip");
		System.out.println(runtimeZip);

		runtimeZip = this.getClass().getClassLoader()
				.getResource("/runtime-1.0.65.zip");
		System.out.println(runtimeZip);

		File podsRepo;
		try {
			podsRepo = podsRepo();
		} catch (IOException e) {
			throw new MojoExecutionException("Could not create pods repo: "
					+ e.getMessage());
		}

		System.out.println("Compiling...");
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
				// TODO exceprion
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
