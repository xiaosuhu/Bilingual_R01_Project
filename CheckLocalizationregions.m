%% Try to plot the channel setup map
% MICHR coord
optodeMNIMRI=[-59	39	-5
-66	6	1
-65	-25	7
-51	-51	9
-64	-31	-32
-49	-59	-28
-53	60	-29
-47	59	4
-64	18	-23
-58	27	14
-69	-13	-19
-62	-7	21
-61	-40	-13
-55	-34	24
-41	-66	-7
-38	-55	20
-52	-49	-47
-38	-69	-39
];

srcMNIMRI=optodeMNIMRI(1:6,:);
detMNIMRI=optodeMNIMRI(7:18,:);

optodeMNIPOR=[-61	34	-7
-67	1	-1
-62	-32	5
-46	-58	6
-65	-31	-29
-48	-61	-23
-53	60	-27
-48	54	4
-63	19	-21
-61	16	13
-68	-15	-17
-62	-19	19
-58	-45	-12
-51	-45	20
-37	-70	-8
-33	-63	18
-56	-46	-39
-37	-71	-34
];

srcMNIPOR=optodeMNIPOR(1:6,:);
detMNIPOR=optodeMNIPOR(7:18,:);


load BilingualSD.mat
displaycolorswitch=6;
ChannelList=SD.MeasList(1:23,1:2);
% optodeMNI=optodeMNI-repmat([10 -5 2],size(optodeMNI,1),1);

Plot3D_channel_setup(optodeMNIMRI,ChannelList,displaycolorswitch);

%% Estimate the CH relevant MNI
srcMNI=srcMNIPOR;
detMNI=detMNIPOR;
for i=1:length(ChannelList)
    CHMNI(i,:)=(srcMNI(ChannelList(i,1),:)+detMNI(ChannelList(i,2),:))/2;
end

%% 
radius=10*ones(23,1);
orig=[96.5 119.5 96.5]; % This is the origin of the MNI space, it is modified and it is very important in my localization system.
[BA_result_sort, Brain_Region_result_sort]=BAfinding_ALLCH_withplot(CHMNI,radius,orig);


%% Try to list the results as a table
nV=90; % 80% of the region were picked
mode='BA'; % mode = BA, or mode = Region

CH_table=CHtabulate(BA_result_sort,nV,mode); % Note input can be BA_result, or Brain_Region_result

writetable(CH_table,'CHmappingR01.xlsx','Sheet','BA');

