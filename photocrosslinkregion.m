function mymodel = photocrosslinkregion(mymodel, mymodeloriginal,shape, parameters,contraction,multi)

    if shape == "circle"
        
        
        % find points inside region
        vectordistance2 =  mymodel.position - [parameters(1),parameters(2)];
        scalerdistance2 = sqrt(vectordistance2(:,1,:).^2 +vectordistance2(:,2,:).^2);
        insidenodes = scalerdistance2 < parameters(3);
        insidenodes= insidenodes*insidenodes';
        
        if multi ==0
            shrinkage = ones(size(insidenodes)) - insidenodes .* contraction;
            
        else

            shrinkage = (ones(size(insidenodes)) - insidenodes .* contraction ).* mymodel.crosslink;
            shrinkage(shrinkage<multi) = multi;    %i think this line might be causing problems. but the code runs so slow, I can't check it.
        end 
        mymodel.springs = mymodeloriginal.springs .* permute(shrinkage,[1 3 2]);
        mymodel.crosslink = shrinkage ;
        % make the springs inside that region smaller
        
        
        
        
        
        
        
    elseif shape == "rectangle"
        % find points inside region
        % make the springs inside that region smaller
        
        
        
    end

end