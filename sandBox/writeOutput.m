fid = fopen('output.txt','w');
for jj = 1 : 10
  fprintf( fid, '%d', jj );
end
% fprintf( fid, '\n');
fclose(fid);

fid = fopen('output.txt','r');
fscanf(fid,'%d');