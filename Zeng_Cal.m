 	%================================================================
  case 'act time cal'
     UD=get(0,'userdata');
     %     for num = 1: UD.HD.Waveform.axises
     for num = 1: UD.HD.Waveform.axises
     %num = 1;
           if mod(UD.HD.Waveform.Ch(num).Current_ch,2)
              Ch1st=UD.HD.Waveform.Ch(num).Current_ch;
           else
              Ch1st=UD.HD.Waveform.Ch(num).Current_ch-1;
           end
           Diff = abs(Stripchart.Data(Ch1st,UD.HD.Stripchart.Time1:UD.HD.Stripchart.Time2)-Stripchart.Data(Ch1st+1,UD.HD.Stripchart.Time1:UD.HD.Stripchart.Time2));
           Above_Diff=find(Diff>UD.HD.Default.Derv_Thresh );
           if ~isempty(Above_Diff)
              %I am not sure if & or |
              %Above_Volt_Derv=find(Stripchart.Data(Ch1st,Above_Diff)>UD.HD.Default.Volt_Thresh | Stripchart.Data(Ch1st+1,Above_Diff)>UD.HD.Default.Volt_Thresh);
              Above_Volt_Derv=find(Stripchart.Data(Ch1st,Above_Diff)>UD.HD.Default.Volt_Thresh & Stripchart.Data(Ch1st+1,Above_Diff)>UD.HD.Default.Volt_Thresh);
              
              Leng=length(Above_Volt_Derv);
              if Leng>1               
                 %Above_Diff(Above_Volt_Derv)
                 Above_Volt_Derv_Diff=Above_Diff(Above_Volt_Derv(2:Leng))-Above_Diff(Above_Volt_Derv(1:Leng-1));
                 %Set refactory period
                 a='Edge = Above_Volt_Derv_Diff>UD.HD.Default.RefacPeriod';
%                 edges=find(Above_Volt_Derv_Diff>UD.HD.Default.RefacPeriod)
                 edges=find(Above_Volt_Derv_Diff>10);% 10 = a small gap betw island
                 edges=[0;edges;Leng];
                 Last_Act_Time=-UD.HD.Default.RefacPeriod;
                 for i=2:length(edges)
                    point=find(Diff(Above_Diff(Above_Volt_Derv(edges(i-1)+1:edges(i))))==max(Diff(Above_Diff(Above_Volt_Derv(edges(i-1)+1:edges(i))))));
                    if length(point)>1
                       point=point(1);
                    end
                    point=Above_Diff(Above_Volt_Derv(edges(i-1)+point(1)))+UD.HD.Stripchart.Time1;
                    if (point-Last_Act_Time)>=UD.HD.Default.RefacPeriod;
                       Last_Act_Time=point;
                       Y=get(UD.HD.Waveform.Ch(num).Axes,'ylim');
                       axes(UD.HD.Waveform.Ch(num).Axes)
                       text(point,Y(1)+(Y(2)-Y(1))/4,num2str(point))
                    end
                 %Set refactory period
                 %edges=find(Above_Volt_Derv_Diff>UD.HD.Default.RefacPeriod);
                 %edges=[0;edges;Leng];
                 %for i=2:length(edges)
                 %   point=find(Diff(Above_Diff(Above_Volt_Derv(edges(i-1)+1:edges(i))))==max(Diff(Above_Diff(Above_Volt_Derv(edges(i-1)+1:edges(i))))));
                 %   if length(point)>1
                 %      point=point(1);
                 %   end
                 %   point=Above_Diff(Above_Volt_Derv(edges(i-1)+point(1)))+UD.HD.Stripchart.Time1;
                 %   Y=get(UD.HD.Waveform.Ch(num).Axes,'ylim');
                 %   axes(UD.HD.Waveform.Ch(num).Axes)
                 %   text(point,Y(1)+(Y(2)-Y(1))/4,num2str(point))
                 %end
              end

           end
        end
     end; %for num = 1: UD.HD.Waveform.axises
      
   %================================================================
   case 'act time set'
      UD.HD.Default.Figure
      figure(UD.HD.Default.Figure);
      set(UD.HD.Default.Figure,'Units','points', ...
         'Units','pixels',...
         'Color',[0.8 0.8 0.8], ...
         'MenuBar','none', ...
         'Name','Default values setting',...
         'NumberTitle','off',...
         'Position',UD.Ref.Position(UD.HD.Default.Figure,:), ...
         'Tag','Figure');
      
      uicontrol('Parent',UD.HD.Default.Figure, ...
         'Units','normalized', ...
         'BackgroundColor',[0.8 0.8 0.8], ...
         'HorizontalAlignment','right', ...
         'Position',[0.01 0.691318 0.2 0.08], ...
         'String','Volt Threshold:', ...
         'Style','text', ...
         'Tag','StaticText1');
      uicontrol('Parent',UD.HD.Default.Figure, ...
         'Units','normalized', ...
         'BackgroundColor',[0.8 0.8 0.8], ...
         'HorizontalAlignment','right', ...
         'Position',[0.01 0.565916 0.2 0.08], ...
         'String','Derv Threshold:', ...
         'Style','text');
      uicontrol('Parent',UD.HD.Default.Figure, ...
         'Units','normalized', ...
         'BackgroundColor',[0.8 0.8 0.8], ...
         'HorizontalAlignment','right', ...
         'Position',[0.01 0.425916 0.2 0.08], ...
         'String','R F P:', ...
         'Style','text');
      
   
      
      UD.HD.Default.Edit.Volt_Thresh = uicontrol('Parent',UD.HD.Default.Figure, ...
         'Units','normalized', ...
         'BackgroundColor',[1 1 1], ...
         'HorizontalAlignment','left', ...
         'Position',[0.25 0.691318 0.15 0.08], ...
         'Style','edit', ...
         'string',UD.HD.Default.Volt_Thresh);
      UD.HD.Default.Edit.Derv_Thresh = uicontrol('Parent',UD.HD.Default.Figure, ...
         'Units','normalized', ...
         'BackgroundColor',[1 1 1], ...
         'HorizontalAlignment','left', ...
         'Position',[0.25 0.565916 0.15 0.08], ...
         'Style','edit', ...
         'string',UD.HD.Default.Derv_Thresh);
      UD.HD.Default.Edit.RefacPeriod = uicontrol('Parent',UD.HD.Default.Figure, ...
         'Units','normalized', ...
         'BackgroundColor',[1 1 1], ...
         'HorizontalAlignment','left', ...
         'Position',[0.25 0.421916 0.15 0.08], ...
         'Style','edit', ...
         'string',UD.HD.Default.RefacPeriod);
      
   
      uicontrol('Parent',UD.HD.Default.Figure, ...
         'Units','normalized', ...
         'Position',[0.14 0.0192926 0.163895 0.0836013], ...
         'String','OK', ...
         'Tag','OK',...
         'callback',[...
            'UD=get(0,''userdata'');',...
            'Volt_Thresh=str2num(get(UD.HD.Default.Edit.Volt_Thresh,''string''));',...
            'Derv_Thresh=str2num(get(UD.HD.Default.Edit.Derv_Thresh,''string''));',...
            'RefacPeriod=str2num(get(UD.HD.Default.Edit.RefacPeriod,''string''));',...
            'if ~isempty(Volt_Thresh) & ~isempty(Derv_Thresh) & ~isempty(RefacPeriod)',...
            '    UD.HD.Default.Volt_Thresh=Volt_Thresh;',...
            '    UD.HD.Default.Derv_Thresh=Derv_Thresh;',...
            '    UD.HD.Default.RefacPeriod=RefacPeriod;',...
            '    set(0,''userdata'',UD);',...
            '    close(UD.HD.Default.Figure);',...
            'else;',...
            '    Zeng(''Error'',''Why did not you add a number ?'');',...
            'end;']);
      uicontrol('Parent',UD.HD.Default.Figure, ...
         'Units','normalized', ...
         'Position',[0.42 0.0257235 0.16152 0.0803859], ...
         'String','Default', ...
         'Tag','Cancel',...
         'callback',[...
            'UD=get(0,''userdata'');',...
            'set(UD.HD.Default.Edit.Volt_Thresh,''string'',UD.Default.Volt_Thresh);',...
            'set(UD.HD.Default.Edit.RefacPeriod,''string'',UD.Default.RefacPeriod);',...
            'set(UD.HD.Default.Edit.Derv_Thresh,''string'',UD.Default.Derv_Thresh);']);
      
      uicontrol('Parent',UD.HD.Default.Figure, ...
         'Units','normalized', ...
         'Position',[0.70 0.0257235 0.16152 0.0803859], ...
         'String','Cancel', ...
         'Tag','Cancel',...
         'callback',[...
            'UD=get(0,''userdata'');',...
            'close(UD.HD.Default.Figure);']);
   set(0,'userdata',UD);
