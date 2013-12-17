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
countNodePrev = 0;
mainMelodyPrev=0;
duration=0;
inDuration = 0;   % 0 = false 1= true
totalTimes = 0;
nodeNow = 0;      % 0 = false 1= true
firstNodeTime = 0.5;

for i = 1 : 20 
    for j = 1 : 16 
        
        
        if (mainMelody(i,j) == -2)
            
            duration = duration + 0.5;
             
        elseif (mainMelody(i,j) == -1 )
        
            if(countNodePrev~=0)
            M(countNodePrev,1) = 1;         % all in track 1
            M(countNodePrev,2) = 1;         % all in channel 1
            
                if(mainMelodyPrev ~= -1)
                    M(countNodePrev,3) = mainMelodyPrev+80;
                else
                    M(countNodePrev,3) = 0;
                end
            
            M(countNodePrev,4) = 78;
            M(countNodePrev,5) = totalTimes;  % note on:  notes start every .5 seconds
            M(countNodePrev,6) = M(countNodePrev,5) + duration + firstNodeTime;   % note off: each note has duration .5 seconds
            
            totalTimes=totalTimes+duration+firstNodeTime;
            countNode = countNode+1; 
            end
            
            mainMelodyPrev = -1;
            countNodePrev = countNode;
            
            duration = 0;
       
        elseif(mainMelody(i,j) ~= -2 && mainMelody(i,j) ~= -1)
            
            if(countNodePrev~=0)
                        
            M(countNodePrev,1) = 1;         % all in track 1
            M(countNodePrev,2) = 1;         % all in channel 1
            
                if(mainMelodyPrev ~= -1)
                        M(countNodePrev,3) = mainMelodyPrev+80;
                    else
                        M(countNodePrev,3) = 0;    
                end 
                
            M(countNodePrev,4) = 78;
            M(countNodePrev,5) = totalTimes;  % note on:  notes start every .5 seconds    
            M(countNodePrev,6) = M(countNodePrev,5) + duration + firstNodeTime;   % note off: each note has duration .5 seconds  
           
            totalTimes = totalTimes + duration + firstNodeTime;
            countNode = countNode + 1; 
            end
            
            mainMelodyPrev = mainMelody(i,j);
            countNodePrev = countNode;
            
            duration = 0;
            
        end
        
    end
    
end
      
    if(countNodePrev ~= 0)
        M(countNodePrev,1) = 1;         % all in track 1
        M(countNodePrev,2) = 1;         % all in channel 1
        M(countNodePrev,5) = totalTimes;  % note on:  notes start every .5 seconds
        M(countNodePrev,6) = M(countNodePrev,5) + firstNodeTime;   % note off: each note has duration .5 seconds
    end


midi_new = matrix2midi(M);
writemidi(midi_new, '/home/hooshuu/Documents/MATLAB/matlab-midi/tests/midi/gaMelody.mid');

%------------------------------------------------------------
