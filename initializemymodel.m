function mymodel = initializemymodel(position,connectivity,anchortype)

    if anchortype == "firstlast" 
        anchorpoints = [1,length(position)];
    elseif anchortype == "topbottop" 
        anchorpoints =  [find(position(:,2)==min(position(:,2))) ; find(position(:,2)==max(position(:,2)))];
    elseif anchortype == "edges"     
        anchorpoints =  unique([find(position(:,1)==min(position(:,1)));find(position(:,1)==max(position(:,1)));find(position(:,2)==min(position(:,2))) ; find(position(:,2)==max(position(:,2)))]);
    else 
    end
    
    [n ,dim]= size(position);
    positionmatrix = repmat(position,1,1,n);
    vectordistance = positionmatrix- permute(positionmatrix,[3 2 1]);
    springs = sqrt(vectordistance(:,1,:).^2 +vectordistance(:,2,:).^2);


    mymodel = struct;
    mymodel.position = position;
    mymodel.connectivity = connectivity;
    mymodel.springs = springs;
    mymodel.anchorpoints = anchorpoints;
end