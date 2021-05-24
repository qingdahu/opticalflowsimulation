%% This program is used to simulate regular grids of connect springs with free rotation


%% generate geometry
%[position,connectivity] = generategeometry("kagome",50,50,1);
%[position,connectivity] = generategeometry("triangle",50,50,1);
[position,connectivity] = generategeometry("hexigonal",60,60,1);           
%[position,connectivity] = generaterandom(50,50,1,1.5);                     % not made yet 
%% Intialize spring length and anchored points
mymodel = initializemymodel(position,connectivity,"edges");
%% Test stiffness at a point
[stiffnesses,mymodel2] = amrliketest(0.1, [0,30,45,60,90], 25,25, 20 , mymodel , "linear");
%% display model
%displaymymodel(mymodel,"simple");              
%displaymymodel(mymodel2,"strain");                                         % not sure what it does, just ported over from old code
displaydisplacement(mymodel,mymodel2)
%% change intial length
%changespringlengthrandom();                                                % not made yet 
mymodel2 = photocrosslinkregion(mymodel,"circle",[30 30 5],0.1,0);            % 0.1 contraction means 10 percent.
%mymodel2 = photocrosslinkregion(mymodel,"rectangle",[25 25 2 10]);  
[stiffnesses,mymodel2] = amrliketest(0, [0], 25,25, 200 , mymodel2 , "linear");



%% custom crosslinking
mymodel2 = photocrosslinkregion(mymodel,mymodel,"circle",[30 30 5],0.1,0); 
[~,mymodel2] = amrliketest(0, [0], 25,25, 100 , mymodel2 , "linear");
displaymymodel(mymodel2,"strain"); 
displaydisplacement(mymodel,mymodel2)
for scans = 1:5
    mymodel2 = photocrosslinkregion(mymodel2,mymodel,"circle",[30 30 5],0.2,0.5); 
    [~,mymodel2] = amrliketest(0, [0], 25,25, 100 , mymodel2 , "linear");
    displaymymodel(mymodel2,"strain"); 
    displaydisplacement(mymodel,mymodel2)
end
    
%% save the current model
userinput = input('Enter file name: ' , 's');                               % pick a good name
save(userinput,'mymodel')