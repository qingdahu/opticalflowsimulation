function [stiffnesses,mymodel] = amrliketest(mag, angles, x,y, runs , mymodel , springtype)
    
    %find the node closest to x,y
    vectordistance2 =  mymodel.position - [x,y];
    scalerdistance2 = sqrt(vectordistance2(:,1,:).^2 +vectordistance2(:,2,:).^2);
    [M,I] = min(scalerdistance2);
    positionoriginal = mymodel.position(I,:);
    
    
    stiffnesses = [];
    [n ,dim]= size(mymodel.position);
    
    for angle = angles
    
        dx = mag*cosd(angle);
        dy = mag*sind(angle);

        %figure()
        %gplot(mymodel.connectivity,mymodel.position)
        %hold on

        connectivitymatrix = permute(repmat(mymodel.connectivity,1,1,dim), [1 3 2]);
        if springtype == "linear"
            
            for i = 1:runs
                positionmatrix = repmat(mymodel.position,1,1,n);
                vectordistance = positionmatrix- permute(positionmatrix,[3 2 1]);
                scalerdistance = sqrt(vectordistance(:,1,:).^2 +vectordistance(:,2,:).^2);
                forcescaler =  repmat((mymodel.springs-scalerdistance)./mymodel.springs./scalerdistance,[1,dim,1]);
                forcescaler(isnan(forcescaler))=0;
                forcevector = vectordistance.*forcescaler.*connectivitymatrix;
                forcesum = sum(forcevector,3); 
                forcesum(I,:) = forcesum(I,:)+[dx, dy];
                forcesum(mymodel.anchorpoints,:) = 0;
                mymodel.position = mymodel.position + forcesum.*0.1;      
                %gplot(mymodel.connectivity,mymodel.position)
            end

        elseif springtype == "buckle100"
            for i = 1:runs
                positionmatrix = repmat(mymodel.position,1,1,n);
                vectordistance = positionmatrix- permute(positionmatrix,[3 2 1]);
                scalerdistance = sqrt(vectordistance(:,1,:).^2 +vectordistance(:,2,:).^2);
                forcescaler =  repmat((mymodel.springs-scalerdistance)./mymodel.springs./scalerdistance,[1,dim,1]);
                forcescaler(isnan(forcescaler))=0;
                forcescaler(forcescaler>0) = 0.01.*forcescaler(forcescaler>0); %positive force are compressive
                forcevector = vectordistance.*forcescaler.*connectivitymatrix;
                forcesum = sum(forcevector,3); 
                forcesum(I,:) = forcesum(I,:)+[dx, dy];
                forcesum(mymodel.anchorpoints,:) = 0;
                mymodel.position = mymodel.position + forcesum.*0.2;      
                %gplot(mymodel.connectivity,mymodel.position)
            end
        

        elseif springtype == "buckle0"
            for i = 1:runs
                positionmatrix = repmat(mymodel.position,1,1,n);
                vectordistance = positionmatrix- permute(positionmatrix,[3 2 1]);
                scalerdistance = sqrt(vectordistance(:,1,:).^2 +vectordistance(:,2,:).^2);
                forcescaler =  repmat((mymodel.springs-scalerdistance)./mymodel.springs./scalerdistance,[1,dim,1]);
                forcescaler(isnan(forcescaler))=0;
                forcescaler(forcescaler>0) =0; %positive force are compressive
                forcevector = vectordistance.*forcescaler.*connectivitymatrix;
                forcesum = sum(forcevector,3); 
                forcesum(I,:) = forcesum(I,:)+[dx, dy];
                forcesum(mymodel.anchorpoints,:) = 0;
                mymodel.position = mymodel.position + forcesum.*0.2;      
                %gplot(mymodel.connectivity,mymodel.position)
            end
        else
            
        end


        positionnew = mymodel.position(I,:);
        stiffness =  ( cosd(angle)*abs(positionoriginal(1)-positionnew(1)) + sind(angle)*abs(positionoriginal(2)-positionnew(2))) /mag;
        stiffnesses = [stiffnesses;stiffness] ;
    end

 
    
    
end