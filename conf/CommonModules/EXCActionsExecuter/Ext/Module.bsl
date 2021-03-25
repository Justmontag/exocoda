
&Client
Function ExecActionClient(Action, Params = Undefined, Context = Undefined) Export
	Return ExecAction(Action, Params, Context);	
EndFunction

&Server
Function ExecActionServer(Action, Params = Undefined, Context = Undefined) Export
	Return ExecAction(Action, Params, Context);
EndFunction

Function ExecAction(Action, Params = Undefined, Context = Undefined) Export
	
	If Action.Simple Then
		
		Return ExecSimpleAction(Action, Params, Context);
		
	Else
		
		Context = ?(Context = Undefined, New Map, Context);
		
		Context.Insert("_params", Params);
		
		Return _ANDA(EXCExecuter.ExecQueue(Action, Context));
		
	EndIf;
	
EndFunction

Function ExecSimpleAction(Action, Params = Undefined, Context = Undefined) Export
	
	Try
		Return Eval(StrTemplate("%1(FillParams(Params, Context), Context)", Action));
	Except
		Return False;
	EndTry;
	
EndFunction

Function FillParams(Params, Context)
	
	If Params <> Undefined Then
		Return Params;
	EndIf;
	
	For Each Param In Params Do
		
		If TypeOf(Param.Value) <> Type("String") Then
			Continue;
		EndIf;
		
		PName = Lower(Mid(Param.Value, 2));
		
		If Left(Param.Value, 1) = "@" Then
			//Context
			Param.Value = Context.Get(PName);
		ElsIf Left(Param, 1) = "#" Then
			//Parent
			PParams = Context.Get("_params");
			If PParams = Undefined Or Not PParams.Property(PName, Param.Value) Then
				Param.Value = Undefined;
			EndIf;
			
		EndIf;
		
	EndDo;
	
	Return Params;
	
EndFunction

#Region SimpleActionsExecuters

Функция ВыполнитьSQLЗапрос(Параметры, Контекст)
	
	Возврат SQL.ВыполнитьЗапрос(Новый Структура("Сервер", Параметры.Сервер), Параметры.ТекстЗапроса);
	
КонецФункции

Функция СтрокаШаблон(Параметры, Контекст)
	
	Контекст.Вставить("_result", СтрЗаменить(Параметры.Строка, Параметры.Шаблон, Параметры.Значение));
	
	Возврат Истина;
	
КонецФункции

#EndRegion