function [stiffnesses,mymodel] = amrliketest(mag, angles, x,y, runs , mymodel , springtype)
    
    %find the point closest to x,y
    position = mymodel.position;
    springs = mymodel.springs;
    connectivity = mymodel.connectivity; 
    anchorpoints = mymodel.anchorpoints;
    vectordistance2 = position - [x,y];
    scalerdistance2 = sqrt(vectordistance2(:,1,:).^2 +vectordistance2(:,2,:).^2);
    [~,I] = min(scalerdistance2);
    positionoriginal = position(I,:);
    
    stiffnesses = zeros(size(angles));
    [n ,dim]= size(position);
    counter = 1;
    for angle = angles
    
        dx = mag*cosd(angle);
        dy = mag*sind(angle);
        position(I,:) = position(I,:) + [dx, dy].*0.1;

       figure()
       gplot(connectivity,position)
       axis equal
       hold on
        if springtype == "linear"
            for i = 2:runs        
                [F,G,~] = find(connectivity);
                num = length(F);
                num2 = length(G);
                forcevector_X = spalloc(size(springs,1), size(springs,2), num);
                forcevector_Y = spalloc(size(springs,1), size(springs,2), num2);
                for j = 1:num
                    scalerdistance = sqrt((position(F(j),1) - position(G(j),1))^2 + (position(F(j),2) - position(G(j),2))^2); 
                    forcescaler = (springs(F(j), G(j)) - scalerdistance)/springs(F(j), G(j))/scalerdistance;
                    forcescaler(isnan(forcescaler))=0; 
                    v_X = position(G(j),1) - position(F(j),1);
                    v_Y = position(G(j),2) - position(F(j),2); 
                    forcevector_X(F(j), G(j)) = v_X * forcescaler;
                    forcevector_Y(F(j), G(j)) = v_Y * forcescaler;
                end
%                 scalerdistance = pdist2(position, position);
%                 forcescaler = (springs-scalerdistance)./springs./scalerdistance;
%                 forcescaler(isnan(forcescaler))=0; 
%                 posX = position(:,1);
%                 posY = position(:,2);
%                 v_X = bsxfun(@minus, posX', posX); 
%                 v_Y = bsxfun(@minus, posY', posY); 
%                 forcevector_X = spalloc(size(forcescaler,1), size(forcescaler,2), num);
%                 forcevector_Y = spalloc(size(forcescaler,1), size(forcescaler,2), num);
%                 for j = 1:num
%                     forcevector_X(F(j), G(j)) = v_X(F(j), G(j)) * forcescaler(F(j), G(j));
%                     forcevector_Y(F(j), G(j)) = v_Y(F(j), G(j)) * forcescaler(F(j), G(j));
%                 end
                forcesumX = (sum(full(forcevector_X),1))';
                forcesumY = (sum(full(forcevector_Y),1))';
                forcesum = [forcesumX, forcesumY];
                forcesum(I,:) = forcesum(I,:)+[dx, dy];
                forcesum(anchorpoints,:) = 0;
                [s, ~] = find(forcesum~=0); 
                position(s,:) = position(s,:) + forcesum(s,:).*0.1;
                gplot(connectivity,position)
            end

        elseif springtype == "buckle100"
            for i = 1:runs
                positionmatrix = repmat(mymodel.position,1,1,n);
                connectivitymatrix = permute(repmat(mymodel.connectivity,1,1,dim), [1 3 2]);
                vectordistance = positionmatrix- permute(positionmatrix,[3 2 1]);
                scalerdistance = sqrt(vectordistance(:,1,:).^2 +vectordistance(:,2,:).^2);
                forcescaler =  repmat((mymodel.springs-scalerdistance)./mymodel.springs./scalerdistance,[1,dim,1]);
                forcescaler(isnan(forcescaler))=0;
                forcescaler(forcescaler>0) = 0.01.*forcescaler(forcescaler>0);
                forcevector = vectordistance.*forcescaler.*connectivitymatrix;
                forcesum = sum(forcevector,3);  %positive force are compressive
                forcesum(I,:) = forcesum(I,:)+[dx, dy];
                forcesum(mymodel.anchorpoints,:) = 0;
                mymodel.position = mymodel.position + forcesum.*0.2;      
                %gplot(mymodel.connectivity,mymodel.position)
            end
        

        elseif springtype == "buckle0"
            for i = 1:runs
                positionmatrix = repmat(mymodel.position,1,1,n);
                connectivitymatrix = permute(repmat(mymodel.connectivity,1,1,dim), [1 3 2]);
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


        positionnew = position(I,:);
        stiffness =  (cosd(angle)*(positionnew(1)-positionoriginal(1)) + sind(angle)*(positionnew(2)-positionoriginal(2))) /mag;
        stiffnesses(counter) = stiffness;
        counter = counter + 1; 
    end

 
    
    
end