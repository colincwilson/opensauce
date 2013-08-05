function err = doA1A2A3(settings, instance)
	fprintf('\n\t ==> A1, A2, A3 ...');

	% user settings
	F0algorithm = settings.F0algorithm;
	FMTalgorithm = settings.FMTalgorithm;

	% instance data
	matfile = instance.mfile;
	y = instance.y;
	Fs = instance.Fs;
	useTextgrid = instance.useTextgrid;
	textgridfile = instance.textgridfile;
	

	% if (exist(textgridfile, 'file') == 0)
	% 	settings.useTextGrid = 0;
	% end

	err = 0;

	matdata = load(matfile);  % file has to exist at this point - dependency checking should make sure of this

	F0 = func_parseF0(matdata, F0algorithm);
	[F1, F2, F3] = func_parseFMT(matdata, FMTalgorithm);

	if (useTextgrid)
		if (instance.verbose)
			fprintf(' Using Textgrid ');
		end
		try
	    	[A1, A2, A3] = func_GetA1A2A3(y, Fs, F0, F1, F2, F3, settings, textgridfile);
	    catch
	    	err = 1;
	    end
	else
		try
	    	[A1, A2, A3] = func_GetA1A2A3(y, Fs, F0, F1, F2, F3, settings);
	    catch
	    	err = 1;
	    end
	end %endif

	assert (err == 0, 'Error: Something went wrong with (A1, A2, A3)');

	AFMTalgorithm = FMTalgorithm;

	save(matfile, 'A1', 'A2', 'A3', 'AFMTalgorithm', '-append', '-v4');
end %endfunction