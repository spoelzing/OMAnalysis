% THIS FILE CAN BE DELETED ONCE I'M GONE
% THANKS, STEVEN POELZING

z=[ 5.4054	0.96154	2.2642	1.5504	1.848	1.4516	0	1.1111	0.98361	1.4577	1.118	0.3413	1.3436	1.2136	2.0833	3.4351
2.6954	0.78895	1.0753	2.5424	1.8735	1.9068	1.222	1.2	1.9194	0	1.4675	1.6667	2.4943	0	2.8754	2.8926
2.0833	2.2801	2.1875	1.2755	3.0162	1.5284	2.714	1.4768	1.9139	2.3474	0.53981	2.3364	2.5189	1.7241	2.8754	3.4091
3.3457	3.0928	2.005	2.714	1.3333	2.686	1.3645	1.1601	2.5641	2.9954	1.1186	3.2823	1.7621	0.6865	1.7995	1.2862
1.3333	3.6304	2.457	0.79208	0.6012	1.8727	1.8248	1.6949	1.4436	0.83449	0.46674	0.56711	0.39063	0.64795	0.62893	0.978
2	1.8519	2.0305	2.7957	1.8975	1.7544	3.0395	2.6667	2.0576	1.294	0.4561	-0.07278	0.50302	0.70994	0.47244	0.49917
2.5271	1.8325	0.75676	0.36496	2.1583	3.2496	2.5921	2.8649	4.75	2.2036	2.3416	1.669	0.18975	0.5787	1.2097	1.0381
1.5625	1.5432	1.4957	2.3636	3.5294	1.9826	1.8349	1.0211	3.1375	4.3764	2.5094	1.7026	1.1962	0.95465	0.85929	1.0145
1.0163	2.71		1.9608	2.1959	2.276	2.356	3.9631	5.0134	4.7315	6.1404	3.0963	0.54615	0.50556	1.0163	0.41929	1.1089
1.1538	1.9391	1.8868	1.1765	1.1983	2.5381	3.5294	5.5696	7.8571	5.5164	2.0772	0.46698	0.28531	0.70211	1.1161	1.4493
4.7809	1.847		1.4344	1.48		1.5314	1.9584	3.0726	3.567	2.1858	2.0503	1.6241	1.0078	1.1567	0.29608	0.5168	1.0733
3.0837	2.0772	1.766		1.1804	1.5699	1.273	1.4908	0.82645	1.4535	1.0296	0.80049	1.4684	0.72993	0.72841	0.51326	0.83135
2.9167	2.3649	1.3129	1.626	1.1725	2.144	1.374	1.6432	0.7329	1.7857	1.4815	1.227	0.23529	0.082169	1.6794	1.2939
6.383	6.1765	3.6585	2.8504	0.90416	0.31153	0.63425	1.0753	0.4603	0.64378	0.61783	0.86207	0.57803	1.2535	0.93604	1.2552
7.483	6.6038	2.7237	1.6349	1.5504	0.53381	1.5358	0.49875	1.4925	1.1058	1.2941	0.80092	2.1277	1.9417	0.40486	1.2755
7.6923	3.871	3.3493	3.0055	3.125	3.0303	2.1875	1.6026	1.2158	1.0499	0.74627	2.1277	0.46296	1.1962	0.76531	1.8727
];
%z1=z;
z(:,1)=0;
z(:,16)=0;
z(1:5,:)=0;
z(14:16,:)=0;
z(8,8)=4;
z(9,12)=2.6;
z(10,12)=2.4;
z(9,13)=2.3;
z(10,13)=2.1;
z(9,14)=2.0;
z(10,14)=1.6;
z(13,2)=0;
z(13,3)=0;
z1=conv2(z,1/3*ones(1,3),'same');
[x1,y1]=size(z);
[X Y]=meshgrid(1:y1,1:x1);
[xi,yi]=meshgrid(1:(1/10):y1,1:(1/10):x1);
zi = interp2(X,Y,z1,xi,yi); 
%zi=z;
close all
%figure(5)
%surf(X,Y,z1)
sss=find(zi<3);
zi(find(zi>6.0))=6.0;
%[xx yy]=size(zi);
%zi(1,yy)=2.5;

figure(3)
imagesc(z)
figure(1)
contourf(flipud(zi),5)
axis off
colormap(1-gray)
colorbar




%figure(2)
%imagesc(zi)
%imagesc(((zi(3:end-2,4:end-3))))
