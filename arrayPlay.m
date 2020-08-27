 A = ones(4,1);
 B = zeros(4,1);
 F = [2 2 2 2]';
 G = [3 3 3 3]';
 C = [A B]; % A is in first column, B is in second column (4x2)
 D = [A; B]; % A is in first four rows, B is in second four rows (8x1)
 E = [A B F G]';
 H = [E' A]'
 for j = 1:5
     for i = 1:4
         fprintf('%d ', H(j,i));
     end
     fprintf('\n');
 end
 