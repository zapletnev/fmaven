package com.xored.fmaven.compiler;

import static com.xored.fmaven.utils.PathUtils.platformPath;

import java.io.File;

import com.google.common.base.Joiner;

import fan.fmaven.FCompiler;
import fan.fmaven.FanPod;
import fan.sys.Env;
import fan.sys.List;
import fan.sys.Pod;
import fan.sys.Sys;
import fan.sys.Uri;

public class FantomCompiler {

	private File podsRepo;

	public FantomCompiler(File podsRepo) {
		boot();
		
		this.podsRepo = podsRepo;
	}
	
	public CompileStatus compile(FanPod pod, File fanOutputDir) {
		if (!fanOutputDir.exists()) {
			fanOutputDir.mkdirs();
		}
		FCompiler compiler = FCompiler.make(path(fanOutputDir),
				path(podsRepo));
		List errors = compiler.compile(pod);
		compiler.dispose();

		if (errors.isEmpty()) {
			return status(CompileStatus.SUCCESSFUL);
		} 
		return status(CompileStatus.ERROR, Joiner.on("; ").join(errors.toArray()));
	}

	private void boot() {
		System.getProperties().put("fan.jardist", "true");
		System.getProperties().put("fan.home", ".");
		Sys.boot();
		
		Env.cur().loadPodClass(Pod.find("sys"));
		Env.cur().loadPodClass(Pod.find("compiler"));
		Env.cur().loadPodClass(Pod.find("fmaven"));
	}
	
	private static Uri path(File f) {
		return Uri.fromStr(platformPath(f, true));
	}
	
	private static CompileStatus status(int code, String msg) {
		return new CompileStatus(code, msg);
	}

	private static CompileStatus status(int code) {
		return new CompileStatus(code);
	}
}
