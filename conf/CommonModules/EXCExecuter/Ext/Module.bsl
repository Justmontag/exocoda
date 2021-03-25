
Function ExecQueue(Queue, Context = Undefined) Export
	
	Context = ?(Context = Undefined, New Map, Context);
	
	Results = New Array;
	
	For Each Action In Queue Do
		
		Results.Add(Eval(StrTemplate("EXCActionsExecuter.ExecAction%1(Action.Action, Action.Params, Context)", ?(Action.Server, "Server", "Client"))));
		
		If Action.Critical And Not Results[Results.UBound] Then
			Break;
		EndIf;
		
	EndDo;
	
	Return Results;		
	
EndFunction

Function ExecAction(Action) Export
	
	Queue = CreateQueue(Action);
	
	If Queue <> Undefined Then
		Return _ANDA(ExecQueue(Queue));	
	Else
		Return False;
	EndIf;
			
EndFunction

Function IsQueueAction(Action)
	Return IsActionWithType(Action, "Queue");	
EndFunction

Function IsTemplateAction(Action)
	Return IsActionWithType(Action, "Template");	
EndFunction

Function IsSimpleAction(Action)
	Return IsActionWithType(Action, "Simple");	
EndFunction

Function IsActionWithType(Action, Type)
	Return TypeOf(Action) = Type("CatalogRef.EXCActions") And Action.Type = SrvCall.GetPredefValue(StrTemplate("Catalogs.EXCActionsType.%1", Type));	
EndFunction

Function CreateQueue(Action) Export
	
	If Not Action.IsFolder And (IsQueueAction(Action) Or IsTemplateAction(Action)) Then
		Return CreateQueueTemplate(Action);
	Else
		Return undefined;
	EndIf;
	
EndFunction

Function CreateQueueTemplate(Action)

	Queue = New Array;
	
	For Each Elem In Action.ActionQueue Do
		
		QAction = New Structure("Critical, Server, Action, Simple, Params", Elem.Critical, Elem.Server, CreateQueue(Elem.Action), False, GetAParams(Elem.Action, Elem.ID));
		
		If QAction.Action = Undefined Then
			QAction.Simple = True;
			QAction.Action = CreateQueueSimple(Elem.Action);
		EndIf;
		
		If QAction.Action = Undefined Then
			Return Undefined;
		EndIf;
		
		Queue.Add(QAction);
		
	EndDo;	
	
	Return Queue;
	
EndFunction

Function CreateQueueSimple(Action)
	
	Return ?(Action.IsFolder Or IsSimpleAction(Action), ?(Action.SimpleName = "", Undefined, Action.SimpleName), Undefined);
	
EndFunction

Function GetAParams(Action, ID)
	
	FParams = Action.ActionParams.FindRows(New Structure("ID", ID));
	
	If Not FParams.Count() Then
		Return Undefined;	
	EndIf;
	
	Params = New Structure;
	
	For Each Param In FParams Do
		Params.Insert(Param.Param, Param.Value);	
	EndDo;
	
	Return Params;     	
	
EndFunction

