(
//how long a melody exists before it is replaced
~melodyLifetime = 2;
~melodyCreator = {
	var getMelodyLength = { rrand(3, 6) };
	var getMelodyDurs = { |length| Array.fill(length, { rrand(3, 10) }) };
	var getMelodyFreqs = { |length| Array.fill(length, { rrand(40, 160) })};
	var len = getMelodyLength.value;

	(
		freqs: [ getMelodyFreqs.value(len), getMelodyFreqs.value(len), getMelodyFreqs.value(len)],
		durs: getMelodyDurs.value(len)
	)
};
~updateDashboard = {
	var viewify = { |array|
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

	~melodyTable.removeAll;
	~melodyTable.layout_(
		GridLayout.rows(
			[[makeTitle.value("Melody Table"), columns: ~melody[\durs].size]],
			viewify.value(["durs"] ++ ~melody[\durs]),
			viewify.value(["freq1"] ++ ~melody[\freqs][0]),
			viewify.value(["freq2"] ++ ~melody[\freqs][1]),
			viewify.value(["freq3"] ++ ~melody[\freqs][2]),
		)
	);
	~melodyTable.bounds = Rect(0, (~instGroups.size * 25), 40 * (~melody[\durs].size + 1), 125);
};
)