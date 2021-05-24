function [position,connectivity] = generategeometry(type,sizex,sizey,beamlength)
% current 2 types of networks: triangle and kagome. I may add more as
% needed. 
% Check out this for patterns https://www.researchgate.net/profile/VS_Deshpande/publication/243685966/figure/fig1/AS:669983826796563@1536748000620/a-Kagome-lattice-b-triangular-lattice-and-c-hexagonal-lattice.png

    position = [];
    maxrows = ceil(sizey/beamlength/sqrt(3)*2);                            % number of points vertically
    rowlength = ceil(sizex/beamlength);                                    % number of points horizontally

    if type == "triangle"                                                  
        for row = 0:maxrows
            if rem(row,2) == 0                                             % this alternates the rows to allow for triangles
                tempx = (1:rowlength )*beamlength;
            else
                tempx = ([1:rowlength] + 0.5)*beamlength;
            end
            tempy = (ones(size(tempx))*row*sqrt(3)/2)*beamlength;
            position = [position ; tempx',tempy'];                         % collects the positions
        end

    elseif type == "kagome"
        for rowish = 0:ceil(maxrows/4)                                     % The pattern repeats every 4 rows.
            row = rowish*4;
            tempx = [1:rowlength]*beamlength;
            tempy = ones(size(tempx))*row*sqrt(3)/2*beamlength;
            position = [position ; tempx',tempy'];
            row = rowish*4+1;
            tempx = ([1:2:rowlength] + 0.5 )*beamlength;
            tempy = ones(size(tempx))*row*sqrt(3)/2*beamlength;
            position = [position ; tempx',tempy'];
            row = rowish*4+2;
            tempx = 1:rowlength*beamlength;
            tempy = ones(size(tempx))*row*sqrt(3)/2*beamlength;
            position = [position ; tempx',tempy'];
            row = rowish*4+3;
            tempx = ([1:2:rowlength] + 1.5)*beamlength;
            tempy = ones(size(tempx))*row*sqrt(3)/2*beamlength;
            position = [position ; tempx',tempy'];
        end
        
    elseif type == "hexigonal"
       rowlength = ceil(sizex/beamlength/sqrt(3)); 
       for rowish = 0:ceil(maxrows/3)                                      % should be working now
            row = rowish*3;
            tempx = [1:rowlength]*beamlength*sqrt(3);
            tempy = ones(size(tempx))*row*sqrt(3)/2*beamlength;
            position = [position ; tempx',tempy'];
            row = rowish*3+1/2;
            tempx = ([1:rowlength] + 0.5 )*beamlength*sqrt(3);
            tempy = ones(size(tempx))*row*sqrt(3)/2*beamlength;
            position = [position ; tempx',tempy'];
            row = rowish*3+3/2;
            tempx = ([1:rowlength] + 0.5 )*beamlength*sqrt(3);
            tempy = ones(size(tempx))*row*sqrt(3)/2*beamlength;
            position = [position ; tempx',tempy'];
            row = rowish*3+2;
            tempx = [1:rowlength]*beamlength*sqrt(3);
            tempy = ones(size(tempx))*row*sqrt(3)/2*beamlength;
            position = [position ; tempx',tempy'];
        end 
        
        

    elseif type == "rectangular"
        
    else
        print('incorrect inputs')

    end

    [n ,dim]= size(position);                                              % Connect the nodes that are close to each other
    positionmatrix = repmat(position,1,1,n);
    vectordistance = positionmatrix- permute(positionmatrix,[3 2 1]);
    scalerdistance = sqrt(vectordistance(:,1,:).^2 +vectordistance(:,2,:).^2);
    connectivitymatrix = scalerdistance < 1.1*beamlength;                  % change this if you need a different search distance
    connectivity = squeeze(connectivitymatrix);

    figure()
    gplot(connectivity,position)
    axis equal
    

end
