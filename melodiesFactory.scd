(
//how long a melody exists before it is replaced
~melodyLifetime = 30;
~melodiesCreator = {
	var getMelodyLength = { rrand(3, 6) };
	var getMelodyDurs = { |length| Array.fill(length, { rrand(3, 10) }) };
	var getMelodyFreqs = { |length| Array.fill(length, { rrand(40, 160) })};

	Array.fill(3, {
		var len = getMelodyLength.value;
		(
			freqs: [ getMelodyFreqs.value(len), getMelodyFreqs.value(len), getMelodyFreqs.value(len)],
			durs: getMelodyDurs.value(len)
		)
	})
};
~updateDashboard = {
	var makeRow = { |array|
		array.collect({ |item|
			i = StaticText();
			i.string = item;
			i.align = \topLeft
		})
	};
	var makeTitle = {
		arg titleText;
		t = StaticText();
		t.string = titleText;
		t.align = \topLeft;
	};
	var tables = ~melodies.collect(
		{ arg melody, index;
			[GridLayout.rows(
				[[makeTitle.value("Melody Table " + (index+1)), columns: melody[\durs].size]],
				makeRow.value(["durs"] ++ melody[\durs]),
				makeRow.value(["freq1"] ++ melody[\freqs][0]),
				makeRow.value(["freq2"] ++ melody[\freqs][1]),
				makeRow.value(["freq3"] ++ melody[\freqs][2]),
			)]
		}
	);
	~melodiesTable.removeAll;
	~melodiesTable.layout_(
		GridLayout.columns(*tables)
	);
	~melodiesTable.bounds = Rect(0, (~instGroups.size * 25), 800, 125);
};
)



