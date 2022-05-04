// The macro validates conformance to VRML97 specification
// Copyright(C) 2001 by ParallelGraphics, written by Ildar Khairoutdinov (mailto:ild@paragraph.ru)
//
// Some of ~100 checks performed by the macro:
// Node fields: verifies node fields contain correct type of node or PROTO.
// Interpolators: verifies increasing key values, verifies ratio of key to keyValue entries.
// IndexedFaceSet: verifies faces have at least 3 edges, verifies correct relationship between
//                 coord/coordIndex, texCoord/texCoordIndex, colorPerVertex/color/colorIndex,
//                 normalPerVertex/normal/normalIndex. Error if not enough values present.
// Color values: verifies value being in range 0 to 1.
// LOD: verifies range values increasing, 1 more node than range value.
//
// Running the macro:
// 1. As VrmlPad macro: Copy the macro file to AddIns folder and select 'Validate Fields' from the Tools menu
// 2. From command line: Enter at the command prompt
//        CScript /nologo checkfld.js file1.wrl file2.wrl ...
//    or
//        CScript /nologo checkfld.js /f folder
//    where 'checkfld.js', 'fileN.wrl' either local or full path names, 'folder' - path to VRML files (C:\VrmlFiles\)
//    To significantly increase performance, download and register VrmlPad.dll in-process server.

try {
	BindCommand("CheckSemantic", "Checks standard node fields for out-of-range values and valid node types", "Validate Fields")
}
catch (a) {
	if (!WScript.Arguments.length) WScript.Echo("Usage: CScript /nologo checkfld.js [files...][/f folder]");
	else batch_run();
}

function CheckSemantic ()
{
	var rules = [
	[ "Anchor",				"bboxSize", 		chk_bboxsize ],
	[ "Appearance", 		"material", 		"Material" ],
	[ "Appearance", 		"texture",			[ "ImageTexture","MovieTexture","PixelTexture" ]],
	[ "Appearance", 		"textureTransform", "TextureTransform" ],
	[ "AudioClip",			"pitch",			chk_positive ],
	[ "Background", 		"groundAngle",		new Function("f", "return chk_range(f, 0, Math.PI/2) && chk_exceedone(f, 'groundColor')") ],
	[ "Background", 		"groundColor",		chk_color ],
	[ "Background", 		"skyAngle", 		new Function("f", "return chk_range(f, 0, Math.PI) && chk_exceedone(f, 'skyColor')") ],
	[ "Background", 		"skyColor", 		chk_color ],
	[ "Billboard",			"bboxSize", 		chk_bboxsize ],
	[ "Box",				"size", 			chk_positive ],
	[ "Collision",			"bboxSize", 		chk_bboxsize ],
	[ "Color",				"color",			chk_color ],
	[ "ColorInterpolator",	"keyValue", 		new Function("f", "return chk_color(f) && chk_inter(f)") ],
	[ "Cone",				"bottomRadius", 	chk_positive ],
	[ "Cone",				"height",			chk_positive ],
	[ "CoordinateInterpolator","keyValue",		new Function("f", "return chk_inter(f, true)") ],
	[ "Cylinder",			"height",			chk_positive ],
	[ "Cylinder",			"radius",			chk_positive ],
	[ "CylinderSensor", 	"diskAngle",		new Function("f", "return chk_positive(f) && chk_range(f, 0, Math.PI/2)") ],
	[ "CylinderSensor", 	"maxAngle", 		new Function("f", "return chk_range(f, -Math.PI*2, Math.PI*2)") ],
	[ "CylinderSensor", 	"minAngle", 		new Function("f", "return chk_range(f, -Math.PI*2, Math.PI*2)") ],
	[ "DirectionalLight",	"ambientIntensity", chk_color ],
	[ "DirectionalLight",	"color",			chk_color ],
	[ "DirectionalLight",	"intensity",		chk_color ],
	[ "ElevationGrid",		"color",			"Color" ],
	[ "ElevationGrid",		"normal",			"Normal" ],
	[ "ElevationGrid",		"texCoord", 		"TextureCoordinate" ],
	[ "ElevationGrid",		"creaseAngle",		chk_notneg ],
	[ "ElevationGrid",		"xDimension",		chk_notneg ],
	[ "ElevationGrid",		"xSpacing", 		chk_positive ],
	[ "ElevationGrid",		"zDimension",		chk_notneg ],
	[ "ElevationGrid",		"zSpacing", 		chk_positive ],
	[ "Extrusion",			"creaseAngle",		chk_notneg ],
	[ "Extrusion",			"orientation",		chk_orient ],
	[ "Extrusion",			"scale",			chk_positive ],
	[ "Fog",				"color",			chk_color ],
	[ "Fog",				"visibilityRange",	chk_notneg ],
	[ "FontStyle",			"size", 			chk_positive ],
	[ "FontStyle",			"spacing",			chk_notneg ],
	[ "Group",				"bboxSize", 		chk_bboxsize ],
	[ "IndexedLineSet", 	"color",			"Color" ],
	[ "IndexedLineSet", 	"coord",			"Coordinate" ],
	[ "IndexedLineSet", 	"coordIndex",		new Function("f", "return chk_index(f, 'coord', 'point')") ],
	[ "IndexedLineSet", 	"colorIndex",		new Function("f", "return chk_index(f, 'color', 'color')") ],
	[ "Inline",				"bboxSize", 		chk_bboxsize ],
	[ "LOD",				"range",			new Function("f", "return chk_positive(f) && chk_monotonic(f) && chk_exceedone(f, 'level')") ],
	[ "Material",			"ambientIntensity", chk_color ],
	[ "Material",			"diffuseColor", 	chk_color ],
	[ "Material",			"emissiveColor",	chk_color ],
	[ "Material",			"shininess",		chk_color ],
	[ "Material",			"specularColor",	chk_color ],
	[ "Material",			"transparency", 	chk_color ],
	[ "NavigationInfo", 	"avatarSize",		chk_notneg ],
	[ "NavigationInfo", 	"speed",			chk_notneg ],
	[ "NavigationInfo", 	"visibilityLimit",	chk_notneg ],
	[ "NormalInterpolator", "keyValue", 		new Function("f", "return chk_inter(f, true)") ],
	[ "OrientationInterpolator","keyValue", 	new Function("f", "return chk_orient(f) && chk_inter(f)") ],
	[ "PointLight", 		"ambientIntensity", chk_color ],
	[ "PointLight", 		"attenuation",		chk_notneg ],
	[ "PointLight", 		"color",			chk_color ],
	[ "PointLight", 		"intensity",		chk_color ],
	[ "PointLight", 		"radius",			chk_notneg ],
	[ "PositionInterpolator", "keyValue",		chk_inter ],
	[ "ProximitySensor",	"size", 			chk_notneg ],
	[ "ScalarInterpolator", "keyValue", 		chk_inter ],
	[ "Shape",				"appearance",		"Appearance" ],
	[ "Shape",				"geometry", 		[ "Box","Cone","Cylinder","ElevationGrid","Extrusion","IndexedFaceSet","IndexedLineSet","PointSet","Sphere","Text" ]],
	[ "Sound",				"source",			"AudioClip" ],
	[ "Sound",				"intensity",		chk_color ],
	[ "Sound",				"maxBack",			chk_notneg ],
	[ "Sound",				"maxFront", 		chk_notneg ],
	[ "Sound",				"minBack",			chk_notneg ],
	[ "Sound",				"minFront", 		chk_notneg ],
	[ "Sound",				"priority", 		chk_color ],
	[ "Sphere", 			"radius",			chk_positive ],
	[ "SphereSensor",		"offset",			chk_orient ],
	[ "SpotLight",			"ambientIntensity", chk_color ],
	[ "SpotLight",			"attenuation",		chk_notneg ],
	[ "SpotLight",			"beamWidth",		new Function("f", "return chk_positive(f) && chk_range(f, 0, Math.PI/2)") ],
	[ "SpotLight",			"color",			chk_color ],
	[ "SpotLight",			"cutOffAngle",		new Function("f", "return chk_positive(f) && chk_range(f, 0, Math.PI/2)") ],
	[ "SpotLight",			"intensity",		chk_color ],
	[ "SpotLight",			"radius",			chk_notneg ],
	[ "Text",				"fontStyle",		"FontStyle" ],
	[ "Text",				"length",			chk_notneg ],
	[ "Text",				"maxExtent",		chk_notneg ],
	[ "TimeSensor", 		"cycleInterval",	chk_positive ],
	[ "Transform",			"rotation", 		chk_orient ],
	[ "Transform",			"scale",			chk_positive ],
	[ "Transform",			"scaleOrientation", chk_orient ],
	[ "Transform",			"bboxSize", 		chk_bboxsize ],
	[ "Viewpoint",			"fieldOfView",		new Function("f", "return chk_positive(f) && chk_range(f, 0, Math.PI)") ],
	[ "Viewpoint",			"orientation",		chk_orient ],
	[ "VisibilitySensor",	"size", 			chk_notneg ],

	[ "IndexedFaceSet", 	"color",			"Color" ],
	[ "IndexedFaceSet", 	"coord",			"Coordinate" ],
	[ "IndexedFaceSet", 	"normal",			"Normal" ],
	[ "IndexedFaceSet", 	"texCoord", 		"TextureCoordinate" ],
	[ "IndexedFaceSet", 	"creaseAngle",		chk_notneg ],
	[ "IndexedFaceSet", 	"colorIndex",		new Function("f", "return chk_index(f, 'color', 'color')") ],
	[ "IndexedFaceSet", 	"normalIndex",		new Function("f", "return chk_index(f, 'normal', 'vector')") ],
	[ "IndexedFaceSet", 	"texCoordIndex",	new Function("f", "return chk_index(f, 'texCoord', 'point')") ],
	[ "IndexedFaceSet", 	"coordIndex",		chk_coordIndex ],
	null ];
	for (var i = 0; rules[i]; i++)
		if (!chk_rule(StdProtos(rules[i][0]).Instances, rules[i][1], rules[i][2]))
			return;
	Window.StatusText("Checking complete. No errors have been found.", 0x108010);
}

var batch_mode = false;

function chk_rule (inst, fldname, fn)
{
	Window.StatusText("Checking " + fldname + " fields...");
	for (var e = new Enumerator(inst); !e.atEnd(); e.moveNext()) {
		var fld = e.item()(fldname);
		var ised = fld.Interface;
		if (!ised) {
			if (!(typeof(fn) == "function" ? fn(fld) : chk_node(fld, fn)) && !batch_mode)
				return false;
		}
		else if ((ised.Category == vpcField || ised.Category == vpcExposedField) &&
				!chk_rule(ised.Owner.Instances, ised.Name, fn) && !batch_mode)
			return false;
	}
	return true;
}

function chk_val (fld, pred)
{
	var val = fld.Value;
	var i = -1, j = 0;
	switch (fld.Type) {
		case vpfSFFloat:
		case vpfSFTime:
		case vpfSFInt32:
			if (pred(val)) i = 0;
			break;
		case vpfMFFloat:
		case vpfMFInt32:
			var arr = val.Array.toArray();
			for (i = arr.length; i > 0 && pred(arr[j++]); i--);
			break;
		case vpfSFColor:
			if (pred(val.Red) && pred(val.Green) && pred(val.Blue)) i = 0;
			break;
		case vpfMFColor:
			for (i = val.Count; i > 0; i--)
				with (val(++j)) if (!pred(Red) || !pred(Green) || !pred(Blue)) break;
			break;
		case vpfSFRotation:
		case vpfSFVec3f:
			if (pred(val.x) && pred(val.y) && pred(val.z)) i = 0;
			break;
		case vpfMFRotation:
		case vpfMFVec3f:
			for (i = val.Count; i > 0; i--)
				with (val(++j)) if (!pred(x) || !pred(y) || !pred(z)) break;
			break;
		case vpfSFVec2f:
			if (pred(val.x) && pred(val.y)) i = 0;
			break;
		case vpfMFVec2f:
			for (i = val.Count; i > 0; i--)
				with (val(++j)) if (!pred(x) || !pred(y)) break;
			break;
	}
	if (i) select_err(fld, i < 0 ? 0 : j);
	return !i;
}

function chk_cnt (fld, cof, pred)
{
	if (!cof || pred(fld.Count, cof.Count))
		return true;
	select_err(fld);
	return false;
}

function chk_color (fld)
{
	var b = chk_val(fld, new Function("v", "return v>=0 && v<=1"));
	if (!b) Window.alert("Value of " + fld.Name + " shall be in range [0..1]");
	return b;
}

function chk_range (fld, min, max)
{
	var b = chk_val(fld, new Function("v", "return v>=" + min + "&& v<=" + max));
	if (!b) Window.alert("Value of " + fld.Name + " shall be in range [" + min + ".." + max + "]");
	return b;
}

function chk_positive (fld)
{
	var b = chk_val(fld, new Function("v", "return v>0"));
	if (!b) Window.alert("Value of " + fld.Name + " shall be positive.");
	return b;
}

function chk_notneg (fld)
{
	var b = chk_val(fld, new Function("v", "return v>=0"));
	if (!b) Window.alert("Value of " + fld.Name + " shall not be negative.");
	return b;
}

function chk_orient (fld)
{
	var b = chk_val(fld, new Function("v", "return v>=-1 && v<=1"));
	if (!b) Window.alert("Axis components of " + fld.Name + " shall be in range [-1..1].");
	return b;
}

function chk_bboxsize (fld)
{
	var val = fld.Value;
	return val.x==-1 && val.y==-1 && val.z==-1 || chk_notneg(fld);
}

function chk_index (fld, src, cofld)
{
	var n = get_cofield(fld, src);
	var num = 0;
	if (n && n.Value)
		try {
			num = n.Value(cofld).Count;
		}
		catch(a) {
		}
	return chk_range(fld, -1, num-1);
}

function chk_inter (fld, multy)
{
	var key = get_cofield(fld, 'key');
	var b = chk_cnt(fld, key, new Function("v1", "v2", multy ? "return v1==v2 || v2 && !(v1 % v2)" : "return v1==v2"));
	if (!b) Window.alert("The number of values in the " + fld.Name + " field shall be " +
			(multy ? "an integer multiple of" : "equal to") + " the number of keyframes in the " + key.Name + " field.");
	else b = chk_monotonic(key);
	return b;
}

function chk_exceedone (fld, cofld)
{
	var cof = get_cofield(fld, cofld);
	var b = chk_cnt(fld, cof, new Function("v1", "v2", "return !v1 && !v2 || v1==v2-1"));
	if (!b) Window.alert("The number of values in the " + cof.Name +
			" field shall exceed the number of values in the " + fld.Name + " field by one.");
	return b;
}

function chk_monotonic (fld)
{
	for (var i = 1, cnt = fld.Count; i <= cnt; i++)
		if (i > 1 && fld(i-1) >= fld(i)) {
			select_err(fld, i);
			Window.alert("Each value in the " + fld.Name + " field shall be greater than the previous value.");
			return false;
		}
	return true;
}

function max_val (fld)
{
	var val = fld.Value, mv = -1;
	for (var i = 1, cnt = fld.Count; i <= cnt; i++)
		if (val(i) > mv) mv = val(i);
	return mv;
}

function chk_index2 (fld, src, cofld, spv, sind, val, fs)
{
	var ndf = get_cofield(fld, src);
	if (!ndf || !ndf.Value)
		return true;
	try {
		var cpv = !spv || get_cofield(fld, spv).Value;
		var ind = get_cofield(fld, sind);
		var cnt = val.Count;
		if (ind.Count) {
			if (ind.Count < (cpv ? cnt : fs)) {
				select_err(ind);
				Window.alert("There shall be at least as many indices in the " + ind.Name + " field as there are " +
								(cpv ? "indices in the coordIndex field." : "faces in the IndexedFaceSet."));
				return false;
			}
			if (cpv)
				for (var i = 1; i <= cnt; i++)
					if ((val(i) < 0) != (ind(i) < 0)) {
						select_err(ind, i);
						Window.alert("The " + ind.Name + " field shall contain end-of-face markers (-1) in exactly the same places as the coordIndex field.");
						return false;
					}
		}
		else
			if (ndf.Value(cofld).Count < (cpv ? max_val(fld)+1 : fs)) {
				select_err(ndf);
				Window.alert("There must be at least as many " + cofld + "s in the " + ndf.Value.TypeName + " node as " +
					(cpv ? "the greatest index in the coordIndex field." : "there are faces in the IndexedFaceSet"));
				return false;
			}
	}
	catch(a) {
	}
	return true;
}

function chk_coordIndex (fld)
{
	if (!chk_index(fld, 'coord', 'point'))
		return false;
	var val = fld.Value;
	var i = 0, j = 0, cnt = val.Count, fs = 0;
	while (++i <= cnt+1)
		if (i <= cnt && val(i) >= 0) j++;
		else if (j) {
			fs++;
			if (j < 3) {
				select_err(fld, i - j);
				Window.alert("Each face of the IndexedFaceSet shall have at least three non-coincident vertices.");
				return false;
			}
			else j = 0;
		}
	return chk_index2(fld, 'color', 'color', 'colorPerVertex', 'colorIndex', val, fs) &&
		   chk_index2(fld, 'normal', 'vector', 'normalPerVertex', 'normalIndex', val, fs) &&
		   chk_index2(fld, 'texCoord', 'point', 0, 'texCoordIndex', val, fs);
}

function get_cofield (fld, name)
{
	var cofld = null;
	try {
		var owner = fld.Owner;
		var proto = owner.EntityType == vpNode ? owner.Prototype : null;
		if (proto && !proto.Standard) {
			cofld = get_cofield(proto(fld.Name).Implements(1), name);
			if (cofld && cofld.Owner != owner && cofld.Interface)
				name = cofld.Interface.Name;
		}
		cofld = owner(name);
	}
	catch(a) {
	}
	return cofld;
}

function chk_node (fld, val)
{
	if (!fld.Value) return true;
	try {
		for (var p = fld.Value.Prototype; !p.Standard && p.EntityType == vpProto; p = p.RootNodes(1).Prototype);
		if (p.EntityType == vpExternProto) return true;
		if (typeof(val) == "string") {
			if (p.Name == val) return true;
		}
		else
			for (var i = 0; i < val.length; i++)
				if (p.Name == val[i]) return true;
	}
	catch(a) {
	}
	select_err(fld);
	var str;
	if (typeof(val) == "string")
		str = val;
	else
		for (var i = 0; i < val.length; str += val[i++])
			if (!i) str = "one of "; else str += ", ";
	Window.alert("Value of " + fld.Name + " shall be NULL or " + str);
	return false;
}

var err_rng;

function select_err (fld, ind)
{
	with (fld) err_rng = (Implicit ? Owner.Range(vprnId) : (!ind ? Range(vprnName) : ValueRange(ind)));
	if (!batch_mode) err_rng.Select();
}

function batch_run ()
{
	var doc;
	try {
		doc = new ActiveXObject("VrmlPadLite.Document");
	}
	catch (a) {
		doc = new ActiveXObject("VrmlPad.Document");
		WScript.Echo("Please, download and register VrmlPad.dll in-process server to increase performance");
	}
	StdProtos = doc.StdProtos;
	Window = new Object;
	Window.StatusText = new Function("s", "");
	Window.alert = console_err;
	batch_mode = true;
	vprnId = 1
	vprnName = 2;
	vpNode = 1;
	vpProto = 3;
	vpExternProto = 4;
	vpcField = 1;
	vpcExposedField = 4;
	vpfSFBool = 1;
	vpfSFColor = 2;
	vpfSFFloat = 3;
	vpfSFImage = 4;
	vpfSFInt32 = 5;
	vpfSFNode = 6;
	vpfSFRotation = 7;
	vpfSFString = 8;
	vpfSFTime = 9;
	vpfSFVec2f = 10;
	vpfSFVec3f = 11;
	vpfMFColor = 12;
	vpfMFFloat = 13;
	vpfMFInt32 = 14;
	vpfMFNode = 15;
	vpfMFRotation = 16;
	vpfMFString = 17;
	vpfMFTime = 18;
	vpfMFVec2f = 19;
	vpfMFVec3f = 20;
	var files = new Array;
	var count = 0;
	for (var e = new Enumerator(WScript.Arguments); !e.atEnd(); e.moveNext())
		if (e.item() == "/f" || e.item() == "-f") {
			e.moveNext();
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			for (var fc = new Enumerator(fso.GetFolder(e.item()).files); !fc.atEnd(); fc.moveNext())
				switch (fso.GetExtensionName(fc.item())) {
					case "wrl": case "wrz": files[count++] = fc.item();
				}
		}
		else
			files[count++] = e.item();
	for (var i = 0; i < count; i++) {
		try {
			doc.OpenFile(files[i]);
		}
		catch (a) {
			WScript.Echo(files[i] + ": file not found");
			continue;
		}
		WScript.Echo(doc.FileName);
		CheckSemantic();
	}
}

function console_err (str)
{
	WScript.Echo("Line " + err_rng.FromLine + ", col " + err_rng.FromRow + ": " + str);
}
