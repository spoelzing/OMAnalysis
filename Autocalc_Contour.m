function [varargout]=Autocalc_Contour(varargin)
action = varargin{1};
global Log Contour Autocalc Stripchart Steve
switch action
    %     %================================================================
    %     case 'Initial'
    %         Autocalc.Applied=0;
    %         %FG_Size=[1 35 Log.UD.HD.LUTDisplay.FG_Limit];
    %         %    Contour=get(gcbf,'userdata');
    %         Stripchart=get(Contour.Parent,'userdata');
    %         FG_Size=[830 130 300 300];
    %         Autocalc.Figure=figure;
    %         Autocalc.Parent=Autocalc.Figure;
    %         set(Autocalc.Figure,'Units','pixels', ...
    %             'Color',Contour.Color,...%     'HandleVisibility','off',...
    %             'DeleteFcn','Zeng_Contour(''DeleteFcn'');',...
    %             'menu','none',...
    %             'Name',[Stripchart.Head.FileName ':Auto Vector Calc'],...
    %             'NumberTitle','off',...
    %             'unit','pixel',...
    %             'PaperPositionMode','auto',...If you make it auto, pagedlg won't work
    %             'Position',FG_Size, ...
    %             'selected','on',...
    %             'Tag','Contour',...
    %             'visible','off');
    %         %Contour.AxesSz=[5 180 FG_Size(3)-10 FG_Size(4)-200];
    %         Contour.Xlim=[min(Contour.Ch_XY(:,2))-.5 max(Contour.Ch_XY(:,2))+.5];
    %         Contour.Ylim=[min(Contour.Ch_XY(:,3))-.5 max(Contour.Ch_XY(:,3))+.5];
    %         Contour.YDir=-1;
    %         %set(Contour.Axes,'xlim',[min(Contour.Ch_XY(:,2))-.5 max(Contour.Ch_XY(:,2))+.5],'ylim',[min(Contour.Ch_XY(:,3))-.5 max(Contour.Ch_XY(:,3))+.5]);
    %
    %         %Main-----------------------------
    %         Autocalc.Text.Tmin = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',[0.8 0.8 0.8], ...
    %             'enable','on',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[10 260 65 15], ...
    %             'String','Arc Size', ...
    %             'Style','text', ...
    %             'Tag','Time Type');
    %
    %         Autocalc.Text.Tmax = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',[0.8 0.8 0.8], ...
    %             'enable','on',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[10 235 65 15], ...
    %             'String','Primary Angle', ...
    %             'Style','text', ...
    %             'Tag','Time Type');
    %
    %         Autocalc.Edit.Angle = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',[1 1 1], ...
    %             'enable','on',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[80 235 40 20], ...
    %             'string',0,...
    %             'Style','edit', ...
    %             'Tag','Time Type',...
    %             'callback','Autocalc_Contour(''Change'')');
    %
    %         Autocalc.Edit.Arc = uicontrol('Parent',Autocalc.Figure, ...
    %             'Units','pixel',...
    %             'enable','on',...
    %             'BackgroundColor',[1 1 1], ...
    %             'ListboxTop',0, ...
    %             'Position',[80 260 40 20], ...
    %             'string',15,...
    %             'Style','edit', ...
    %             'Tag','Time Type',...
    %             'callback','Autocalc_Contour(''Change'')');
    %         %
    %         Autocalc.Text.Stepangle = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',[0.8 0.8 0.8], ...
    %             'enable','on',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[150 245 65 15], ...
    %             'String','Step Angle', ...
    %             'Style','text', ...
    %             'Tag','Time Type');
    %         %
    %         Autocalc.Edit.Stepangle = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',[1 1 1], ...
    %             'enable','on',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[220 245 40 20], ...
    %             'string',20,...
    %             'Style','edit', ...
    %             'Tag','Time Type',...
    %             'callback','Autocalc_Contour(''Change'')');
    %
    %         boxcolor=[0.92 0.92 0.92];
    %
    %         %-----------------------------
    %         %Vector
    %         Autocalc.Text.AverageL = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',Contour.Color, ...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[130 140 50 15], ...
    %             'String','Members', ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.MembersM = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',boxcolor, ...
    %             'enable','on',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[135 120 40 15], ...
    %             'String',0, ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.AverageL = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',Contour.Color, ...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[10 200 50 15], ...
    %             'String','Magnitude', ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.AverageL = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',[0.8 0.8 0.8], ...
    %             'enable','on',...
    %             'HorizontalAlignment','left',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[10 180 40 15], ...
    %             'String','Mean', ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.AverageM = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',boxcolor, ...
    %             'enable','on',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[60 180 40 15], ...
    %             'String',0, ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.MedianL = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',[0.8 0.8 0.8], ...
    %             'enable','on',...
    %             'HorizontalAlignment','left',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[10 160 40 15], ...
    %             'String','Median', ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.MedianM = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',boxcolor, ...
    %             'enable','on',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[60 160 40 15], ...
    %             'String',0, ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.STDL = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',[0.8 0.8 0.8], ...
    %             'enable','on',...
    %             'HorizontalAlignment','left',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[10 140 40 15], ...
    %             'String','STDV', ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.STDM = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',boxcolor, ...
    %             'enable','on',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[60 140 40 15], ...
    %             'String',0, ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %
    %
    %         Autocalc.Text.AverageL = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',Contour.Color, ...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[10 110 50 15], ...
    %             'String','Angle', ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.AverageL = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',[0.8 0.8 0.8], ...
    %             'enable','on',...
    %             'HorizontalAlignment','left',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[10 90 40 15], ...
    %             'String','Mean', ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.AverageA = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',boxcolor, ...
    %             'enable','on',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[60 90 40 15], ...
    %             'String',0, ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.MedianL = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',[0.8 0.8 0.8], ...
    %             'enable','on',...
    %             'HorizontalAlignment','left',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[10 70 40 15], ...
    %             'String','Median', ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.MedianA = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',boxcolor, ...
    %             'enable','on',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[60 70 40 15], ...
    %             'String',0, ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.STDL = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',[0.8 0.8 0.8], ...
    %             'enable','on',...
    %             'HorizontalAlignment','left',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[10 50 40 15], ...
    %             'String','STDV', ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %         Autocalc.Text.STDA = uicontrol('Parent',Autocalc.Figure, ...
    %             'BackgroundColor',boxcolor, ...
    %             'enable','on',...
    %             'ListboxTop',0, ...
    %             'Units','pixel',...
    %             'Position',[60 50 40 15], ...
    %             'String',0, ...
    %             'Style','text', ...
    %             'Tag','Vector Type');
    %
    %
    %
    %         Autocalc.Button.Apply = uicontrol('Parent',Autocalc.Figure,...
    %             'ListboxTop',0, ...
    %             'enable','on',...
    %             'Units','pixel',...
    %             'Position',[10 10 60 20], ...
    %             'String','Apply', ...
    %             'tag','Button Apply',...
    %             'callback','Autocalc_Contour(''Apply'')');
    %         Autocalc.Button.Graph = uicontrol('Parent',Autocalc.Figure,...
    %             'ListboxTop',0, ...
    %             'enable','on',...
    %             'Units','pixel',...
    %             'Position',[100 10 70 20], ...
    %             'String','All Angles', ...
    %             'tag','Button Apply',...
    %             'callback','Autocalc_Contour(''All Angles'')');
    %
    %         set(Autocalc.Figure,'userdata',Contour);
    %         set(Autocalc.Figure,'visible','on');
    %         Zeng_Contour('Setting','ClrMap','Jet');
    %         set(Autocalc.Figure,'ResizeFcn','Zeng_Contour(''ResizeFcn'')');
    %         %-------------------------
    %         %To plot image


    case 'Change'
        set(Autocalc.Button.Apply,'Enable','on');


    case 'Apply'
        warning off

        troubleshoot=0; % Set to 1 to see all vectors assigned in real time
        if troubleshoot==1
            figure(Contour.Figure)
        end
        if Autocalc.Applied==0;
            Autocalc.Applied=1;
            point=0;
            count=1;
            Autocalc.Member.Distance=0*ones(1,length(Contour.Vector.Y));
            Autocalc.Member.Angle=0*ones(1,length(Contour.Vector.Y));
            Contour.Base.Distance=sqrt(Contour.Vector.Y.^2+Contour.Vector.X.^2);
            Contour.Base.Angle=atan2(Contour.Vector.Y,Contour.Vector.X);
            Contour.Vector.Magnitude=sqrt((Contour.Vector.X-Contour.Vector.Vx).^2+(Contour.Vector.Y-Contour.Vector.Vy).^2);
            Contour.Vector.Angle=(atan2(-Contour.Vector.Vy,Contour.Vector.Vx));

            Autocalc.lowangle=(Autocalc.Angle-Autocalc.Arc)*pi/180;
            Autocalc.highangle=(Autocalc.Angle+Autocalc.Arc)*pi/180;

            V=[Contour.Vector.X Contour.Vector.Y];
            for index=1:length(Contour.Vector.Y)
                if Contour.Vector.Angle(index)<0
                    Contour.Vector.Angle(index)=2*pi+Contour.Vector.Angle(index);
                end
                e=Contour.Vector.Angle(index);
                a=Autocalc.lowangle;
                b=Autocalc.highangle;
                f=Autocalc.StimSite(Contour.Vector.Y(index),Contour.Vector.X(index));
                if b>(2*pi)  &&  e<=(b-2*pi) && e>=(a-2*pi) && f==1;
                    Temp.currentpoint=[Contour.Vector.X(index) Contour.Vector.Y(index)];
                    Temp.Ch=find(V(:,1)==Temp.currentpoint(1) &  V(:,2)==Temp.currentpoint(2));
                    if troubleshoot==1
                        Autocalc_Contour('Zeng',Temp)
                    end
                    point=1;
                elseif  b>(2*pi)  &&  (e<=b && e>=a) && f==1;
                    Temp.currentpoint=[Contour.Vector.X(index) Contour.Vector.Y(index)];
                    Temp.Ch=find(V(:,1)==Temp.currentpoint(1) &  V(:,2)==Temp.currentpoint(2));
                    if troubleshoot==1
                        Autocalc_Contour('Zeng',Temp)
                    end
                    point=1;
                elseif a<0 && e<=(b+2*pi) && e>=(a+2*pi) && f==1;
                    Temp.currentpoint=[Contour.Vector.X(index) Contour.Vector.Y(index)];
                    Temp.Ch=find(V(:,1)==Temp.currentpoint(1) &  V(:,2)==Temp.currentpoint(2));
                    if troubleshoot==1
                        Autocalc_Contour('Zeng',Temp)
                    end
                    point=1;
                elseif (e>=a && e<=b) && f==1
                    Temp.currentpoint=[Contour.Vector.X(index) Contour.Vector.Y(index)];
                    Temp.Ch=find(V(:,1)==Temp.currentpoint(1) &  V(:,2)==Temp.currentpoint(2));
                    if troubleshoot==1
                        Autocalc_Contour('Zeng',Temp)
                    end
                    point=1;
                end
                if point==1
                    Autocalc.Member.Distance(index)=Contour.Base.Distance(index);
                    Autocalc.Member.Angle(index)=Contour.Base.Angle(index);
                    count=count+1;
                    point=0;
                end
            end
            count1=count;
            I=find(Autocalc.Member.Distance~=0);
            Autocalc.Member.Distance2=Autocalc.Member.Distance(I);
            I=find(Autocalc.Member.Angle~=0);
            Autocalc.Member.Angle2=Autocalc.Member.Angle(I);
            %set(Autocalc.Button.Apply,'Enable','off');
            Autocalc.MeanM=mean(Autocalc.Member.Distance2);
            Autocalc.STDM=std(Autocalc.Member.Distance2);
            Autocalc.MedianM=median(Autocalc.Member.Distance2);
            Autocalc.MeanA=mean(Autocalc.Member.Angle2);
            Autocalc.STDA=std(Autocalc.Member.Angle2);
            Autocalc.MedianA=median(Autocalc.Member.Angle2);
            Std_Step=100;


            a=(Autocalc.MeanM+Std_Step*Autocalc.STDM);
            b=(Autocalc.MeanM-Std_Step*Autocalc.STDM);
            c=Autocalc.MeanA+10*Autocalc.STDA;
            d=Autocalc.MeanA-10*Autocalc.STDA;


            for index=1:length(Contour.Vector.Y)
                % if index<=count1
                e=Autocalc.Member.Distance(index);
                f=Autocalc.Member.Angle(index);
                if (e>a || e<b || f>c || f<d) && Autocalc.Member.Distance(index)>0;
                    Temp.currentpoint=[Contour.Vector.X(index) Contour.Vector.Y(index)];
                    Temp.Ch=find(V(:,1)==Temp.currentpoint(1) &  V(:,2)==Temp.currentpoint(2));
                    if troubleshoot==1
                        figure(Contour.Figure)
                        delete(findobj(Contour.Axes,'type','patch','tag',num2str(Contour.Ch_XY(Temp.Ch,1))))
                    end
                    count=count-1;
                    Autocalc.Member.Distance(index)=1000;
                    Autocalc.Member.Angle(index)=1000;
                end
                %   end
            end

            I=find(Autocalc.Member.Distance<999 & Autocalc.Member.Distance>0);
            Autocalc.Member.Distance2=Autocalc.Member.Distance(I);
            Autocalc.Member.Magnitude=Contour.Vector.V(I);
            Autocalc.Member.Theta=Contour.Vector.Angle(I)*180/pi;
            I=find(Autocalc.Member.Angle<999 & Autocalc.Member.Distance>0);
            Autocalc.Member.Angle2=180/pi*Autocalc.Member.Angle(I);


        else
            V=[Contour.Vector.X Contour.Vector.Y];
            for index=1:length(Contour.Vector.Y)
                Temp.currentpoint=[Contour.Vector.X(index) Contour.Vector.Y(index)];
                Temp.Ch=find(V(:,1)==Temp.currentpoint(1) &  V(:,2)==Temp.currentpoint(2));
                if troubleshoot==1
                    figure(Contour.Figure)
                    delete(findobj(Contour.Axes,'type','patch','tag',num2str(Contour.Ch_XY(Temp.Ch,1))))
                end
            end
            Autocalc.Applied=0;
            Autocalc_Contour('Apply');
        end




    case 'All Angles'
        clc
        Autocalc.Applied=0;
        h=waitbar(0,'Calculating All Angles. Please Wait');
        counter=1;
        stepsize = str2num(get(Steve.Edit.AngleStep, 'String'));
        if stepsize == 0
            stepsize = 20;
        end
        Autocalc.Arc=str2num(get(Steve.Edit.Angle,'String'));
        for angle=0:stepsize:360
            waitbar(angle/360,h)
            Contour.Vector.CM=zeros(floor(Contour.Ylim(2)),floor(Contour.Xlim(2)));
            Autocalc.Angle=angle;
            Autocalc_Contour('Apply');
            membercount(counter)=length(Autocalc.Member.Magnitude);
            meanmag(counter)=mean(Autocalc.Member.Magnitude);
            medmag(counter)=median(Autocalc.Member.Magnitude);
            stdmag(counter)=std(Autocalc.Member.Magnitude);
            if meanmag(counter)>100000
                meanmag(counter)=0;
            end
            counter=counter+1;
        end
        close(h)
        if get(Steve.CheckBox.Polar,'value')==1
            Autocalc.Figure2=figure;
            figure(Autocalc.Figure2)
            polar(pi/180*[0:stepsize:360],meanmag);

            %             set(gcf,'Position', [100 100 1500 800])
            %             h=([0:stepsize:360])';
            %             new(:,1)=h;
            %             new(:,2)=meanmag;
            %             new(:,3)=medmag;
            %             new(:,4)=stdmag;
            %             gtext({num2str(new)})
        end

        TheAngles=[0:stepsize:360];
        [vcv1 icv1]=min(meanmag(find(TheAngles<180))); % Calculates CVT-Up
        [vcv4_1, icv4_1]=max(meanmag(find(TheAngles<180))); % Calculates CVT-Up
        if membercount(icv1)<6
            warndlg(['WARNING. CVT_Up may be unreliable. Too few points or heart tilted. ',num2str(membercount(icv1(1))),' vectors found. Contact Steve Poelzing']) % Calculates CVT-Down
        end

        if TheAngles(icv1(1))<180 && membercount(icv1(1))>5
            [vcv2 ind]=max(meanmag(find(TheAngles>TheAngles(icv1(1)) & TheAngles<TheAngles(icv1(1))+160))); % Calculates CVL-Left
            icv2=find(meanmag==vcv2);
        else
            [vcv2 icv2]=max(meanmag(find(TheAngles>TheAngles(icv1(1)) & TheAngles<TheAngles(icv1(1))+160))); % Calculates CVL-Left
            warndlg(['WARNING. CVL_Left may be unreliable. Too few points or heart tilted. ',num2str(membercount(icv2(1))),' vectors found. Contact Steve Poelzing']) % Calculates CVT-Down
            icv2=find(meanmag==vcv2);
        end

        if (TheAngles(icv2(1)))<300 && membercount(icv2(1))>5
            [vcv3 icv3]=min(meanmag(find(TheAngles>(TheAngles(icv2(1))) & TheAngles<TheAngles(end))));
            icv3=find(meanmag==vcv3);
        else
            [vcv3 icv3]=min(meanmag(find(TheAngles>(TheAngles(icv2(1))) & TheAngles<TheAngles(end))));
            icv3=find(meanmag==vcv3);
            warndlg(['WARNING. CVT_Down may be unreliable. Too few points or heart tilted. Only ',num2str(membercount(icv3(1))),' vectors found. Contact Steve Poelzing']) % Calculates CVT-Down
        end

        if TheAngles(icv3(1))<360 && membercount(icv3)>5
            [vcv4 ind]=max(meanmag(find(TheAngles>TheAngles(icv3(1)) & TheAngles<TheAngles(end)))); % Calculates CVL-Right
            icv4=find(meanmag==vcv4);
        else
            [vcv4 ind]=max(meanmag(find(TheAngles>TheAngles(icv3(1)) & TheAngles<TheAngles(end)))); % Calculates CVL-Right
            icv4=find(meanmag==vcv4);
            warndlg(['WARNING. CVL_Right may be unreliable. Too few points or heart tilted. ',num2str(membercount(icv4(1))),' vectors found. Contact Steve Poelzing']) % Calculates CVT-Down
        end

        if vcv4<vcv4_1 && membercount(icv4(1))>5
            vcv4=vcv4_1;
            icv4=icv4_1;
        elseif vcv4<vcv4_1 && membercount(icv4(1))<6
            vcv4=vcv4_1
            icv4=icv4_1;
            warndlg(['WARNING. CVT_Down may be unreliable. Too few points or heart tilted. ',num2str(membercount(icv4(1))),' vectors found. Contact Steve Poelzing']) % Calculates CVT-Down
        end
        if get(Steve.CheckBox.Polar,'value')==1
            magvecs=[TheAngles' meanmag' membercount']
        end
        CVT_Up=vcv1;
        CVT_Down=vcv3;
        disp('CVT_Up  CVT_Down  and Avg CVT')
        [CVT_Up CVT_Down  (CVT_Up+CVT_Down)/2]
        CVL_Left=vcv2;
        CVL_Right=vcv4;

        disp('CVL_Lft  CVT_Rght  and Avg CVL')
        [CVL_Left CVL_Right  (CVL_Left+CVL_Right)/2]

        close(Steve.Figure)



    case 'Zeng'
        Temp=varargin{2};
        Contour.Vector.CM(Temp.currentpoint(2),Temp.currentpoint(1))=1;
        Zeng_Contour('Marker',Contour.Figure,Contour.Ch_XY(Temp.Ch,1),Temp.currentpoint);
        %Zeng_Contour('Vector Label',Contour.Figure)
end


