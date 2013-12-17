% initialize matrix:



filename= '/home/hooshuu/Documents/MATLAB/matlab-midi/tests/midi/mainMelodyTenuto.txt';
delimiterIn = ' ';
%headerlinesIn = 1;
mainMelody  =  importdata(filename,delimiterIn);


N = 320;  % num notes
M = zeros(N,6);

%M(:,3) = (60:72)';      % note numbers: one ocatave starting at middle C (60)
%M(:,4) = round(linspace(80,120,N))';  % lets have volume ramp up 80->120

countNode = 1;   
duration=0;
inDuration = 0;   % 0 = false 1= true
totalTimes = 0;
nodeThanNode = 0;
nodeNow = 0;      % 0 = false 1= true
firstNodeTime = 0.5;

for i = 1 : 20 
    for j = 1 : 16 
        
        
        if (mainMelody(i,j) == -2)
            
            inDuration=1;
            duration = duration + 0.5;
            nodeNow=0;

        elseif (mainMelody(i,j) == -1)
                
            inDuration=0;
        
            M(countNode,1) = 1;         % all in track 1
            M(countNode,2) = 1;         % all in channel 1
            M(countNode,5) = totalTimes;  % note on:  notes start every .5 seconds
            M(countNode,6) = M(countNode,5) + firstNodeTime;   % note off: each note has duration .5 seconds
        
            
            totalTimes=totalTimes+duration+firstNodeTime;
            countNode=countNode+1; 
            nodeNow=0;
            duration=0;
        
        elseif(mainMelody(i,j) ~= -2 && mainMelody(i,j) ~= -1)

                if(inDuration==1)
                
                M(countNode,1) = 1;         % all in track 1
                M(countNode,2) = 1;         % all in channel 1
                M(countNode,3) = mainMelody(i,j)+80;     
                M(countNode,4) = 78;
                M(countNode,5) = totalTimes;  % note on:  notes start every .5 seconds
                M(countNode,6) = M(countNode,5) + duration+firstNodeTime;   % note off: each note has duration .5 seconds
               % pause;
                
                end
                
                if(nodeNow == 1)
                
                M(countNode,1) = 1;         % all in track 1
                M(countNode,2) = 1;         % all in channel 1
                M(countNode,3) = mainMelody(i,j)+80;     
                M(countNode,4) = 80;
                M(countNode,5) = totalTimes;  % note on:  notes start every .5 seconds
                M(countNode,6) = M(countNode,5) + firstNodeTime;   % note off: each note has duration .5 seconds
                nodeNow=0;
                
                end
                
           
            totalTimes=totalTimes+duration+firstNodeTime;
            countNode=countNode+1; 
            nodeNow=1;
            duration=0;
            inDuration= 0; 

        end
        
         
    end
    
end
    
        M(countNode,1) = 1;         % all in track 1
        M(countNode,2) = 1;         % all in channel 1
        M(countNode,5) = totalTimes;  % note on:  notes start every .5 seconds
        M(countNode,6) = M(countNode,5) + .5;   % note off: each note has duration .5 seconds



midi_new = matrix2midi(M);
writemidi(midi_new, '/home/hooshuu/Documents/MATLAB/matlab-midi/tests/midi/gaMelody.mid');

%------------------------------------------------------------
