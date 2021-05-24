function [position,connectivity, springs] = generategeometry(type,sizex,sizey,beamlength)
% current 2 types of networks: triangle and kagome. I may add more as
% needed. 
% Check out this for patterns https://www.researchgate.net/profile/VS_Deshpande/publication/243685966/figure/fig1/AS:669983826796563@1536748000620/a-Kagome-lattice-b-triangular-lattice-and-c-hexagonal-lattice.png

    position = [];
    maxrows = ceil(sizey/beamlength/sqrt(3)*2);                            % number of points vertically
    rowlength = ceil(sizex/beamlength);                                    % number of points horizontally

    if type == "triangle"                                                  
        for row = 0:maxrows
            if rem(row,2) == 0                                             % this alternates the rows to allow for triangles
                tempx = (1:rowlength)*beamlength;
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
       for rowish = 0:ceil(maxrows/4)                                      % should be working now
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
    figure
    plot(position(:,1), position(:,2), 'o')
    axis equal
    
    connectivity = sparse(length(position), length(position)); 
    springs = sparse(length(position), length(position)); 
    for i = 1:length(position)-1
        for j = 0:length(position)-1
            dist = sqrt((position(i,1) - position(j+1,1))^2 + (position(i,2) - position(j+1,2))^2);
            if dist < 1.1*beamlength && dist ~=0
                connectivity(j+1,i) = 1;
                springs(j+1,i) = dist;
            end
        end
    end
    
%     newsprings = pdist2(position, position);
%     connectivitymatrix = springs < 1.1*beamlength; % for loop for larger sizes
%     connectivitymatrix = connectivitymatrix.*(ones(size(connectivitymatrix, 1)) - eye(size(connectivitymatrix, 1))); % optimize for future
%     connectivity = sparse(connectivitymatrix);
%     springs = springs.*connectivitymatrix; 
%     springs = sparse(springs); 

    figure()
    gplot(connectivity,position)
    axis equal
    
    

end
