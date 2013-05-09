package com.xored.fmaven.compiler;

import static com.xored.fmaven.utils.PathUtils.platformPath;

import java.io.File;

import com.google.common.base.Joiner;

import fan.fmaven.FCompiler;
import fan.fmaven.FanPod;
import fan.sys.List;
import fan.sys.Uri;

public class FantomCompiler {

	public CompileStatus compile(FanPod pod, File fanOutputDir, File podRepo) {
		if (!fanOutputDir.exists()) {
			fanOutputDir.mkdirs();
		}
		FCompiler compiler = FCompiler.make(path(fanOutputDir),
				path(podRepo));
		List errors = compiler.compile(pod);
		compiler.dispose();

		if (errors.isEmpty()) {
			return status(CompileStatus.SUCCESSFUL);
		} 
		return status(CompileStatus.ERROR, Joiner.on("; ").join(errors.toArray()));
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
