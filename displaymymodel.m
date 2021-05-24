function displaymymodel(mymodel,displaytype)

    if displaytype == "simple"
        figure()
        gplot(mymodel.connectivity,mymodel.position)
        axis equal

    elseif displaytype == "strain"                                          % pulled from old code, not sure what its' doing tbh
        figure()
        
        [n ,dim]= size(mymodel.position);
        positionmatrix = repmat(mymodel.position,1,1,n);
        vectordistance = positionmatrix- permute(positionmatrix,[3 2 1]);
        %note that the force on 1 is sum of vectordistance(:,:1)
        scalerdistance = sqrt(vectordistance(:,1,:).^2 +vectordistance(:,2,:).^2);
        [X,Y] =gplot(mymodel.connectivity,mymodel.position);
        forcescaler =  repmat((mymodel.springs-scalerdistance)./mymodel.springs,[1,dim,1]); %this is normalized in the code above, so redo without normalization
        forcescaler(isnan(forcescaler))=0;
        testvector = [1:size(mymodel.position,1)]';
        testmatrix = [testvector,testvector];
        [testX,testY] =gplot(mymodel.connectivity,testmatrix);
        testmaping = reshape(testX,3,[]);
        testmaping = testmaping(1:2,:)';
        %testforce = forcescaler(testmaping(1,:),testmaping(2,:));
        %i can't get matlab to index matrix from 2D matrix so i'll just use a for
        %loop for now
        for i = 1:size(testmaping,1)
            z(i)= forcescaler(testmaping(i,1),1,testmaping(i,2));
        end
        Z= reshape([repmat(z,[2,1]) ; NaN(1,size(testmaping,1))],[],1);
        % z1= permute( connectivitymatrix.*forcescaler ,[1 3 2]); %+connectivitymatrix.*10e-10
        % z2 = z1(any(z1,3));
        % z3 = reshape(repmat(reshape(z2,1,[]),[2,1]),2,[]);
        % z = [z3 ; NaN(1,size(z2,1))];
        % Z = reshape(z, [],1); 
        plot3(X,Y,Z)
        figure()
        patch([X ;nan],[Y ;nan],[zeros(size(Z,1)+1,1)],[Z ;nan],'EdgeColor','interp','FaceColor','none')
        colorbar()
        axis equal
        
        
        
    elseif displaytype == "stress"

        
        
        
        
        
        
    end


end
