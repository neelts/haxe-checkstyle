package checkstyle.reporter;

class XMLIDEAReporter extends BaseReporter {

	var style:String;

	/*
	* Solution from mustache.js
	* https://github.com/janl/mustache.js/blob/master/mustache.js#L49
	*/
	static var ENTITY_MAP:Map<String, String> = [
		"&" => "&amp;",
		"<" => "&lt;",
		">" => "&gt;",
		'"' => "&quot;",
		"'" => "&#39;",
		"/" => "&#x2F;"
	];

	static var ENTITY_RE:EReg = ~/[&<>"'\/]/g;

	public function new(numFiles:Int, checkCount:Int, usedCheckCount:Int, path:String, s:String, ns:Bool) {
		super(numFiles, checkCount, usedCheckCount, path, ns);
		style = s;
	}

	override public function start() {
		var sb = new StringBuf();
		sb.add("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
		/*if (style != "") {
			sb.add("<?xml-stylesheet type=\"text/xsl\" href=\"" + style + "\" ?>\n");
		}*/
		sb.add("<problems>\n");
		if (file != null) report.add(sb.toString());

		super.start();
	}

	override public function finish() {
		var sb = new StringBuf();
		sb.add("</problems>\n");
		if (file != null) report.add(sb.toString());

		super.finish();
	}

	function encode(s:String):String {
		return escapeXML(s);
	}

	override public function fileStart(f:CheckFile) {
		/*var sb = new StringBuf();
		sb.add("\t<file name=\"");
		sb.add(encode(f.name));
		sb.add("\">\n");
		if (file != null) report.add(sb.toString());*/
	}

	override public function fileFinish(f:CheckFile) {
		/*var sb = new StringBuf();
		sb.add("\t</file>\n");
		if (file != null) report.add(sb.toString());*/
	}

	static function replace(str:String, re:EReg):String {
		return re.map(str, function(re):String {
			return ENTITY_MAP[re.matched(0)];
		});
	}

	static function escapeXML(string:String):String {
		return replace(string, ENTITY_RE);
	}

	override public function addMessage(m:CheckMessage) {
		var sb:StringBuf = new StringBuf();

		sb.add("\t<problem>\n");

		sb.add("\t\t<file>file://$PROJECT_DIR$/" + m.fileName + "</file>\n");
		sb.add("\t\t<line>" + m.line + "</line>\n");
		sb.add("\t\t<entry_point TYPE=\"file\" FQNAME=\"file://$PROJECT_DIR$/" + m.fileName + "\" />\n");
		sb.add("\t\t<problem_class severity=\"" + m.severity + "\" attribute_key=\"TYPO\">Typo</problem_class>\n");
		sb.add("\t\t<description>" + encode(m.moduleName) + " - " + encode(m.message) + "</description>\n");

		sb.add("\t</problem>\n");

		switch (m.severity) {
			case ERROR: errors++;
			case WARNING: warnings++;
			case INFO: infos++;
			default:
		}

		Sys.print(applyColour(getMessage(m).toString(), m.severity));

		if (file != null) report.add(sb.toString());
	}
}