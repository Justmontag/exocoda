


Function _Array10(v0 = Undefined, v1 = Undefined, v2 = Undefined, v3 = Undefined, v4 = Undefined, 
	v5 = Undefined, v6 = Undefined, v7 = Undefined, v8 = Undefined, v9 = Undefined) Export
	
	Array = New Array;
	
	If v0 = Undefined Then Return Array; EndIf;
	
	Array.Add(v0);
	
	If v1 = Undefined Then 	Return Array; EndIf;
	
	Array.Add(v1); 
	
	If v2 = Undefined Then Return Array; EndIf;
	
	Array.Add(v2);
	
	If v3 = Undefined Then	Return Array; EndIf;
	
	Array.Add(v3);
	
	If v4 = Undefined Then 	Return Array; EndIf;
	
	Array.Add(v4);
	
	If v5 = Undefined Then	Return Array; EndIf;
	
	Array.Add(v5);
	
	If v6 = Undefined Then	Return Array; EndIf;
	
	Array.Add(v6);
	
	If v7 = Undefined Then 	Return Array; EndIf;
	
	Array.Add(v7);
	
	If v8 = Undefined Then	Return Array; EndIf;
	
	Array.Add(v8);
	
	If v9 = Undefined Then	Return Array; EndIf;
	
	Array.Add(v9);
	
	Return Array;	
		
EndFunction

Function _SplitArray(array, minelements = 0, maxarrays = 0) Export
	
	newarrays = New Array;
	
	count = array.Count();
	
	If count = 0 Then
		Return newarrays;
	EndIf;
	
	If minelements = 0 and maxarrays = 0 Then
		elements = 1;
		arrays = count;
	Elsif minelements = 0 Then
		elements = Max(1, Int(count / maxarrays));
		arrays = maxarrays;
	Elsif maxarrays = 0 Then
		elements = minelements;
		arrays = Int(count / minelements) + ?(count % minelements, 1, 0);
	Else
		arrays = Min(Int(count / minelements) + ?(count % minelements, 1, 0), maxarrays);
	    elements = Int(count / arrays);
	EndIf;
	
	curarray = New Array;
	
	curarrayindex = 1;
	
	curarrayelems = 0;
	
	For i = 0 To array.UBound() Do
		
		If curarrayelems > elements And curarrayindex < arrays Then
			
			newarrays.Add(curarray);
			
			curarray = New Array;
			
			curarrayelems = 0;
			
			_Inc(curarrayindex);
			
		EndIf;
		
		curarray.Add(array[i]);
		
		_Inc(curarrayelems);
		
	EndDo;
	
	If curarray.Count() Then
		newarrays.Add(curarray);
	EndIf;
	
	Return newarrays;	
	
EndFunction

Function _CountLmt(value) Export
	Return ?(value = 0, False, _Dec(value) = 0);
EndFunction

Function _Inc(value) Export
	
	value = value + 1;
	
	Return value;
	
EndFunction

Function _Dec(value) Export
	
	value = value - 1;
	
	Return value;
	
EndFunction

Function _Str2Map(str, spr = "|") Export
	
	array = StrSplit(str, spr);
	
	map = New Map;
		
	For n = 0 To Int(array.count() / 2) - 1 Do
		
		map.Insert(array[n * 2], array[n * 2] + 1);
		
	EndDo;
	
	Return map;
	
EndFunction

Function _QRS2Map(qrs, fieldkey, fieldvalue) Export
	
	map = New Map;
	
	While qrs.Next() Do
		
		map.Insert(qrs[fieldkey], qrs[fieldvalue]);
		
	EndDo;
	
	Return map;
	
EndFunction

Function _AddVal2ArraysMap(map, key, value) Export
	
	array = map.Get(key);
	
	array = ?(array = Undefined, New Array, array);
	
	array.Add(value);
	
	map.Insert(key, array);
	
	return map;
	
EndFunction

Function _AddVal2MapMap(map, keys, value) Export
	
	If Not keys.Count() Then
		If map.Get(value) = UNdefined Then
			map.Insert(value, Undefined);
		EndIf;
		return map;	
	EndIf;
	
	smap = map.Get(keys[0]);
	smap = ?(smap = Undefined, New Map, smap);
	map.Insert(keys[0], _AddVal2MapMap(smap, _TrimArray(keys, 1), value));
	
	return map;
	
EndFunction

Function _AddArray(array1, array2) Export
	
	For Each elem In array2 Do
		array1.Add(elem);
	EndDo;
	
	Return array1;
	
EndFunction

Function _ArraySum(array) Export
	
	//#If Server Then
	//	
	//	cname = "tmp";
	//	valuetable = New ValueTable;
	//	valuetable.Columns.Add(cname);
	//	valuetable.LoadColumn(array, cname);
	//	
	//	Try
	//		Return valuetable.Total(cname);
	//	Except
	//		Return undefined;	
	//	EndTry;	
	//	
	//#Else
		
		sum = 0;
		
		For Each elem In array Do
			Try
				sum = sum + elem;
			Except
				Return undefined;
			EndTry;
		EndDo;
		
		Return sum;
	//#EndIf

EndFunction

Function _SubArray(array, count) Export
	
	newarray = New Array;
	For i = 0 To Min(count, array.Count()) -1 Do
		newarray.Add(array[i]);
	EndDo;
	
	Return newarray;
	
EndFunction

Function _TrimArray(array, index)
	
	newarray = New Array;
	For i = Min(Max(index, 0), array.Count()) To array.UBound() Do
		newarray.Add(array[i]);
	EndDo;
	
	Return newarray;
	
EndFunction

Function _Array2HMap(array, Val pref = "") Export
	
	map = New Map;
	
	pref = ?(pref = "", StrReplace(String(New UUID), " ", ""), pref);
	
	For n = 0 To array.UBound() Do
		
		map.Insert(StrTemplate("%1_%2", pref, Format(n, "NG=, NZ=0")), array[n]); 
		
	EndDo;
	
	Return map;
	
EndFunction

Function _SArray2SMap(array, field, oneitemstruct = True) Export
	
	map = New Map;
	
	For Each elem In array Do
		
		mkey = elem[field];
		
		If Not oneitemstruct And elem.Count() = 2 Then
			For Each item In elem Do
				If item.Key <> field Then
					value = item.Value;
					Break;
				EndIf;
			EndDo;
		Else
			value = New Structure;
			For Each item In elem Do
				If item.Key = field Then
					Continue;
				EndIf;
				value.Insert(item.Key, item.Value);
			EndDo;
		EndIf;
		
		map.Insert(mkey, value);
		
	EndDo;
	
	Return map;
	
EndFunction

Function _CPYCNTNR(cont) Export
	
	type = TypeOf(cont);
	
	If type = Type("Array") Then
		array = New Array;
		For Each elem In cont Do
			array.Add(_CPYCNTNR(elem));
		EndDo;
		Return array;
	Elsif type = Type("Structure") Or type = Type("Map") Then
		struct = ?(type = Type("Structure"), New Structure, New Map);
		For Each elem In cont Do
			struct.Insert(elem.Key, _CPYCNTNR(elem.Value));
		EndDo;
		Return struct;
	Else
		Return cont;
	EndIf;
	
EndFunction

Function _AddFld2AStruct(array, field, value = undefined) Export
	
	For each elem In array Do
		elem.Insert(field, value);
	EndDo;
	
	Return array;
	
EndFunction

Function _CheckStruct(struct, sdesc) Export
	
	return _ChecStructM(struct, _GetStructMDescFromSDesc(sdesc));
	
EndFunction

Function _ChecStructM(struct, mdesc) Export
		
	For Each desc In mdesc Do
		
		value = Undefined;
		
		If Not struct.Property(desc.Key, value) Then
			return False;
		EndIf;
		
		If desc.Value = Undefined Then
			Continue;
		EndIf;
		
		If TypeOf(value) = Type("Array") Then
			
			For Each elem In value Do
				If Not _ChecStructM(elem, desc.Value) Then
					return False;
				EndIf;		
			EndDo;
			
		ElsIf TypeOf(value) = Type("Structure") Then
			If Not _ChecStructM(value, desc.Value) Then
				return False;
			EndIf;
		Else
			return False;
		EndIf;
		
	EndDo;
		
	return True;
	
EndFunction

Function _GetStructMDescFromSDesc(sdesc)
	
	map = New Map;
	name = "";
	
	levels = New Array;
	clevel = 0;
	
	For i = 1 По StrLen(sdesc) Do
		
		c = Mid(sdesc, i, 1);
		
		If c = "(" Then
			_Inc(clevel);
			If levels.Count() < clevel Then
				levels.Add("");
			EndIf;
			levels[clevel - 1] = name;
			name = "";
		Elsif c = ")" Then
			_AddVal2MapMap(map, _SubArray(levels, clevel), name);
			name = levels[clevel - 1];
			_Dec(clevel);			
		Elsif c = "," Then
			_AddVal2MapMap(map, _SubArray(levels, clevel), name);
			name = "";
		Elsif c = " " Then
			Continue;
		Иначе
			name = name + c;
		EndIf;
		
	EndDo;
	
	return map[""];
	
EndFunction



Function _SplitStrL(str, sep) Export
	
	p = Find(str, sep);
	If p = 0 Then 
		Return _Array10("", str);
	Else
		Return _Array10(Left(str, p - 1), Mid(str, p + StrLen(sep)));
	EndIf;
	
EndFunction

Function _SplitStrR(str, sep) Export
	
	p = Find(str, sep);
	If p = 0 Then 
		Return _Array10(str, "");
	Else
		Return _Array10(Left(str, p - 1), Mid(str, p + StrLen(sep)));
	EndIf;
	
EndFunction



Function _JSONRTM(text) Export
	
	reader = New JSONReader;
	reader.SetString(text);
	
	Try
		Return ReadJSON(reader, True);
	Except
		Return undefined;	
	EndTry;
	
EndFunction


Function _JSONRTS(text) Export
	
	reader = New JSONReader;
	reader.SetString(text);
	
	Try
		Return ReadJSON(reader, False);
	Except
		Return undefined;	
	EndTry;
	
EndFunction

Function _C2JSON(cont) Export
	
	writer = New JSONWriter;
	writer.SetString();
	
	Try
		WriteJSON(writer, cont);
		Return writer.Close();
	Except
		Return undefined;	
	EndTry;
	
EndFunction



Function _ANDA(array) Export
	
	For Each elem In array Do
		If Not elem Then
			Return False;
		EndIf;
	EndDo;
	
	Return True;
	
EndFunction

Function _ORA(array) Export
	
	For Each elem In array Do
		If elem Then
			Return True;
		EndIf;
	EndDo;
	
	Return False;
	
EndFunction